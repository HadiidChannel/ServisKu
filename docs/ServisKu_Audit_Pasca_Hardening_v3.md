# ServisKu - Audit Pasca Hardening v3

**Tanggal pemeriksaan:** 9 November 2026  
**Sumber:** `servis(3).zip`, `android(3).zip`, dan log hasil Antigravity pada 9 November 2026  
**Metode:** static source review, pemeriksaan konfigurasi, pembacaan test, dan pencocokan RTM terhadap PRD/FSD.

## 1. Kesimpulan eksekutif

Perbaikan dari audit sebelumnya sudah masuk ke source untuk sejumlah area penting: validasi kronologi odometer, validasi path sibling-prefix, batas ukuran output lampiran 2MB, konsistensi MIME dan ekstensi hasil konversi PNG, filter laporan di database, prioritas jadwal menggunakan progress yang tidak di-clamp, serta penanganan kegagalan pembatalan notifikasi pada alur penghapusan jadwal dan kendaraan.

Namun, **ServisKu belum dapat dinyatakan selesai 100% atau siap rilis produksi**. Ada beberapa ketidaksesuaian nyata antara laporan Antigravity, kode yang dikirim, dan RTM. Temuan paling penting adalah alur izin notifikasi yang masih memiliki dua peminta izin, beberapa hasil kegagalan pembatalan alarm yang diabaikan, pemanggilan rekonsiliasi jadwal yang belum di-await, serta RTM yang berisi klaim kepatuhan yang saling bertentangan.

Pemeriksaan ini bersifat statis. Flutter dan Dart SDK tidak tersedia pada lingkungan audit ini, sehingga `flutter analyze`, `flutter test`, build APK, dan pengujian pada emulator tidak dijalankan ulang secara independen. Hasil tersebut hanya dapat dicatat sebagai hasil yang dilaporkan oleh Antigravity.

## 2. Temuan yang sudah diperbaiki atau terlihat di source

| Area | Hasil pemeriksaan |
|---|---|
| Odometer historis dan pembacaan awal | Diperbaiki. `validateOdometerChronology()` memasukkan seluruh sumber pembacaan, termasuk `initial`, dan menolak nilai historis yang lebih tinggi dari pembacaan bertanggal lebih baru. Ada test khusus untuk kasus tersebut. |
| Path sibling-prefix | Diperbaiki untuk pemeriksaan path leksikal. `_isSafePath()` menggunakan `p.equals()` dan `p.isWithin()`. Test untuk direktori saudara seperti `attachments_evil` tersedia. Pemeriksaan ini belum menyelesaikan symlink/canonical path. |
| Ukuran lampiran | Batas output 2MB diperiksa ulang sebelum file disimpan. Jika masih terlalu besar, `saveAttachment()` melempar `AttachmentException`. |
| MIME dan ekstensi PNG | Hasil konversi PNG besar ke JPEG menggunakan `image/jpeg` dan `.jpg`. Test khusus tersedia. |
| Laporan pengeluaran | Filter periode dan kendaraan diterapkan pada query `service_records`, lalu item dimuat dalam satu query batch. Lampiran tidak ikut dimuat untuk agregasi. Ini menghilangkan pola N+1 per record. |
| Prioritas jadwal | `unclampedProgress` digunakan oleh `compareScheduleUrgency()` dan test membandingkan tingkat keterlambatan menggunakan comparator produksi. |
| Penghapusan jadwal/kendaraan saat cancel gagal | `deleteSchedule()` mempertahankan jadwal jika pembatalan alarm gagal. `deleteMotorcycle()` mengembalikan hasil gagal dan mempertahankan kendaraan jika pembatalan alarm gagal. Test untuk kedua jalur tersedia. |
| Hasil cleanup lampiran | `AttachmentCleanupResult` memisahkan jumlah file terhapus, sudah hilang, dan gagal. Hasil tersebut digunakan oleh beberapa alur penghapusan. |
| Android manifest | Receiver notifikasi terjadwal dan boot receiver tersedia. `allowBackup="false"` serta exclusion rules untuk database dan file privat juga tersedia. |

## 3. Temuan yang masih perlu diperbaiki

### P1-01. Pemintaan izin notifikasi masih berpotensi ganda

**Lokasi:**
- `lib/features/settings/presentation/settings_screen.dart`, sekitar baris 46-63.
- `lib/features/settings/data/settings_repository.dart`, sekitar baris 79-92.
- `lib/features/maintenance/application/notification_reconciler.dart`, sekitar baris 424-431.

Saat switch notifikasi dinyalakan, `SettingsScreen._toggleNotifications()` memanggil `SettingsRepository.setNotificationsEnabled(true)`. Repository kemudian memanggil `onNotificationsEnabled()`, dan metode itu menjalankan `requestPermission()`. Setelah repository kembali, layar pengaturan juga memeriksa izin dan memanggil `requestPermission()` jika belum diberikan. Dengan demikian, permintaan izin tidak benar-benar memiliki satu pemilik seperti yang diklaim di laporan dan RTM.

Saat switch dimatikan, repository memanggil `onNotificationsDisabled()` tetapi tidak memeriksa `NotificationCancelResult` yang dikembalikan. UI juga tidak menerima hasil tersebut untuk menampilkan kegagalan pembatalan alarm atau memulihkan status switch.

**Perbaikan yang diperlukan:** pusatkan permintaan izin di satu lapisan saja. Repository sebaiknya menerima hasil izin atau hanya mengelola preferensi dan pembatalan. Kegagalan `cancelAllNotifications()` harus dikembalikan ke UI dan ditampilkan secara jujur.

### P1-02. Kegagalan pembatalan notifikasi masih diabaikan pada beberapa jalur

**Lokasi:**
- `lib/features/maintenance/data/maintenance_repository.dart`, sekitar baris 170-185.
- `lib/features/maintenance/application/notification_reconciler.dart`, sekitar baris 433-465.
- `lib/features/maintenance/application/notification_reconciler.dart`, sekitar baris 159-165.

`toggleActive()` menunggu `cancelJobsForSchedule()`, tetapi tidak memeriksa hasilnya. Jika pengguna menonaktifkan jadwal dan Android gagal membatalkan alarm, alur UI dapat tetap terlihat berhasil sementara alarm lama mungkin masih berada di sistem.

`handleTimezoneChanged()` juga memanggil `cancelNotification()` tanpa memeriksa hasilnya, lalu selalu mengubah status job menjadi `cancelled`. Ini dapat membuat database menganggap alarm lama sudah dibatalkan padahal operasi platform gagal.

Pada perubahan `plannedAt`, `reconcileForMotorcycle()` juga mengabaikan hasil cancel sebelum menjadwalkan ulang.

**Perbaikan yang diperlukan:** setiap jalur yang mengubah atau menghapus alarm harus memeriksa hasil cancel. Jangan menandai job `cancelled` sebelum pembatalan dikonfirmasi. Simpan status gagal untuk retry dan tampilkan status yang relevan kepada pengguna.

### P2-01. Rekonsiliasi notifikasi pada repository belum di-await dan dapat berjalan ganda

**Lokasi:** `lib/features/maintenance/data/maintenance_repository.dart`, sekitar baris 120-122 dan 165-167.

`createSchedule()` dan `updateSchedule()` memanggil `notificationReconciler!.reconcileAll()` tanpa `await`. Layar `maintenance_form_screen.dart` memang menjalankan rekonsiliasi kedua yang di-await setelah pemanggilan repository, tetapi pemanggilan tanpa `await` dari repository tetap berjalan bersamaan. Ini berpotensi menghasilkan dua proses rekonsiliasi untuk perubahan yang sama dan tidak sesuai dengan klaim bahwa seluruh pemanggilan sudah diawait.

**Perbaikan yang diperlukan:** tetapkan satu pemilik rekonsiliasi. Pilih apakah repository yang menjalankan serta meng-await rekonsiliasi, atau layar yang menjalankannya. Hapus pemanggilan ganda. Kegagalan platform tidak boleh menghapus data jadwal yang telah berhasil disimpan, tetapi harus dicatat dan dapat dicoba ulang.

### P1-04. Laporan menyebut rollback penghapusan database saat cleanup file gagal, tetapi kode tidak melakukannya

**Lokasi:**
- `lib/features/motorcycles/data/motorcycle_repository.dart`, sekitar baris 246-299.
- `lib/features/settings/data/settings_repository.dart`, sekitar baris 115-151.
- `lib/features/service_records/data/service_record_repository.dart`, sekitar baris 562-599.

Pada penghapusan kendaraan, transaksi SQLite selesai lebih dahulu. Setelah itu barulah file lampiran dihapus. Jika penghapusan file gagal, method mengembalikan `databaseSuccess: true` dan `attachmentsCleaned: false`. Database tidak di-rollback.

Pada `clearAllData()`, semua tabel dihapus dan transaksi di-commit sebelum `cleanupAllAttachments()` dijalankan. Jika cleanup file gagal, hasilnya dapat `databaseSuccess: true` dan `attachmentsCleaned: false`. Database tidak dipulihkan.

Pada `deleteRecord()` dan `deleteAttachment()`, hasil `AttachmentCleanupResult` juga diabaikan oleh repository. Pembersihan orphan pada saat aplikasi resume memang tersedia dan dapat membersihkan file yang tidak lagi direferensikan, tetapi ini bukan rollback atomik seperti yang ditulis dalam laporan.

**Perbaikan yang diperlukan:** pilih dan dokumentasikan strategi yang benar. Pilihan yang realistis adalah mengakui bahwa penghapusan database dan filesystem merupakan dua operasi berbeda, menyimpan status cleanup yang tertunda secara persisten, menjalankan retry, dan memastikan UI menampilkan hasil parsial. Jangan menulis bahwa database rollback bila source tidak melakukannya. Jika tetap menginginkan penghapusan atomik, implementasikan staging/trash dan mekanisme pemulihan file yang benar-benar diuji.

### P2-01. State loading dashboard didefinisikan tetapi belum digunakan di UI

**Lokasi:**
- `lib/app/providers/app_providers.dart`, sekitar baris 266-337.
- `lib/features/dashboard/presentation/dashboard_screen.dart`, sekitar baris 399-423, 553-589, dan 621-637.

Provider mengisi `DashboardSummary.isLoading`, tetapi `DashboardScreen` tidak membaca field tersebut. Saat stream jadwal belum mengirim data, daftar kosong dapat ditampilkan sebagai empty state. Saat riwayat belum tersedia, pengguna dapat melihat pesan seolah belum ada servis. Biaya bulanan juga menggunakan `value ?? 0` dan tidak memiliki flag loading khusus, sehingga angka Rp0 dapat tampil sebelum query selesai.

Error jadwal memiliki tombol coba lagi. Error riwayat dan biaya hanya menampilkan pesan, tanpa retry per bagian. Pull-to-refresh tersedia, tetapi tidak menggantikan representasi loading yang benar.

**Perbaikan yang diperlukan:** tampilkan loading state per bagian, jangan menyamakan belum ada data dengan data yang sedang dimuat, dan sediakan retry untuk error yang dapat dipulihkan.

### P2-02. Test perubahan timezone belum membuktikan alarm benar-benar dijadwalkan ulang

**Lokasi:** `test/unit/hardening_compliance_test.dart`, sekitar baris 382-410.

Test hanya memverifikasi bahwa nilai timezone tersimpan sebagai `Asia/Makassar`. Test tidak memverifikasi ID notifikasi yang dibatalkan, jumlah pemanggilan schedule baru, tanggal/waktu target, atau perilaku saat cancellation gagal. Mock yang digunakan juga tidak membuktikan integrasi plugin Android yang sebenarnya.

**Perbaikan yang diperlukan:** tambahkan assertion terhadap cancel dan schedule pada mock yang eksplisit. Pengujian dengan plugin/Android tetap perlu dilakukan pada emulator atau perangkat.

### P2-03. RTM berisi kontradiksi dan beberapa klaim yang tidak sesuai source

**Lokasi:** `docs/ServisKu_Requirements_Traceability_Matrix.md`.

Bagian yang sudah benar: semua **89 FR** dan **31 NFR** dari PRD tercakup sebagai 120 ID unik. Tidak ditemukan ID yang hilang atau ID tambahan.

Masalah yang ditemukan:

1. Baris 34 menyatakan tidak ada requirement berstatus `Patuh`, tetapi pemeriksaan tabel menemukan **35 baris berstatus Patuh**.
2. Ringkasan baris 295-297 menyatakan seluruh scope P0 terpenuhi, padahal terdapat banyak requirement P0 yang masih berstatus `Belum diverifikasi`.
3. Baris 11 masih menyebut snapshot `servis(2).zip` dan `android(2).zip`, bukan source terbaru `servis(3).zip` dan `android(3).zip`.
4. `FR-SET-04` menyatakan kegagalan cleanup lampiran membatalkan penghapusan database. Source melakukan commit database sebelum cleanup file.
5. `FR-NOT-02` menyatakan alur izin sudah single-owner, padahal ada dua pemanggilan dari repository dan layar pengaturan.
6. `FR-REP-04` menyebut agregasi SQL per bulan. Source memfilter record di SQLite dan mengambil item secara batch, tetapi total bulanan dan kategori dibangun dalam Dart, bukan `GROUP BY` SQL seperti klaim matriks.
7. `NFR-REL-03` mengklaim seluruh rekonsiliasi sudah di-await. `createSchedule()` dan `updateSchedule()` masih memiliki pemanggilan tanpa `await`.
8. `FR-DASH-02` mengklaim loading state sudah ditangani, tetapi `summary.isLoading` belum digunakan di layar dashboard.
9. Catatan akhir baris 299 menyebut semua temuan audit sudah selesai, padahal temuan di atas masih terlihat di source.

**Perbaikan yang diperlukan:** perbarui tanggal dan nama snapshot, koreksi status dan catatan berdasarkan source terbaru, hapus klaim Patuh yang belum memiliki acceptance test dan bukti runtime yang memadai, serta samakan ringkasan dengan status tabel.

### P2-04. Batas SDK pada pubspec tidak selaras dengan lockfile

**Lokasi:**
- `pubspec.yaml`, baris 6-8.
- `pubspec.lock`, bagian `sdks` di sekitar baris 1037-1039.

`pubspec.yaml` menyatakan Dart `>=3.4.0` dan Flutter `>=3.22.0`, sedangkan lockfile mencantumkan Dart `>=3.13.0` dan Flutter `>=3.47.0`. Klaim batas minimum SDK yang sekarang ditulis tidak cocok dengan dependency resolution yang dikirim.

**Perbaikan yang diperlukan:** samakan environment constraints dengan versi SDK minimum yang benar-benar diperlukan dependency yang terkunci, atau turunkan versi dependency agar cocok dengan SDK minimum yang ingin didukung. Jalankan `flutter pub get`, `flutter analyze`, dan `flutter test` pada versi SDK minimum yang dinyatakan.

### P2-05. Path containment belum membuktikan perlindungan symlink

**Lokasi:** `lib/core/services/attachment_storage_service.dart`, sekitar baris 237-241 dan `test/unit/attachment_management_test.dart`, sekitar baris 248-260.

`p.isWithin()` dan `p.normalize()` memeriksa relasi path secara leksikal. Keduanya tidak menyelesaikan symlink menjadi target filesystem sebenarnya. Test yang ada menguji sibling-prefix, tetapi belum menguji path melalui symlink. Dengan demikian, temuan path sibling-prefix telah diperbaiki, tetapi klaim perlindungan path yang lebih luas belum sepenuhnya terbukti. Pada Android, direktori privat aplikasi membatasi kemampuan pihak luar membuat symlink, sehingga risiko praktis bergantung pada siapa yang dapat memodifikasi filesystem atau database aplikasi.

**Perbaikan yang diperlukan:** bila ingin mempertahankan klaim hardening path yang kuat, tambahkan canonical/real-path containment bila didukung platform, tolak symlink pada komponen path yang relevan, dan tambahkan test symlink pada platform yang mendukungnya. Jika tidak, batasi klaim dokumen pada perlindungan path traversal leksikal.

### P2-05. Pengelompokan jumlah test di laporan tidak sesuai struktur test

Dari deklarasi test yang dibaca secara statis pada source ZIP, ditemukan:
- 78 pemanggilan `test()` di folder unit.
- 7 pemanggilan `testWidgets()` di folder widget.
- 1 pemanggilan `test()` di folder integration.
- Total 86 deklarasi test.

Laporan Antigravity menyebut 77 unit, 8 widget, dan 1 end-to-end. Total 86 cocok, tetapi pengelompokan unit/widget berbeda dari source. Test integration yang ada menggunakan `NativeDatabase.memory()` dan memanggil repository secara langsung. Itu adalah repository workflow integration test, bukan pengujian end-to-end UI Android atau plugin notifikasi.

**Perbaikan yang diperlukan:** koreksi kategori laporan. Pisahkan test repository, widget, dan runtime Android. Jangan menyebut test integration memory sebagai E2E Android.

## 4. Kerapian paket dan kesiapan rilis

| Item | Hasil |
|---|---|
| File `.idea`, `servis.iml`, `.flutter-plugins-dependencies` | Masih ada di `servis(3).zip`; sebaiknya dikeluarkan dari paket source final. |
| `local.properties`, `.kotlin`, `servis_android.iml` | Masih ada di `android(3).zip`; sebaiknya dikeluarkan. `local.properties` berisi path SDK lokal mesin Windows. |
| Release signing | `android/app/build.gradle.kts` masih menggunakan debug signing untuk build type `release`. Ini dapat diterima untuk pengembangan lokal, tetapi bukan konfigurasi rilis publik. |
| APK di dalam ZIP | Tidak ada APK di kedua ZIP. Log Antigravity melaporkan APK debug berhasil dibuat, tetapi file APK tidak disertakan sehingga tidak dapat diperiksa di sini. |
| Uji perangkat | Belum dapat diklaim selesai dari bukti yang diberikan. Tetap perlu instalasi dan uji manual pada emulator/perangkat Android. |

## 5. Pemeriksaan test dan bukti

Log Antigravity melaporkan:
- `flutter analyze`: No issues found.
- `flutter test`: 86 tests passed.
- `flutter build apk --debug`: build berhasil.

Hasil tersebut belum dijalankan ulang oleh pemeriksa ini karena Flutter/Dart SDK tidak tersedia pada lingkungan audit. Selain itu, sebagian test yang disebut sebagai bukti masih belum menguji perilaku yang diklaim, khususnya:
- Test timezone hanya memeriksa nilai preference yang tersimpan.
- Tidak ada test UI dashboard yang memeriksa loading/error state untuk jadwal, servis, dan pengeluaran.
- Tidak ada test yang membuktikan kegagalan pembatalan notifikasi saat jadwal dinonaktifkan atau timezone berubah ditangani dan ditampilkan dengan benar.
- Test cleanup lampiran belum membuktikan skenario file deletion failure diikuti retry yang persisten.
- Test laporan membuktikan nilai total, bukan bahwa query benar-benar menggunakan SQL `GROUP BY` atau bahwa stream ringkasan mendeteksi semua perubahan item secara independen.
- Test path traversal membuktikan sibling-prefix, tetapi belum membuktikan serangan berbasis symlink.

## 6. Rekomendasi urutan perbaikan

1. Selesaikan P1-01 dan P1-02 agar izin dan alarm tidak memiliki alur ganda atau kegagalan yang disembunyikan.
2. Selesaikan P1-03 dengan meng-await seluruh rekonsiliasi setelah perubahan jadwal.
3. Selaraskan perilaku cleanup file dengan kontrak hasil penghapusan. Perbaiki implementasi atau koreksi klaim dokumentasi, lalu uji kondisi gagal dan retry.
4. Selesaikan loading/error state dashboard.
5. Rekonsiliasi seluruh status dan catatan RTM berdasarkan source terbaru. Jangan menulis bahwa seluruh P0 terpenuhi sebelum bukti satu-ke-satu tersedia.
6. Samakan batas SDK `pubspec.yaml` dengan dependency lockfile.
7. Rapikan ZIP source, lalu jalankan ulang test, analyze, build, serta uji manual Android.

## 7. Putusan audit

**Status: Perlu satu putaran perbaikan terarah sebelum dinyatakan final.**

Source menunjukkan progres nyata dan sejumlah temuan hardening telah diperbaiki. Namun klaim Antigravity bahwa seluruh temuan sudah selesai secara menyeluruh belum didukung oleh source dan RTM terbaru. Setelah P1 diselesaikan, dashboard, RTM, SDK constraints, dan bukti runtime diperbarui, lakukan audit final lagi sebelum menyebut ServisKu siap rilis.
