# ServisKu - Audit Kesesuaian PRD/FSD, Source Code, Android, UX, dan QA

**Basis audit:** source terbaru dari `servis(1).zip` dan `android(1).zip`, laporan kerja Antigravity `Pasted text(20261108-193426).txt`, PRD ServisKu v1.1, dan FSD ServisKu v1.0.  
**Tanggal audit:** 9 November 2026.  
**Jenis audit:** static source review dan requirements traceability.  
**Status:** belum layak dinyatakan final sebelum temuan prioritas tinggi diperbaiki dan pengujian runtime Android dilakukan.

---

## 1. Ringkasan eksekutif

ServisKu mempunyai fondasi teknis yang cukup baik: Flutter, Riverpod, go_router, SQLite melalui Drift, pemisahan presentation/application/domain/data, transaksi database untuk proses multi-tabel, penyimpanan lampiran lokal, dan notifikasi lokal. Sebagian besar fitur P0 sudah memiliki implementasi nyata, bukan hanya mock UI.

Namun, audit lintas modul masih menemukan beberapa ketidaksesuaian yang berpengaruh pada data, pengingat, privasi, dan tampilan laporan:

1. **Pengingat kilometer dapat terpicu oleh status tanggal.** Reconciler memakai status gabungan untuk mengirim notifikasi kilometer, walaupun batas kilometer sendiri masih Aman.
2. **Odometer dapat turun karena catatan servis.** Create/update catatan servis langsung membuat atau memperbarui pembacaan odometer tanpa memeriksa apakah angka tersebut lebih rendah dari pembacaan terkini.
3. **Hapus motor tidak menghapus foto nota secara fisik.** SQLite menghapus metadata lampiran melalui cascade, tetapi repository kendaraan tidak menghapus direktori foto terkait.
4. **Laporan biaya tidak reaktif terhadap perubahan riwayat servis.** Halaman laporan membuat Future baru tetapi tidak mengamati stream servis. Data bisa tetap lama setelah servis dibuat, diedit, atau dihapus selama halaman masih aktif.
5. **Android Auto Backup berpotensi menyalin database dan foto ke backup akun Google.** Manifest tidak mengatur `android:allowBackup`, `dataExtractionRules`, atau aturan backup lama. Ini bertentangan dengan pernyataan UI yang menyebut data tidak dikirim ke pihak mana pun, kecuali perilaku backup OS memang dijelaskan/diizinkan.
6. **Penghapusan semua data dapat melaporkan sukses walau file foto gagal dihapus.** Service cleanup menelan exception dan UI tetap menampilkan pesan bahwa seluruh data sudah dihapus.
7. **Timezone hanya diatur saat startup.** Saat aplikasi kembali aktif setelah timezone perangkat berubah, reconciler berjalan tanpa memuat ulang timezone.
8. **Stream riwayat servis tidak mengamati tabel lampiran.** Perubahan attachment tidak selalu memicu pembaruan daftar riwayat.
9. **Beberapa layar menyamakan loading/error dengan data kosong.** Dashboard dan laporan dapat menunjukkan “Belum Ada Motor” atau “Tidak Ada Transaksi” ketika sumber data sebenarnya sedang loading/gagal.
10. **Kualitas visual belum sepenuhnya memenuhi spesifikasi visual-first.** Ilustrasi SVG onboarding yang disertakan tidak digunakan oleh screen onboarding; halaman onboarding memakai ikon Material. Motion design baru diterapkan pada sejumlah area, belum pada semua momen yang diminta FSD.

**Kesimpulan:** arsitektur dan sebagian besar fitur inti sudah ada, tetapi ServisKu belum memenuhi seluruh acceptance criteria P0 secara meyakinkan. Prioritas pertama adalah memperbaiki konsistensi odometer, notifikasi per dimensi, penghapusan foto, dan reaktivitas laporan, lalu mengunci keputusan privasi Android Auto Backup.

---

## 2. Ruang lingkup dan batas verifikasi

### Yang diperiksa

- Seluruh direktori `lib/` (63 file Dart termasuk generated Drift code).
- Seluruh direktori `test/` (20 file test).
- 8 tabel Drift dan strategi migrasi.
- Konfigurasi Android dari ZIP terpisah, termasuk manifest, Gradle, dan wrapper.
- `pubspec.yaml`, `pubspec.lock`, `.gitignore`, aset, dan README.
- Pemetaan kelompok requirement PRD/FSD ke implementasi aktual.

### Yang belum dapat diverifikasi secara independen

- Saya tidak menjalankan `flutter analyze`, `flutter test`, atau `flutter build apk` di lingkungan audit ini karena Flutter/Dart SDK tidak tersedia di sana. Hasil 0 issue, 70 test lulus, dan APK berhasil build adalah **hasil yang dilaporkan Antigravity**, bukan hasil eksekusi ulang independen.
- APK tidak disertakan dalam ZIP.
- Tidak ada screenshot seluruh layar atau rekaman penggunaan dari emulator/perangkat.
- Tidak ada pengujian fisik Android untuk notifikasi setelah reboot, permission, perubahan timezone, kamera, gallery picker, maupun perilaku OEM.
- Static review tidak membuktikan jaminan keamanan runtime atau kompatibilitas semua perangkat.

Karena itu, status pada laporan ini membedakan **temuan source code** dari **hal yang memerlukan runtime verification**.

---

## 3. Inventaris project

| Komponen | Hasil inventaris |
|---|---:|
| Dart files di `lib/` | 63 |
| Test files | 20 |
| Drift tables | 8 |
| SVG assets | 5 |
| Automated test declarations | 70 |
| Unit tests | 62 |
| Widget tests | 7 |
| Integration-style test | 1 |

Delapan tabel utama: `motorcycles`, `odometer_readings`, `maintenance_schedules`, `service_records`, `service_record_items`, `service_attachments`, `app_settings`, dan `notification_jobs`.

### Keputusan arsitektur yang sudah sesuai

- Flutter/Dart untuk Android.
- Riverpod sebagai state management.
- go_router untuk navigasi.
- Drift/SQLite sebagai database lokal.
- Layering feature-oriented: presentation, application, domain, data.
- Database transaction untuk operasi multi-tabel utama.
- Foto disimpan sebagai file lokal, bukan BLOB SQLite.
- Tidak ditemukan API client, Firebase, Supabase, atau request jaringan pada source aplikasi.
- `AndroidManifest.xml` tidak mencantumkan permission `INTERNET`.
- Gradle wrapper tersedia di ZIP Android.

---

## 4. Matriks kepatuhan requirement PRD/FSD

Status:
- **Sebagian**: fungsi utama ada, tetapi ada gap yang perlu ditutup.
- **Sesuai pada source**: implementasi yang diperiksa selaras secara statis, tetapi belum berarti lulus runtime.
- **Ditunda sesuai scope**: fitur memang bukan bagian P0.
- **Belum dapat diverifikasi**: membutuhkan emulator/perangkat/screenshot.

| Requirement / modul | Status | Bukti implementasi | Gap utama |
|---|---|---|---|
| FR-ONB-01 s.d. FR-ONB-05, SCR-01/02 | Sebagian | Splash memeriksa onboarding dan motor; onboarding 3 halaman dengan Mulai/Lewati | Onboarding menggunakan ikon Material, bukan ilustrasi onboarding lokal yang disediakan; animasi reduced-motion tidak diterapkan pada seluruh perpindahan onboarding; visual runtime belum diperiksa. |
| FR-VEH-01 s.d. FR-VEH-09, SCR-03/05/06 | Sebagian | CRUD motor, active motor, dan cascade database sudah ada | Hapus motor meninggalkan file fisik foto nota karena metadata cascade tidak diikuti file cleanup. |
| FR-ODO-01 s.d. FR-ODO-08, SCR-07 | Sebagian | Input manual, histori, koreksi eksplisit, derived latest odometer | Catatan servis dapat menurunkan odometer terkini tanpa koreksi; input manual tanggal lampau tidak dicek terhadap pembacaan yang lebih baru pada tanggal setelahnya. |
| FR-DASH-01 s.d. FR-DASH-07, SCR-04 | Sebagian | Dashboard menampilkan motor aktif, status, top 3, servis terakhir, dan biaya bulan ini | Loading/error bisa tampil sebagai data kosong; urgency cross-unit memakai asumsi 25 km/hari yang tidak ditentukan PRD/FSD. |
| FR-MNT-01 s.d. FR-MNT-13, SCR-08/09 | Sebagian | Template motor, jadwal kustom, kalkulator km/tanggal gabungan, baseline manual, status | Logika status gabungan benar untuk UI, tetapi dipakai secara keliru untuk menentukan trigger notifikasi kilometer. |
| FR-SRV-01 s.d. FR-SRV-10, SCR-10/11/12 | Sebagian | Kunjungan multi-item, biaya, transaksi, edit/delete, link ke jadwal, detail | Catatan servis yang tanggalnya sama/lebih baru dapat menimpa odometer dengan km lebih rendah; repository `updateRecord` menerima motor berbeda tetapi tidak mengubah `motorcycle_id` pada parent (UI saat ini menonaktifkan pilihan motor ketika edit). |
| FR-ATT-01 s.d. FR-ATT-07 | Sebagian | Picker kamera/galeri, validasi JPEG/PNG, direktori privat, thumbnail, hapus satu lampiran | Hapus motor tidak menghapus file; cleanup orphan tidak pernah dipanggil dalam alur produksi; cleanup file menelan kegagalan; belum ada batas byte storage yang tegas. |
| FR-NOT-01 s.d. FR-NOT-10 | Sebagian | `zonedSchedule`, permission, receiver Android, boot receiver, reaktivasi OFF/ON | Kilometer false-positive karena memakai status gabungan; timezone tidak diperbarui saat resume; error cancel ditelan; izin yang diberikan lewat tombol “Minta Izin” tidak secara eksplisit memicu reconcile ulang. |
| FR-REP-01 s.d. FR-REP-07, SCR-13 | Sebagian | Periode bulan ini/3 bulan/tahun/kustom, filter motor, chart dan kategori | Halaman laporan tidak mengamati stream perubahan servis; query periode yang sudah dibentuk tidak dieksekusi dan data diambil seluruhnya lalu difilter di memori; banyak query per record. |
| FR-SET-01 s.d. FR-SET-04, SCR-14 | Sebagian | Preferensi notifikasi, info privasi, hapus semua data | Sukses hapus tetap dilaporkan walau cleanup foto gagal; auto backup Android tidak dikonfigurasi; exception database di UI tidak ditampilkan dengan feedback yang tepat. |
| FR-SRC-01 s.d. FR-SRC-03 (P1) | Ditunda sesuai scope | Tidak disajikan sebagai fitur P0 | Pencarian/filter lanjutan memang P1. |
| FR-BKP-01 s.d. FR-BKP-06 (P1) | Ditunda sesuai scope | Tidak disajikan sebagai fitur P0 | Backup/restore manual memang P1. Namun, Auto Backup OS adalah perilaku berbeda yang tetap perlu keputusan privasi. |
| FR-SET-02 dark mode (P1) | Ditunda sesuai scope | Light mode dipakai sebagai default | Dark mode memang P1. |
| P2: PIN/biometrik, cloud sync, PDF | Ditunda sesuai scope | Tidak dipalsukan sebagai fitur siap pakai | Sesuai scope MVP. |

Dokumen acuan: PRD bagian 4-6, 7, 11-14; FSD bagian 5-16, 17, 20.

---

## 5. Temuan teknis terperinci

### S1 - Prioritas tertinggi: notifikasi kilometer memakai status gabungan

**Lokasi:** `lib/features/maintenance/application/notification_reconciler.dart:210-267`; `lib/features/maintenance/domain/maintenance_calculator.dart:38-161`.

Kalkulator menghitung `kmStatus` dan `dateStatus` secara terpisah, lalu menggabungkannya menjadi `result.status`. `NotificationReconciler` menggunakan `result.status` untuk memicu `km_soon` dan `km_overdue`.

Contoh:
- Batas waktu berstatus Segera, tetapi kilometer masih Aman.
- Status gabungan menjadi Segera.
- Reconciler dapat mengirim notifikasi kilometer `km_soon` meskipun batas kilometer belum memasuki rentang pengingat.

Hal serupa bisa terjadi ketika tanggal sudah Terlambat tetapi kilometer belum jatuh tempo.

**Dampak:** notifikasi bisa salah menyebut motor mendekati/jatuh tempo berdasarkan kilometer. Ini mengurangi kepercayaan pengguna terhadap reminder.

**Perbaikan:** kembalikan `kmStatus` dan `dateStatus` (serta alasan masing-masing) dari kalkulator. Reconciler harus memakai `dateStatus` hanya untuk trigger tanggal dan `kmStatus` hanya untuk trigger kilometer. Tambahkan test kombinasi: tanggal segera + km aman, tanggal terlambat + km aman, km segera + tanggal aman, dan km terlambat + tanggal aman.

### S1 - Prioritas tertinggi: service record dapat menurunkan odometer aktif

**Lokasi:** `lib/features/service_records/data/service_record_repository.dart:209-255` dan `314-405`; `lib/features/odometer/data/odometer_repository.dart:67-105`.

Create service record selalu memasukkan `odometer_readings` dengan tanggal servis. Update service record selalu memperbarui pembacaan tertaut dengan kilometer/tanggal baru. Kedua jalur tidak memeriksa apakah pembacaan itu lebih rendah daripada pembacaan terkini yang lebih baru atau sama tanggalnya.

Test `service_odometer_consistency_test.dart` hanya menguji servis historis dengan tanggal lebih lama daripada pembacaan manual. Test itu tidak menguji servis pada tanggal yang sama/lebih baru tetapi dengan angka km lebih rendah.

**Dampak:** pembacaan terbaru dipilih berdasarkan `reading_date` lalu `created_at`. Catatan servis baru dengan kilometer lebih kecil dapat menjadi sumber odometer terkini dan membuat angka motor turun tanpa alur koreksi.

**Perbaikan:** terapkan validasi konsistensi odometer pada create dan update servis. Untuk tanggal yang lebih baru/sama, jangan menerima nilai lebih rendah tanpa alur koreksi eksplisit. Untuk catatan historis, validasi terhadap pembacaan kronologis sebelum dan sesudah tanggal servis, bukan hanya membandingkan terhadap satu nilai global. Definisikan aturan edit servis yang mengubah baseline agar jadwal dan odometer tetap sinkron. Tambahkan test untuk tanggal sama, tanggal lebih baru, dan tanggal historis.

### S1 - Privasi: Android Auto Backup tidak diatur

**Lokasi:** `android/app/src/main/AndroidManifest.xml:7-10`; `lib/database/app_database.dart:15-20`; `lib/core/services/attachment_storage_service.dart:126-139`.

Manifest tidak mendefinisikan `android:allowBackup`, `android:dataExtractionRules`, atau `android:fullBackupContent`. Android Auto Backup default aktif (`allowBackup` default `true`) untuk aplikasi yang memenuhi target API, dan dokumentasi Android menjelaskan data internal aplikasi/database dapat termasuk dalam backup. Database dan foto ServisKu berada di direktori aplikasi.

Dokumentasi resmi: [Android Auto Backup](https://developer.android.com/identity/data/autobackup).

**Dampak:** walaupun aplikasi tidak mengirim request ke server/backend, Android OS dapat melakukan backup sistem yang mencakup data aplikasi ke akun Google/perangkat baru. Ini membuat kalimat UI “tidak mengirim data kendaraan Anda ke pihak mana pun” terlalu absolut.

**Keputusan yang dibutuhkan:**
- Jika MVP benar-benar harus local-only tanpa backup sistem, nonaktifkan backup dan tambahkan aturan pengecualian yang sesuai untuk versi Android target.
- Jika Auto Backup dibiarkan aktif, jelaskan secara transparan dalam informasi privasi bahwa backup Android dapat dikelola oleh OS/akun perangkat.
- Uji aturan cloud backup dan device-to-device transfer pada target Android. Dokumentasi Android mencatat bahwa perilaku `allowBackup=false` untuk transfer perangkat-ke-perangkat dapat bervariasi pada sebagian OEM.

### S1 - Penghapusan motor meninggalkan foto nota secara fisik

**Lokasi:** `lib/features/motorcycles/data/motorcycle_repository.dart:192-227`; `lib/database/tables/service_attachments_table.dart`; `lib/core/services/attachment_storage_service.dart:266-278`.

`deleteMotorcycle()` membatalkan notifikasi dan menghapus row motor dalam transaksi. Foreign key cascade menghapus service records dan metadata attachment. Namun, repository tidak mengambil `local_path`/service record IDs sebelum cascade dan tidak memanggil penghapusan file fisik setelah commit.

**Dampak:** foto nota bisa tertinggal pada direktori privat setelah pengguna menghapus motor dan UI menyatakan seluruh data motor dihapus. File yatim berpotensi ikut masuk ke backup sistem Android jika Auto Backup tetap aktif.

**Perbaikan:** kumpulkan service record IDs dan local paths sebelum transaksi; commit penghapusan relasional; kemudian hapus direktori attachment terkait. Pastikan cleanup failure dilaporkan dan dapat dicoba ulang.

### S1 - Penghapusan semua data bisa menampilkan sukses palsu

**Lokasi:** `lib/features/settings/data/settings_repository.dart:78-100`; `lib/core/services/attachment_storage_service.dart:337-345`; `lib/features/settings/presentation/settings_screen.dart:73-106`.

`cleanupAllAttachments()` menangkap dan menelan seluruh error. `clearAllData()` juga tidak memperoleh hasil apakah file fisik benar-benar terhapus. Screen selalu menampilkan “Seluruh data aplikasi telah dihapus.” setelah method kembali.

Jika cleanup file gagal, UI tetap menyatakan semua file dihapus. Jika transaksi database gagal, UI tidak memiliki try/catch feedback yang spesifik.

**Perbaikan:** jadikan cleanup mengembalikan hasil terstruktur atau melempar error yang dapat ditangani; tampilkan status terpisah antara database terhapus dan file cleanup tertunda/gagal. Simpan mekanisme retry cleanup tanpa mempertahankan data pribadi lebih lama dari yang diperlukan.

### S1 - Halaman laporan tidak otomatis memperbarui data

**Lokasi:** `lib/features/reports/presentation/expense_report_screen.dart:56-64`; `lib/features/reports/presentation/expense_report_screen.dart:152-180`.

Screen membuat `reportFuture` langsung dari `getReportSummary()`, tetapi tidak mengamati `motorcycleServiceRecordsProvider` atau stream transaksi lain. Jika halaman laporan masih terpasang dan catatan servis diedit/dihapus di route detail, tidak ada dependency yang menjamin Future dibuat ulang.

Selain itu, `FutureBuilder` tidak memeriksa `snapshot.hasError`; error query berpotensi ditampilkan sebagai empty state “Tidak Ada Transaksi”.

**Dampak:** angka total/grafik bisa stale sampai screen rebuild; kegagalan query terlihat seperti tidak ada transaksi.

**Perbaikan:** gunakan provider reaktif untuk filter/period/report state atau amati stream service records sebagai dependency. Tambahkan explicit error state. Uji create/edit/delete dari alur navigasi ketika report screen masih mounted.

### S2 - Riwayat servis tidak mendengarkan perubahan attachment

**Lokasi:** `lib/features/service_records/data/service_record_repository.dart:105-128`.

`watchRecords()` hanya menjalankan `query.watch()` pada tabel `service_records`, lalu melakukan query terpisah ke `service_record_items` dan `service_attachments`. `readsFrom` tidak mencakup dua tabel turunan.

**Dampak:** lampiran yang baru ditambahkan atau dihapus pada record yang sudah ada tidak wajib memicu stream history. Thumbnail pada riwayat dapat tidak muncul/berubah sampai ada perubahan pada row parent atau screen dibangun ulang.

**Perbaikan:** buat query reaktif yang mengamati ketiga tabel melalui Drift join/customSelect `readsFrom`, atau trigger parent update yang disengaja saat attachment berubah.

### S2 - Orphan cleanup sudah dibuat tetapi belum digunakan di production

**Lokasi:** `lib/core/services/attachment_storage_service.dart:280-334`.

Pencarian pemanggilan menunjukkan `cleanupOrphanAttachments()` hanya didefinisikan dan dipakai oleh test; tidak dipanggil dari startup, resume, atau alur hapus motor/servis. `deleteAttachmentFile()` dan `deleteRecordAttachmentsDirectory()` juga menelan kesalahan fisik.

**Perbaikan:** panggil cleanup dengan daftar path aktif yang dibangun dari database pada momen aman (misalnya startup setelah DB siap), dan pastikan cleanup tidak menghapus file yang masih direferensikan. Tambahkan test pada file fisik, bukan hanya metadata.

### S2 - Timezone belum diperbarui saat aplikasi resume

**Lokasi:** `lib/core/services/notification_service.dart:41-74`; `lib/app/widgets/main_scaffold.dart:31-39`.

`configureLocalTimezone()` menggunakan plugin `flutter_timezone`, tetapi dipanggil dari `initialize()` saja. Saat app resumed, `MainScaffold` hanya memanggil `reconcileAll()`.

**Dampak:** jika timezone sistem berubah saat app berada di background, `tz.local` dapat tetap menunjuk timezone lama; pengingat tanggal yang disusun ulang berpotensi bergeser jam lokal.

**Perbaikan:** pada resume, refresh timezone terlebih dahulu, deteksi apakah zona berubah, lalu reschedule pending date reminders menggunakan timezone baru. Uji perubahan WIB/WITA/WIT atau timezone emulator secara eksplisit.

### S2 - Kegagalan pembatalan notifikasi tidak dapat diketahui caller

**Lokasi:** `lib/core/services/notification_service.dart:216-232`; `lib/features/maintenance/application/notification_reconciler.dart:330-375`.

`cancelNotification()` dan `cancelAllNotifications()` menelan exception. Reconciler kemudian dapat menghapus job atau menandainya cancelled tanpa mengetahui apakah Android benar-benar membatalkan notifikasi.

**Dampak:** pada kegagalan platform, notifikasi lama dapat tetap muncul meskipun database menganggap job sudah dibatalkan.

**Perbaikan:** kembalikan hasil cancel (`success/failure`) atau lempar error terkontrol; jangan buang job metadata jika pembatalan platform belum terkonfirmasi. Catat kegagalan tanpa memasukkan data pribadi ke log.

### S2 - Grant permission lewat Settings tidak selalu memicu rekonsiliasi

**Lokasi:** `lib/features/settings/presentation/settings_screen.dart:58-71`; `lib/features/settings/presentation/settings_screen.dart` bagian `_toggleNotifications`; `lib/features/settings/data/settings_repository.dart:62-76`.

`_requestNotificationPermission()` hanya meminta izin dan memperbarui status UI. Setelah izin berhasil diberikan melalui tombol “Minta Izin”, fungsi tidak memanggil `notificationReconciler.reconcileAll()`. Jalur toggle ON juga meminta permission di repository (`onNotificationsEnabled`) lalu meminta lagi dari screen ketika `_hasDevicePermission` masih false.

**Dampak:** jika pengguna sebelumnya menolak izin lalu mengaktifkannya dari tombol “Minta Izin”, job yang masih cancelled dapat tidak dipulihkan sampai startup/resume atau perubahan data berikutnya. Toggle ON juga dapat menghasilkan permintaan izin ganda.

**Perbaikan:** pusatkan satu permintaan izin pada satu layer; setelah permission granted, panggil reconcile sekali dan perbarui state dari hasil izin aktual. Tambahkan test deny -> grant dari tombol Settings -> pending reminders recreated.

### S2 - Pengurutan urgency mencampur km dan hari dengan angka 25 km/hari

**Lokasi:** `lib/app/providers/app_providers.dart:196-208`.

Fungsi `_calculateUrgencyScore()` menganggap 1 hari setara 25 km untuk membandingkan schedule km-only dan date-only. PRD/FSD tidak menetapkan faktor tersebut.

**Dampak:** prioritas jadwal lintas unit dapat berubah berdasarkan asumsi penggunaan motor yang belum divalidasi.

**Perbaikan:** gunakan aturan prioritas eksplisit yang dapat dijelaskan (misalnya sort status dahulu, lalu sisa hari untuk date-only dan sisa km untuk km-only dalam kelompok yang terpisah), atau tetapkan rumus produk dan dokumentasikan setelah tervalidasi. Jangan menyajikan 25 km/hari sebagai ketentuan FSD.

### S2 - Loading/error dashboard berpotensi tampak seperti tidak ada data

**Lokasi:** `lib/app/providers/app_providers.dart:105-139` dan `211-285`; `lib/features/dashboard/presentation/dashboard_screen.dart:18-50`.

`activeMotorcycleProvider` mengembalikan `null` saat stream loading maupun error. `dashboardSummaryProvider` memakai `value ?? []` dan `value ?? 0` untuk schedules, records, dan expense. Dashboard kemudian menampilkan empty state “Belum Ada Motor”.

**Dampak:** loading awal atau error database stream bisa disalahartikan sebagai pengguna belum memiliki kendaraan/riwayat.

**Perbaikan:** modelkan dashboard sebagai `AsyncValue` atau expose status loading/error secara eksplisit. Jangan memakai empty state ketika data belum selesai dimuat atau gagal diambil.

### S2 - Service record update memiliki celah invariant motor

**Lokasi:** `lib/features/service_records/data/service_record_repository.dart:314-405`; `lib/features/service_records/presentation/service_record_form_screen.dart` bagian dropdown kendaraan saat edit.

Repository menerima `motorcycleId` baru untuk update dan memvalidasi schedule item terhadap motor itu, tetapi update SQL pada `service_records` tidak menulis `motorcycle_id`. UI saat ini menonaktifkan pergantian kendaraan pada mode edit sehingga bug tidak terlihat di jalur normal, tetapi repository belum melindungi invariant jika dipanggil oleh caller lain.

**Perbaikan:** jika pindah kendaraan memang dilarang, load parent record dan reject `motorcycleId != existing.motorcycleId`. Jika pindah kendaraan didukung, update parent, relink service-derived odometer, validate all schedule links, recalculate both motorcycles/schedules in one transaction.

### S2 - Query laporan memuat semua histori dan melakukan N+1 query

**Lokasi:** `lib/features/reports/data/report_repository.dart:46-105`; `lib/features/service_records/data/service_record_repository.dart:131-153`.

`getReportSummary()` membentuk query date range dan motorcycle filter tetapi tidak pernah menjalankan query itu. Sebagai gantinya, fungsi mengambil seluruh record via `getRecords()` lalu menyaring tanggal di Dart. `getRecords()` mengambil items dan attachments melalui query tambahan untuk tiap record.

**Dampak:** semakin panjang riwayat, semakin banyak query dan objek yang dimuat, termasuk metadata attachment yang tidak dibutuhkan untuk agregasi laporan.

**Perbaikan:** filter transaksi di SQL berdasarkan rentang tanggal dan motor, query agregat biaya/items per kategori/bulan secara lebih efisien, dan jangan load attachment untuk laporan.

### S2 - Batas ukuran lampiran belum ditegakkan di storage layer

**Lokasi:** `lib/features/service_records/presentation/service_record_form_screen.dart:130-138`; `lib/core/services/attachment_storage_service.dart:142-240`.

Picker meminta maxWidth/maxHeight 1600 dan imageQuality 85, tetapi storage service menyalin file source tanpa validasi batas ukuran byte atau kebijakan kompresi final yang konsisten. FSD meminta batas ukuran konfigurabel dan kompresi sebelum rilis; nilai final memang belum dipatok oleh PRD.

**Perbaikan:** tentukan batas byte berdasarkan uji keterbacaan nota, cek ukuran sebelum `readAsBytes`, kompres/resize bila melebihi batas, lalu simpan ukuran file final. Test file besar dan memory pressure.

### S2 - Validasi odometer manual belum mempertimbangkan kronologi tanggal

**Lokasi:** `lib/core/validators/app_validators.dart:31-65`; `lib/features/odometer/data/odometer_repository.dart:67-101`.

Validator membandingkan angka km baru dengan pembacaan global terbaru, tetapi tidak membandingkan tanggal input terhadap reading yang lebih baru. Pengguna dapat membuat reading bertanggal lampau dengan angka km yang lebih tinggi daripada reading yang terjadi setelahnya.

**Dampak:** histori dapat memiliki urutan tanggal yang tidak konsisten dengan angka odometer. Reading bertanggal lampau itu tidak akan menjadi current odometer karena query latest memakai `reading_date`.

**Perbaikan:** validasi terhadap pembacaan tepat sebelum dan sesudah tanggal input (atau batasi input manual normal ke tanggal yang tidak mendahului pembacaan terkini; gunakan workflow koreksi/historical-entry terpisah).

### S3 - Manifest belum mengatur Auto Backup dan release signing masih debug

**Lokasi:** `android/app/src/main/AndroidManifest.xml`; `android/app/build.gradle.kts` bagian `buildTypes.release`.

Release signing masih memakai debug signing config. Ini cukup untuk pengembangan lokal, bukan distribusi produksi.

**Perbaikan:** siapkan release signing melalui secret/keystore di luar repository sebelum rilis. Jangan commit keystore/password. Pastikan backup policy diputuskan.

### S3 - Minimum SDK constraint di `pubspec.yaml` tidak sesuai dengan lockfile

**Lokasi:** `pubspec.yaml:6-7`; `pubspec.lock:1037-1039`.

`pubspec.yaml` menyatakan Dart `>=3.2.0`, sedangkan `pubspec.lock` menyatakan resolver membutuhkan Dart `>=3.13.0` dan Flutter `>=3.47.0`. `flutter_timezone 5.1.1` sendiri mensyaratkan Dart `>=3.4.0` menurut metadata package.

Sumber package: [flutter_timezone 5.1.1](https://pub.dev/packages/flutter_timezone/versions/5.1.1).

**Perbaikan:** samakan environment constraint dengan toolchain yang benar-benar didukung atau turunkan dependency ke versi yang kompatibel, kemudian resolve ulang lockfile pada SDK target.

### S3 - Onboarding belum memakai ilustrasi lokal yang disertakan

**Lokasi:** `lib/features/onboarding/presentation/onboarding_screen.dart`; `assets/illustrations/onboarding_1.svg`, `onboarding_2.svg`, `onboarding_3.svg`.

Ketiga SVG onboarding ada di assets dan terdaftar pada pubspec, tetapi tidak direferensikan oleh source. Onboarding menggunakan ikon Material dalam lingkaran. Aplikasi memang mempunyai ilustrasi `CustomPainter` di beberapa area, jadi ini bukan berarti seluruh UI tanpa ilustrasi, tetapi onboarding belum memenuhi arahan visual per halaman sebagaimana tertulis di FSD.

**Perbaikan:** gunakan ilustrasi lokal onboarding atau hapus aset yang tidak dipakai setelah desain diputuskan. Hormati `MediaQuery.disableAnimations` juga pada page transition/indicator onboarding.

---

## 6. Audit keamanan dan privasi

| Area | Kondisi | Catatan |
|---|---|---|
| Network/backend | Tidak ditemukan API client atau permission INTERNET | Selaras dengan offline-first pada source aplikasi. |
| DB path | SQLite di application documents directory | Tetap perlu evaluasi backup OS; private directory tidak otomatis berarti data tidak masuk backup. |
| Attachment path | Direktori privat aplikasi | Selaras dengan FSD, tetapi file yatim perlu cleanup. |
| DB encryption | Tidak ditemukan SQLCipher/enkripsi database | FSD tidak mewajibkan enkripsi DB, jadi ini dicatat sebagai batas keamanan, bukan otomatis noncompliance. Data tetap bergantung pada proteksi sandbox perangkat. |
| Logging | Tidak ditemukan logging framework/telemetry eksternal | Periksa error log tambahan bila nanti dibuat; jangan log nomor polisi, isi nota, atau path sensitif. |
| Permission | POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED, VIBRATE, CAMERA | Periksa apakah CAMERA diperlukan untuk jalur image picker yang dipakai; prinsip minimisasi permission tetap berlaku. |
| Android backup | Tidak dikonfigurasi | Risiko privasi tinggi sampai pilihan backup dijelaskan/ditetapkan. |
| Release signing | Release menggunakan debug signing | Jangan publikasikan build release dengan konfigurasi ini. |
| App lock | Tidak ada PIN/biometric lock | Sesuai P2, bukan kewajiban MVP. |

---

## 7. Audit UI/UX dan animasi

### Yang terlihat di source

- Tema light dengan palet Deep Charcoal/Warm Amber.
- Logo/hero/empty state `CustomPainter`.
- Hero kendaraan dengan `AnimatedSwitcher`.
- Transisi odometer dan status pada dashboard.
- Progress bar perawatan dengan `TweenAnimationBuilder`.
- Status badge `AnimatedContainer`.
- `MediaQuery.disableAnimations` sudah dipakai pada sebagian komponen dashboard dan status badge.
- Halaman laporan menggunakan `fl_chart`.
- Form servis menyediakan tombol kamera/galeri dan preview foto.

### Gap yang teridentifikasi

1. SVG onboarding belum digunakan; screen onboarding saat ini menampilkan Material icons.
2. Motion onboarding terbatas pada indikator halaman; reduced-motion belum diterapkan secara menyeluruh di onboarding.
3. Feedback penyimpanan servis berupa SnackBar, bukan check/success animation seperti yang diarahkan FSD.
4. Dashboard tidak membedakan loading/error dari empty state.
5. Halaman laporan tidak membedakan error query dari empty transaction state.
6. Belum ada screenshot/golden test lintas ukuran ponsel untuk menilai overflow, spacing, hierarchy, dan kontras aktual.

**Status visual:** sebagian persyaratan visual sudah diterjemahkan ke komponen nyata, tetapi kualitas akhir, responsivitas, dan konsistensi seluruh screen belum bisa dipastikan tanpa screenshot/perangkat.

---

## 8. Audit pengujian

### Jumlah deklarasi test dalam source

| Kategori | Jumlah deklarasi |
|---|---:|
| Unit | 62 |
| Widget | 7 |
| Integration-style | 1 |
| **Total** | **70** |

Rincian test unit mencakup attachment (10), dashboard reactivity/sorting (3), migration v1-v2 (1), date clamping (5), maintenance calculator (5), notification reconciliation (11), report calculations (1), safe deletion (1), schedule recalculation (1), service calculations (3), service odometer consistency (4), dan validators (17).

### Penilaian cakupan

Jumlah 70 deklarasi test cocok dengan klaim laporan Antigravity. Namun, jumlah test bukan bukti semua P0 sudah diuji.

- Satu file di `test/integration/` menggunakan `NativeDatabase.memory()` dan menguji repository/business workflow. Itu bukan UI end-to-end pada emulator/perangkat Android.
- Test notifikasi menggunakan mock `NotificationService`, bukan membuktikan Android Alarm/receiver benar-benar menampilkan notifikasi setelah app ditutup atau perangkat reboot.
- Migration test menguji fixture v1, backfill unambiguous, ambiguous, dan manual; tetapi belum menguji seluruh relasi attachment/notification dan operasi CRUD setelah migrasi pada seluruh jenis data.
- Test penghapusan seluruh data menguji jalur sukses; tidak menguji kegagalan fisik file cleanup atau memastikan UI tidak menampilkan sukses palsu.
- Report calculation test hanya satu test utama; belum cukup untuk seluruh preset, date boundary, filter semua motor, update/delete, dan reaktivitas UI.
- Belum ada test untuk false-positive km notification ketika date status saja yang segera/terlambat.
- Belum ada test untuk service record dengan tanggal sama/lebih baru tetapi km lebih rendah dari odometer terkini.
- Belum ada test untuk penghapusan motor yang memverifikasi foto fisik benar-benar dihapus.
- Belum ada test lifecycle timezone berubah saat app resume.

### Klaim build dari Antigravity

Laporan terbaru menyebut:
- `flutter analyze`: 0 issue.
- `dart format`: 83 file, 0 changed.
- `flutter test`: 70 passed.
- `flutter build apk --debug`: berhasil, APK 194.8 MB.

Klaim ini konsisten dengan laporan kerja yang diberikan, tetapi tidak dijalankan ulang secara independen dalam audit ini. Ukuran APK debug multi-ABI tidak bisa dianggap ukuran rilis final.

---

## 9. Packaging dan maintainability

| Temuan | Dampak | Rekomendasi |
|---|---|---|
| `README.md` masih template “A new Flutter project” | Pengembang lain tidak tahu cara setup, build, dan menguji | Tulis README ServisKu: tujuan, fitur, stack, setup SDK, generate Drift, test, build. |
| ZIP Android memuat `local.properties` | Berisi path SDK mesin pengembang | Jangan sertakan dalam ZIP/commit; `.gitignore` sudah mengabaikan. |
| ZIP Android memuat `.kotlin` cache | Artefak lokal, tidak dibutuhkan source distribution | Hapus dari paket source. |
| ZIP project memuat `.idea`/`.flutter-plugins-dependencies` | Artefak IDE/generator yang tidak diperlukan untuk source bersih | Hapus dari distribusi source; `.gitignore` sudah mencakup sebagian. |
| Asset SVG tidak direferensikan | Dead assets/ukuran tidak perlu | Integrasikan sesuai desain atau hapus. |
| `pubspec.yaml` SDK constraint `>=3.2` tidak sesuai lockfile | Setup pada SDK lebih lama gagal | Samakan constraint dan lockfile. |

---

## 10. Urutan perbaikan yang direkomendasikan

### Gelombang 1 - P0 data correctness dan privacy

1. Perbaiki validasi odometer dari catatan servis agar current odometer tidak turun tanpa koreksi eksplisit.
2. Pisahkan `kmStatus` dan `dateStatus` untuk pemicu notifikasi.
3. Hapus file lampiran secara fisik ketika motor dihapus.
4. Perbaiki `clearAllData()` agar kegagalan file cleanup tidak dilaporkan sebagai seluruh data terhapus.
5. Putuskan kebijakan Auto Backup Android dan sesuaikan manifest/rules serta teks privasi.

### Gelombang 2 - P0 responsiveness dan notification lifecycle

6. Jadikan laporan reaktif terhadap perubahan service records, items, dan filter.
7. Perluas watchRecords agar mengamati `service_attachments` dan `service_record_items`.
8. Refresh timezone sebelum reconcile pada app resume.
9. Jangan hapus notification job jika cancel platform gagal; tambahkan status/observability.
10. Reconcile ulang setelah izin notifikasi diberikan melalui tombol Settings.

### Gelombang 3 - P1 reliability, performance, UX

11. Perbaiki dashboard loading/error state dan false empty state.
12. Ganti heuristic 25 km/hari dengan aturan prioritas terdokumentasi.
13. Optimalkan query report agar filter dilakukan di SQLite dan tidak load attachments.
14. Terapkan byte-size cap/kompresi attachment pada storage layer.
15. Cegah service record update berpindah motor tanpa update/validasi relasi parent.
16. Perbaiki konsistensi timeline odometer untuk input tanggal lampau.
17. Integrasikan ilustrasi onboarding dan reduced-motion secara menyeluruh.
18. Perbarui README dan packaging project.

### Gelombang 4 - runtime verification

19. Jalankan ulang `flutter pub get`, code generation, `dart format`, `flutter analyze`, `flutter test`, dan `flutter build apk --debug` pada workspace pengembang.
20. Uji Android emulator/perangkat: notifikasi tanggal, km soon/overdue, permission deny/grant, OFF/ON, reboot, timezone change, image picker camera/gallery, attachment delete, hapus motor, hapus semua data, airplane mode/offline, dan restart app.
21. Ambil screenshot semua screen utama pada setidaknya 2 ukuran smartphone; periksa overflow, readability, tap targets, dan motion reduced.
22. Sebelum rilis, siapkan release signing terpisah dari debug key.

---

## 11. Keputusan audit akhir

**Status akhir: PARTIAL COMPLIANCE - BELUM FINAL.**

Fondasi kode dan mayoritas struktur P0 sudah ada. Namun, jangan menyatakan seluruh acceptance criteria P0 sudah terpenuhi sampai sekurang-kurangnya temuan S1 diperbaiki dan diuji.

Tidak direkomendasikan membangun ulang aplikasi. Lakukan targeted repair pada modul yang disebutkan di laporan ini, lalu jalankan ulang seluruh suite dan verifikasi pada perangkat Android.
