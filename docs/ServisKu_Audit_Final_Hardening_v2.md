# ServisKu Final Hardening: Audit Independen atas Source Terbaru

**Berkas yang diperiksa**
- `servis(2).zip`
- `android(2).zip`
- `Pasted text(20261109-133755).txt` sebagai laporan/jejak kerja Antigravity
- Dokumen `PRD_ServisKu_v1.1.md`, `FSD_ServisKu_v1.0.md`, dan `ServisKu_Compliance_Matrix.md` di dalam arsip terbaru

**Tanggal audit:** 9 November 2026  
**Jenis audit:** pemeriksaan statis source code, konfigurasi, pengujian yang disertakan, dan traceability dokumen.

---

## 1. Kesimpulan Eksekutif

**Status: belum layak dinyatakan final.**

Final Hardening sudah memperbaiki beberapa area nyata: evaluasi status kilometer dan tanggal dipisahkan, relasi service record dan odometer tersedia, manifest receiver notifikasi sudah ditambahkan, aturan Android backup tersedia, ilustrasi onboarding dipakai, dan alur laporan dibuat reaktif.

Namun, masih ada masalah penting yang bertentangan dengan klaim laporan Antigravity:

1. Hasil pembatalan notifikasi tidak selalu diperiksa sebelum data jadwal/motor/job dihapus. Platform notification yang gagal dibatalkan dapat tertinggal setelah data induknya terhapus.
2. Operasi penghapusan lampiran menelan exception. Akibatnya, repository dapat melaporkan `attachmentsCleaned = true` padahal penghapusan file gagal.
3. Validasi odometer historis mengabaikan pembacaan `initial` yang tanggalnya setelah tanggal historis. Catatan servis lama dengan kilometer lebih tinggi dari pembacaan odometer saat motor ditambahkan dapat diterima.
4. Halaman laporan masih menggunakan `watchRecords()` yang memuat seluruh riwayat beserta item dan attachment secara bertahap. Klaim bahwa seluruh laporan sudah menggunakan agregasi SQL satu query tanpa N+1 belum benar.
5. Dashboard hanya menangani loading/error pada stream kendaraan. Error atau loading dari jadwal, riwayat servis, dan expense stream masih dipetakan menjadi daftar kosong atau Rp0.
6. Perubahan timezone saat aplikasi resume belum memaksa penjadwalan ulang job tanggal yang masih berstatus `scheduled`.
7. Proteksi path menggunakan `startsWith()` tanpa batas separator direktori. Ini bukan pemeriksaan containment path yang aman.
8. Kompresi PNG dapat menghasilkan byte JPEG tetapi tetap menyimpan ekstensi dan MIME `image/png`. Batas target 2 MB juga belum ditegakkan sebagai batas final.
9. Compliance Matrix terbaru tidak benar-benar memetakan seluruh requirement PRD. Dari 89 ID requirement PRD, hanya 56 ID yang muncul dengan kode yang sama di matrix (62,9%). Matrix juga memakai ID `FR-SCH` yang tidak ada di PRD, mengubah arti beberapa ID, dan mencantumkan ambang reminder yang tidak ditemukan di PRD/FSD.
10. Deklarasi 77 test memang ditemukan, tetapi mayoritas adalah unit/widget tests dengan database memori dan mock. Tidak ada bukti bahwa seluruh perilaku runtime Android sudah diuji pada emulator atau perangkat.

Karena itu, klaim “seluruh S1, S2, dan S3 selesai” belum didukung oleh source yang saya periksa.

---

## 2. Ruang Lingkup dan Batas Verifikasi

### 2.1 Pemeriksaan arsip

Arsip terbaru berisi:
- 63 file Dart di `lib/`
- 21 file test
- 5 aset SVG
- 4 dokumen di `docs/`
- konfigurasi Android dari arsip terpisah

Dokumen compliance matrix, README, PRD, FSD, dan laporan audit sebelumnya tersedia di `docs/`.

### 2.2 Pengujian

Jumlah deklarasi test dalam source:
- 69 `test()` di folder `test/unit/`
- 7 `testWidgets()` di folder `test/widget/`
- 1 `test()` di folder `test/integration/`
- **Total: 77 deklarasi test**

Laporan Antigravity menyatakan 77/77 lulus, `flutter analyze` tanpa issue, dan APK debug berhasil dibangun. Jumlah deklarasi test dapat diverifikasi dari source, tetapi hasil eksekusi tidak dapat diverifikasi ulang di lingkungan audit ini.

**Batasan:** Flutter SDK, Dart SDK, emulator Android, dan APK hasil build tidak tersedia dalam lingkungan pemeriksaan ini. Karena itu:
- `flutter analyze` belum dijalankan ulang secara independen.
- `flutter test` belum dijalankan ulang secara independen.
- APK belum dijalankan atau diuji pada emulator/perangkat.
- Kualitas visual runtime belum dapat dinilai tanpa screenshot atau rekaman aplikasi.

---

## 3. Perbaikan yang Terbukti Sudah Masuk

| Area | Bukti source | Penilaian |
|---|---|---|
| Dimensi status km/tanggal | `maintenance_calculator.dart` menyediakan `kmStatus` dan `dateStatus` | Perbaikan ada |
| Notifikasi km | Reconciler membandingkan `result.kmStatus` | False-positive yang sebelumnya ditemukan sudah ditangani pada jalur utama |
| Relasi service odometer | Kolom `service_record_id` di `odometer_readings` | Perbaikan ada |
| Migrasi v1 ke v2 | `app_database.dart` dan fixture SQLite pada migration test | Implementasi migrasi serta test fixture nyata tersedia |
| Android notification receivers | `AndroidManifest.xml` mendeklarasikan scheduled dan boot receiver | Konfigurasi ada |
| Android backup exclusions | `allowBackup=false`, `backup_rules.xml`, `data_extraction_rules.xml` | Konfigurasi ada |
| Stream riwayat servis | `watchRecords()` memasukkan records, items, dan attachments di `readsFrom` | Reaktivitas attachment sudah diperhitungkan |
| Orphan cleanup | `runStartupOrphanCleanup()` dipanggil dari lifecycle resume | Integrasi ada pada app resume |
| Timezone refresh | `MainScaffold` memanggil `refreshDeviceTimezone()` sebelum `reconcileAll()` saat resumed | Refresh ada, tetapi reschedule masih bermasalah |
| Laporan | `watchReportSummary()` dan `watchCurrentMonthExpense()` tersedia | Reaktivitas sebagian tersedia |
| Onboarding SVG | Tiga ilustrasi SVG digunakan di `onboarding_screen.dart` | Integrasi ada |
| Reduced motion | Dashboard, status badge, dan onboarding memeriksa `disableAnimations` | Dukungan dasar ada |
| Dokumentasi | README dan Compliance Matrix telah dibuat | Ada, tetapi matrix perlu dikoreksi |

---

## 4. Temuan Prioritas S1: Harus Diperbaiki Sebelum Final

### S1-01. Kegagalan pembatalan notifikasi dapat hilang dari database sebelum platform notification dibatalkan

**File dan lokasi**
- `lib/features/settings/data/settings_repository.dart`, sekitar baris 95-117
- `lib/features/maintenance/application/notification_reconciler.dart`, sekitar baris 344-403
- `lib/features/maintenance/data/maintenance_repository.dart`, sekitar baris 187-195
- `lib/features/motorcycles/data/motorcycle_repository.dart`, sekitar baris 210-258

**Bukti**
- `cancelAllNotifications()` mengembalikan `NotificationCancelResult`, tetapi `SettingsRepository.clearAllData()` hanya menunggu Future dan tidak memeriksa `result.isSuccess`. Jika method mengembalikan `{isSuccess: false}` tanpa melempar exception, `notifsCancelled` tetap diatur `true`.
- `cancelJobsForSchedule()` menandai job gagal bila cancellation gagal, tetapi `deleteSchedule()` tetap menghapus schedule. Foreign key `ON DELETE CASCADE` kemudian menghapus row notification job yang gagal tersebut.
- `deleteMotorcycle()` menjalankan pembatalan notification tetapi tidak menerima hasil kegagalan. Database kemudian menghapus motorcycle dan seluruh schedule/job terkait.
- `clearAllData()` menghapus seluruh `notification_jobs` setelah pemanggilan cancelAll, sekalipun platform cancellation mengembalikan kegagalan.

**Dampak**
Android dapat masih memiliki scheduled notification setelah schedule, motorcycle, atau seluruh data aplikasi sudah dihapus. Karena ID job yang dibutuhkan untuk retry sudah hilang dari SQLite, aplikasi kehilangan catatan untuk mencoba membatalkannya kembali.

**Perbaikan**
- Periksa `NotificationCancelResult.isSuccess`.
- Buat hasil pembatalan terstruktur untuk satu schedule, satu motorcycle, dan semua notification.
- Jangan hapus parent/job yang diperlukan untuk retry sebelum platform cancellation dikonfirmasi.
- Alternatif yang aman: gagalkan atau tunda penghapusan schedule/motor ketika cancellation belum berhasil, atau simpan cleanup tombstone terpisah yang tidak ikut cascade.
- Tambahkan tes platform cancellation failure untuk delete schedule, delete motorcycle, dan clear-all.

### S1-02. Attachment cleanup menelan error sehingga hasil penghapusan dapat menyatakan sukses secara keliru

**File dan lokasi**
- `lib/core/services/attachment_storage_service.dart`, sekitar baris 333-371 dan 444-452
- `lib/features/motorcycles/data/motorcycle_repository.dart`, sekitar baris 260-280
- `lib/features/settings/data/settings_repository.dart`, sekitar baris 128-141
- `lib/features/settings/presentation/settings_screen.dart`, sekitar baris 105-132

**Bukti**
- `deleteAttachmentFile()` menangkap semua exception dan tidak mengembalikan status.
- `deleteRecordAttachmentsDirectory()` juga menangkap semua exception dan tidak mengembalikan status.
- `cleanupAllAttachments()` menangkap semua exception dan tidak mengembalikan status.
- `MotorcycleRepository.deleteMotorcycle()` mengubah `attachmentsCleaned` menjadi `false` hanya ketika method cleanup melempar exception. Karena service menelan error, flag dapat tetap `true`.
- `SettingsRepository.clearAllData()` mengatur `attachmentsCleaned = true` jika `cleanupAllAttachments()` selesai tanpa throw. Implementasi service saat ini menelan kegagalan, sehingga nilai `true` bukan bukti file sudah terhapus.

**Dampak**
UI dapat menyatakan seluruh foto nota sudah dihapus padahal sebagian file masih berada di direktori privat. Ini bertentangan dengan requirement privasi dan laporan penghapusan yang jujur.

**Perbaikan**
- Ganti method penghapusan file menjadi `Future<CleanupResult>` atau biarkan exception diteruskan ke repository.
- Bedakan `deleted`, `alreadyMissing`, dan `failed`.
- Jangan menyatakan cleanup penuh berhasil jika ada file yang gagal dihapus.
- Simpan cleanup retry yang tahan terhadap restart aplikasi.
- Tambahkan tes dengan filesystem adapter yang sengaja gagal menghapus file/direktori.

### S1-03. Validasi odometer mengabaikan pembacaan awal kendaraan untuk catatan servis historis

**File dan lokasi**
- `lib/core/validators/app_validators.dart`, sekitar baris 110-124

**Bukti**
Kode mengabaikan pembacaan yang `source == 'initial'` apabila tanggal pembacaan awal lebih baru daripada tanggal catatan yang sedang dimasukkan.

**Contoh dampak**
- Motor pertama kali dicatat pada 9 November dengan odometer 5.000 km.
- Pengguna menambahkan catatan servis tanggal 1 Oktober dengan odometer 6.000 km.
- Karena pembacaan awal 9 November diabaikan, nilai 6.000 km dapat lolos walaupun pembacaan yang lebih baru hanya 5.000 km.

**Perbaikan**
- Perlakukan pembacaan awal sebagai batas kronologis yang valid, sama seperti pembacaan lain.
- Jika data historis benar-benar membutuhkan pengecualian karena reset/replace odometer, gunakan alur koreksi eksplisit dengan alasan dan dampak yang jelas.
- Tambahkan test historical reading yang lebih tinggi daripada initial odometer.

---

## 5. Temuan Prioritas S2: Integritas, Keamanan, dan Keandalan

### S2-01. Report summary masih menggunakan pola N+1 dan memuat data yang tidak dibutuhkan

**File dan lokasi**
- `lib/features/reports/data/report_repository.dart`, sekitar baris 82-95 dan 98-112
- `lib/features/service_records/data/service_record_repository.dart`, sekitar baris 119-141

**Bukti**
`watchReportSummary()` memanggil `serviceRecordRepository.watchRecords()`. `getRecords()` mengambil seluruh service records, lalu melakukan query terpisah untuk setiap record guna mengambil item dan attachment. Filter periode dilakukan setelah seluruh record dimuat di Dart.

Kueri agregasi SQL pada `getCurrentMonthExpense()` hanya menangani ringkasan bulan berjalan. Itu tidak membuat seluruh laporan periode dan breakdown kategori menjadi satu query SQL.

**Dampak**
- Semua histori dapat dimuat meskipun pengguna memilih rentang pendek.
- Metadata attachment ikut dimuat padahal laporan tidak memerlukannya.
- Jumlah query bertambah seiring jumlah service record.
- Matriks kepatuhan saat ini melebih-lebihkan optimasi laporan.

**Perbaikan**
- Buat query report terpisah dari `watchRecords()`.
- Terapkan filter tanggal dan motorcycle ID di SQLite.
- Agregasikan biaya per periode, bulan, dan kategori di SQL.
- Jangan mengambil attachment untuk laporan.
- Pertahankan sumber perhitungan biaya agar item dan additional cost tidak dihitung ganda.

### S2-02. Dashboard masih menyamakan loading/error menjadi data kosong atau nol

**File dan lokasi**
- `lib/app/providers/app_providers.dart`, sekitar bagian `dashboardSummaryProvider`
- `lib/features/dashboard/presentation/dashboard_screen.dart`, sekitar baris 95 dan bagian pemuatan ringkasan

**Bukti**
`dashboardSummaryProvider` mengambil:
- `schedulesAsync.value ?? []`
- `recordsAsync.value ?? []`
- `monthExpenseAsync.value ?? 0`

Ini berarti loading/error pada jadwal, riwayat servis, atau expense dapat disajikan sebagai daftar kosong dan Rp0. `DashboardScreen` sudah menangani loading/error stream kendaraan, tetapi tidak menangani status semua sumber dashboard.

**Dampak**
Pengguna dapat melihat “belum ada jadwal”, tidak ada aktivitas, atau Rp0 ketika sebenarnya query gagal atau belum selesai.

**Perbaikan**
Buat typed aggregate dashboard state yang menampung loading/error/loaded per sumber data atau satu status agregat dengan partial failure. Jangan mengubah query error menjadi empty state.

### S2-03. Timezone diperbarui, tetapi pending date notification tidak otomatis dijadwalkan ulang

**File dan lokasi**
- `lib/app/widgets/main_scaffold.dart`, sekitar baris 30-65
- `lib/features/maintenance/application/notification_reconciler.dart`, sekitar bagian date job
- `lib/core/services/notification_service.dart`, sekitar baris 228-230

**Bukti**
`MainScaffold` refresh timezone lalu memanggil `reconcileAll()`. Namun, reconciler mempertahankan job `scheduled` bila `existingJob.plannedAt == reminderDateIso`. `plannedAt` menyimpan waktu kalender dari reminder date, bukan identitas timezone perangkat ketika platform schedule dibuat.

**Dampak**
Saat zona waktu berubah, existing Android alarm dapat tetap terpasang pada timestamp lama meskipun aplikasi sudah mengganti `tz.local`.

**Perbaikan**
- Simpan timezone ID atau fingerprint timezone pada job yang dijadwalkan.
- Ketika timezone berubah, cancel pending date reminders yang relevan dan schedule ulang pada jam lokal yang benar.
- Jangan ubah atau reschedule kilometer-triggered notifications karena tidak berbasis waktu.
- Tambahkan test yang memverifikasi cancellation dan rescheduling, bukan sekadar memanggil mock `refreshDeviceTimezone()`.

### S2-04. Permission notification dapat diminta dua kali ketika toggle diaktifkan

**File dan lokasi**
- `lib/features/settings/presentation/settings_screen.dart`, sekitar baris 46-59
- `lib/features/settings/data/settings_repository.dart`, sekitar baris 79-92
- `lib/features/maintenance/application/notification_reconciler.dart`, sekitar baris 406-410

**Bukti**
`SettingsRepository.setNotificationsEnabled(true)` memanggil `onNotificationsEnabled()`, yang melakukan `requestPermission()`. Setelah itu `_toggleNotifications()` kembali memanggil `requestPermission()` karena `_hasDevicePermission` belum diperbarui sebelum call repository selesai.

**Dampak**
Permission flow menjadi redundan dan state izin dapat membingungkan.

**Perbaikan**
Pilih satu pemilik permission flow. Sebelum meminta izin, cek status izin saat ini. Setelah granted, jalankan satu kali `reconcileAll()`.

### S2-05. Validasi containment path belum aman terhadap prefix sibling directory

**File dan lokasi**
- `lib/core/services/attachment_storage_service.dart`, sekitar baris 176-180

**Bukti**
`_isSafePath()` menggunakan `normTarget.startsWith(normBase)`.

**Dampak**
Path seperti `/.../attachments_evil/file.jpg` memiliki prefix `/.../attachments` dan dapat lolos pemeriksaan string meskipun berada di sibling directory, bukan di dalam attachment root.

**Perbaikan**
Gunakan containment check berbasis segment/path separator, misalnya pemeriksaan parent-child yang benar setelah normalisasi canonical path. Tangani symlink bila relevan. Tambahkan tes path `..`, absolute path luar, sibling prefix, dan nested path valid.

### S2-06. PNG dapat disimpan sebagai JPEG dengan ekstensi dan MIME yang salah

**File dan lokasi**
- `lib/core/services/attachment_storage_service.dart`, sekitar baris 125-138 dan 286-325

**Bukti**
Ketika input PNG melebihi target ukuran, `_processImageIsolate()` mengganti bytes dengan `encodeJpg()`. Namun `saveAttachment()` tetap memilih ekstensi dan metadata MIME dari `validation.mimeType`, yaitu `image/png`.

**Dampak**
File berisi JPEG tetapi bernama `.png` dan tercatat sebagai `image/png`. Ini membuat metadata tidak konsisten dengan konten berkas.

**Perbaikan**
Kembalikan output MIME/extension dari image processing result. Simpan file dengan ekstensi serta MIME yang cocok dengan bytes yang benar-benar dihasilkan. Pertahankan kualitas teks nota.

### S2-07. Batas target 2 MB belum ditegakkan sebagai batas final

**File dan lokasi**
- `lib/core/services/attachment_storage_service.dart`, sekitar baris 125-138 dan 295-325

**Bukti**
JPEG berhenti menurunkan quality ketika mencapai 40, lalu output tetap diterima tanpa memeriksa apakah masih lebih besar dari `maxOutputBytes`. Jalur PNG yang dikonversi ke JPEG juga tidak memastikan hasil akhirnya <= 2 MB.

**Dampak**
Konstanta dinamai target 2 MB, tetapi file yang lebih besar masih dapat disimpan.

**Perbaikan**
Periksa ukuran akhir. Jika batas masih terlampaui, lakukan strategi tambahan yang aman atau tolak file dengan pesan yang jelas. Jangan mengklaim target 2 MB sebagai hard limit sebelum ada validasi akhir.

### S2-08. Pengurutan jadwal overdue kehilangan tingkat keterlambatan

**File dan lokasi**
- `lib/features/maintenance/domain/maintenance_calculator.dart`, sekitar baris 57-64 dan 91-107
- `lib/app/providers/app_providers.dart`, fungsi `compareScheduleUrgency`

**Bukti**
Progress kilometer dan tanggal di-clamp ke `0.0..1.0`. Semua jadwal yang sudah overdue menjadi progress `1.0`. Comparator kemudian memakai nama jadwal sebagai tie-breaker.

**Dampak**
Dalam kelompok `Terlambat`, jadwal yang baru lewat sedikit dan jadwal yang sangat terlambat dapat memiliki prioritas sama. Ini tidak merepresentasikan tingkat urgensi aktual.

**Perbaikan**
Gunakan nilai keterlambatan relatif yang tidak di-clamp atau tie-breaker overdue yang sesuai dengan dimensi aktif. Jangan membandingkan raw km dengan raw days.

### S2-09. Reconciliation dipanggil tanpa await dan dari dalam transaksi

**File dan lokasi**
- `lib/features/maintenance/data/maintenance_repository.dart`, sekitar baris 251-253
- `lib/features/service_records/data/service_record_repository.dart`, sekitar baris 265-269 dan 310-312; jalur update/delete juga perlu ditinjau
- `lib/features/odometer/data/odometer_repository.dart`, sekitar baris 111-114

**Bukti**
Beberapa method memanggil `notificationReconciler.reconcileAll()` tanpa `await`. `recalculateSchedule()` dipanggil dari dalam transaksi service record dan juga memulai reconciliation sebelum transaksi induk selesai.

**Dampak**
- Reconciliation dapat berjalan bersamaan/duplikat.
- Job dapat diproses berdasarkan state sebelum commit.
- Error tidak dapat dikaitkan dengan operasi yang memicunya.
- Efek samping platform dapat terjadi sebelum transaksi data dinyatakan selesai.

**Perbaikan**
Jangan menjalankan platform notification side effects di dalam transaksi database. Commit perubahan terlebih dahulu, lalu jalankan satu reconciliation terkoordinasi dan awaited setelah commit. Hindari beberapa pemanggilan redundant untuk jadwal yang sama dalam satu operasi.

### S2-10. SDK constraints masih tidak konsisten

**File**
- `pubspec.yaml`
- `pubspec.lock`
- `README.md`

**Bukti**
`pubspec.yaml` mendeklarasikan Dart `>=3.2.0 <4.0.0`, sedangkan lockfile mencatat:
- Dart `>=3.13.0 <4.0.0`
- Flutter `>=3.47.0`

**Dampak**
Constraint project menyatakan kompatibilitas minimum yang tidak didukung oleh dependency resolution terkunci.

**Perbaikan**
Samakan minimum Dart dan Flutter pada `pubspec.yaml`, lockfile, dan README berdasarkan toolchain yang benar-benar dipakai. Jangan mengklaim dukungan Dart 3.2.

---

## 6. Temuan pada Compliance Matrix dan Test Evidence

### 6.1 Compliance Matrix bukan pemetaan lengkap PRD

Pemeriksaan otomatis terhadap ID requirement menghasilkan:
- ID FR unik di PRD: **89**
- ID FR unik di Compliance Matrix: **63**
- ID yang cocok persis: **56 dari 89 (62,9%)**
- ID PRD yang tidak muncul dengan kode yang sama: **33**
- ID yang muncul di matrix tetapi tidak ada di PRD: `FR-SCH-01` sampai `FR-SCH-06` dan `FR-SET-05`

Masalah utama:
- PRD memakai `FR-MNT`, tetapi matrix menggantinya dengan `FR-SCH`.
- Matrix menghilangkan sejumlah requirement P0/P1 seperti `FR-MNT-01..13`, `FR-NOT-09..10`, `FR-ODO-07..08`, `FR-SRV-07..10`, dan seluruh `FR-BKP-01..06`.
- Beberapa ID yang sama dipasangkan dengan deskripsi berbeda dari PRD. Contoh: `FR-ATT-01` di PRD adalah penambahan lampiran ke kunjungan servis, sedangkan matrix menggambarkannya sebagai pilihan galeri/kamera (yang merupakan bagian FR-ATT-02).
- Matrix menyebut ambang 500 km atau 10% interval dan 14 hari atau 15% interval. Logika 10%, 14 hari, dan 15% tidak ditemukan pada PRD/FSD maupun kalkulator yang diperiksa.
- Matrix menyatakan banyak bagian `Patuh` tanpa test yang benar-benar memverifikasi behavior-nya.

**Kesimpulan:** Compliance Matrix harus dibuat ulang langsung dari ID dan wording PRD/FSD. Jangan memakai kode kebutuhan yang dibuat sendiri.

### 6.2 Test count benar, tetapi cakupan belum mendukung semua klaim

77 deklarasi test ditemukan. Namun:

- `test/integration/app_workflows_integration_test.dart` menggunakan `NativeDatabase.memory()` dan repository langsung. Ini integration-style repository workflow, bukan full end-to-end Android UI/plugin test.
- `hardening_compliance_test.dart` menguji `MaintenanceCalculator` untuk pemisahan dimensi, tetapi tidak menjalankan `NotificationReconciler` untuk membuktikan tidak ada false-positive notification.
- Tes timezone memanggil mock `refreshDeviceTimezone()` yang hanya menaikkan counter, bukan plugin/platform timezone.
- Mock notification cancellation yang ada umumnya selalu sukses. Failure path untuk delete schedule/motor/full deletion belum terbukti.
- Attachment tests tidak membuktikan containment path sibling-prefix, output compression <= 2 MB, atau konsistensi MIME setelah PNG fallback JPEG.
- Dashboard sorting test membuat comparator lokal di test. Test tersebut tidak memanggil `compareScheduleUrgency()` produksi, sehingga tidak membuktikan comparator yang dipakai dashboard.
- Tidak ditemukan test yang memverifikasi error state dari schedule stream, records stream, dan expense stream secara terpisah.

### 6.3 Verifikasi runtime belum terbukti

Laporan Antigravity menyatakan:
- 77/77 tests passed.
- Flutter analyze 0 issue.
- `flutter build apk --debug` berhasil.

Saya tidak menjalankan ulang perintah tersebut karena Flutter/Dart SDK tidak ada pada lingkungan audit. ZIP yang diterima juga tidak menyertakan APK hasil build. Tidak ada bukti screenshot emulator atau Android device test untuk reboot, timezone change, permission, notification delivery, maupun data deletion.

---

## 7. Packaging dan Release Readiness

### 7.1 Arsip Android masih memuat file lokal

Walaupun laporan menyebut pembersihan selesai, `android(2).zip` masih berisi:
- `local.properties`
- direktori `.kotlin/`

`servis(2).zip` juga memuat `.idea/`, `servis.iml`, dan `.flutter-plugins-dependencies`.

Ini tidak selalu merusak project, tetapi arsip distribusi source perlu dibersihkan. `local.properties` tidak boleh dibagikan karena berisi path SDK khusus mesin developer.

### 7.2 Release signing

`android/app/build.gradle.kts` masih menggunakan debug signing untuk build type `release`:

`signingConfig = signingConfigs.getByName("debug")`

Ini dapat diterima untuk development atau demonstrasi lokal, tetapi bukan konfigurasi release publik. Siapkan release keystore melalui environment/secret manager sebelum distribusi. Jangan memasukkan keystore atau password ke repository.

---

## 8. Status Akhir per Area

| Area | Status audit | Catatan |
|---|---|---|
| Database schema dan migrasi v1-v2 | Sebagian besar sesuai | Migration fixture nyata tersedia; tetap perlu perluasan fixture |
| Odometer chronology | Belum sesuai penuh | Initial reading dapat dilewati untuk historical input |
| Service record integrity | Sebagian besar sesuai | Repository mengunci perubahan motorcycleId; cek atomicity dan reconciliation |
| Maintenance calculation | Sebagian besar sesuai | Dimensi km/tanggal sudah terpisah |
| Notification lifecycle | Belum sesuai penuh | Failure cancellation dapat kehilangan job setelah cascade |
| Timezone | Sebagian sesuai | Refresh ada, pending schedule belum dijadwalkan ulang saat zone berubah |
| Attachment storage | Belum sesuai penuh | Cleanup status tidak dapat dipercaya; MIME mismatch dan path containment |
| Data deletion | Belum sesuai penuh | Platform cancellation result dan cleanup result dapat dilaporkan keliru |
| Expense reports | Sebagian sesuai | Stream reaktif ada, tetapi full report masih memuat records/items/attachments secara N+1 |
| Dashboard | Sebagian sesuai | Loading/error motor ditangani; child streams masih collapse ke empty/zero |
| UI/UX | Belum dapat dinilai runtime | Asset dan animasi terlihat di source; tidak ada screenshot/emulator di arsip |
| Security/privacy | Sebagian sesuai | Backup exclusion ada; path containment perlu diperbaiki |
| Compliance Matrix | Tidak valid sebagai matrix lengkap | 56/89 exact ID coverage; terdapat ID dan threshold buatan |
| Automated testing | Sebagian sesuai | 77 deklarasi; sebagian besar unit/widget/mocked |
| Android release readiness | Belum siap publik | Debug signing, perlu device verification dan packaging clean |

---

## 9. Urutan Perbaikan yang Disarankan

**Wave 1: Integritas dan privasi**
1. Perbaiki handling hasil pembatalan notifikasi.
2. Jangan cascade-delete notification jobs yang masih diperlukan untuk retry.
3. Buat cleanup attachment mengembalikan status yang benar.
4. Perbaiki chronology validation untuk initial odometer dan historical service.

**Wave 2: Notification dan data reactivity**
5. Reschedule date notifications ketika timezone berubah.
6. Satukan permission request ke satu pathway.
7. Perbaiki dashboard child-stream states.
8. Pindahkan seluruh report filtering/aggregation ke query SQL yang efisien.

**Wave 3: Attachment dan perhitungan**
9. Perbaiki path containment.
10. Konsistenkan output image bytes, extension, dan MIME.
11. Tegakkan max output size.
12. Perbaiki prioritas jadwal overdue.
13. Jalankan notification reconciliation setelah transaksi commit dan tunggu hasilnya.

**Wave 4: Evidence dan release**
14. Buat ulang Compliance Matrix langsung dari 89 PRD requirement.
15. Tambahkan tests untuk setiap failure path.
16. Jalankan Flutter analyze/test/build di lingkungan developer.
17. Uji actual Android notification, reboot, timezone, permission, camera/gallery, dan penghapusan data.
18. Bersihkan ZIP/Git package dan siapkan release signing.

---

## 10. Keputusan

**Jangan membuat fitur baru dan jangan redesign besar dahulu.**

Source terbaru menunjukkan kemajuan substansial, tetapi masih ada masalah yang bisa menyebabkan:
- Notifikasi lama muncul setelah jadwal atau motor dihapus.
- Data foto tetap tertinggal meskipun UI menyatakan cleanup berhasil.
- Kilometer historis tidak konsisten.
- Laporan lambat ketika riwayat tumbuh.
- Pengguna melihat state kosong palsu ketika query gagal.

Fokus perbaikan berikutnya harus pada Wave 1, khususnya pembatalan notifikasi dan hasil cleanup yang jujur. Setelah itu baru lanjut ke Wave 2-4.

**Verdict:** ServisKu belum final. Perlu satu siklus targeted repair tambahan dan validasi runtime Android sebelum dinyatakan siap sebagai MVP yang stabil.
