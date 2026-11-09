# ServisKu - Aplikasi Manajemen Perawatan Sepeda Motor

ServisKu adalah aplikasi seluler Android offline-first yang dirancang untuk membantu pemilik sepeda motor di Indonesia mencatat, memantau, dan mengelola jadwal perawatan berkala, riwayat servis, pembacaan odometer, foto nota pembayaran, serta pengeluaran kendaraan secara teratur tanpa ketergantungan pada server eksternal atau koneksi internet.

---

## 1. Fitur Utama

- **Pengelolaan Multi-Motor**: Mendukung pengelolaan satu atau lebih sepeda motor dengan data pabrikan, model, tipe motor, tahun pembuatan, nomor polisi, dan catatan khusus.
- **Pencatatan Odometer Fleksibel**: Pembaruan odometer manual dengan validasi urutan kronologis yang ketat, pencegahan regresi angka tanpa alasan koreksi, dan riwayat pembacaan historis.
- **Jadwal Perawatan Mandiri & Presets**: Pembuatan jadwal servis berdasarkan interval jarak tempuh (km), interval waktu (bulan), atau kombinasi keduanya dengan evaluasi status independen (Aman, Segera, Terlambat).
- **Riwayat Kunjungan Servis & Multi-Pekerjaan**: Pencatatan riwayat servis komprehensif yang memuat tanggal, odometer saat pengerjaan, nama bengkel, rincian pekerjaan multi-item, biaya per item, biaya tambahan pengerjaan, dan tautan otomatis ke jadwal perawatan.
- **Lampiran Foto Nota & Kompresi Privat**: Penyimpanan foto nota fisik ke direktori privat aplikasi dengan validasi format (JPG/PNG), proteksi path traversal, pembuatan thumbnail di latar belakang, batas input 15MB, dan target kompresi 2MB.
- **Pengingat & Notifikasi Lokal Offline**: Penjadwalan notifikasi alarm Android lokal yang akurat berbasis zona waktu perangkat (WIB, WITA, WIT), tanpa memicu false-positive kilometer karena dimensi tanggal.
- **Laporan Biaya & Analisis Pengeluaran**: Evaluasi pengeluaran berkala secara reaktif melalui agregasi SQL optimal, rincian biaya per kategori pekerjaan, dan grafik tren pengeluaran bulanan.
- **Privasi Total & Penghapusan Bersih**: Seluruh data tersimpan 100% di perangkat pengguna, Android Auto Backup dinonaktifkan untuk mencegah kebocoran data ke cloud pihak ketiga, serta penyediaan fitur pembersihan tuntas multi-tahap.

---

## 2. Arsitektur & Pola Desain

Aplikasi dibangun menggunakan pendekatan **Clean Architecture** yang terstruktur, dipadukan dengan **Feature-First Pattern** dan prinsip reaktivitas berbasis **Riverpod**:

```
lib/
|-- app/                  # Inisialisasi aplikasi, konfigurasi tema, router, dan scaffold
|-- core/                 # Konstanta, ekstensi, pemformat, validator, dan layanan utilitas
|-- database/             # Definisi skema SQLite Drift, tabel, dan migrasi versi database
`-- features/             # Modul fungsional per fitur:
    |-- dashboard/        # Ringkasan status kendaraan aktif, odometer, dan top 3 urgensi
    |-- maintenance/      # Logika kalkulasi jatuh tempo dan rekonsiliasi notifikasi lokal
    |-- motorcycles/      # Pengelolaan data kendaraan motor dan pemilihan motor aktif
    |-- odometer/         # Riwayat kilometer dan form input odometer
    |-- onboarding/       # Alur penyambutan awal pengguna dengan aset ilustrasi vektor
    |-- reports/          # Agregasi pengeluaran, visualisasi diagram batang, dan filter periode
    |-- service_records/  # Pencatatan servis, multi-item pekerjaan, dan lampiran nota
    `-- settings/         # Preferensi notifikasi, informasi privasi, dan hapus data
```

Setiap modul fitur dibagi ke dalam 4 lapisan standar:
1. **Domain**: Model bisnis murni, entitas, dan kalkulator tanpa ketergantungan framework.
2. **Data**: SQLite Drift tables, repositories, dan query builder.
3. **Application**: Pengatur alur logika lintas repositori (seperti `NotificationReconciler`).
4. **Presentation**: Halaman UI, widget atomik, dan konsumsi provider Riverpod.

---

## 3. Persyaratan Sistem & SDK

- **Flutter SDK**: 3.22.0 atau lebih baru (Channel stable)
- **Dart SDK**: 3.4.0 atau lebih baru
- **Target Platform**: Android (minSdkVersion 21, compileSdkVersion 34, targetSdkVersion 34)
- **Java Development Kit**: JDK 17
- **Database Engine**: SQLite 3 (via Drift & sqlite3_flutter_libs)

---

## 4. Panduan Menjalankan Aplikasi

### 4.1 Persiapan Proyek

1. Unduh atau clone repositori ini ke penyimpanan lokal Anda.
2. Buka terminal di direktori proyek:
   ```bash
   cd servis
   ```
3. Unduh seluruh pustaka dependensi Flutter:
   ```bash
   flutter pub get
   ```
4. Jalankan pengujian otomatis untuk memverifikasi integritas kode:
   ```bash
   flutter test
   ```

### 4.2 Menjalankan di Emulator atau Perangkat Android

Pastikan emulator Android telah berjalan atau perangkat fisik telah terhubung dalam mode pengembang (USB Debugging aktif):
```bash
flutter run
```

---

## 5. Skema Database & Relasi Tabel

Aplikasi menggunakan engine SQLite yang dikelola melalui library Drift (schema version 2). Terdapat 8 tabel relasional yang saling terhubung dengan aturan `ON DELETE CASCADE`:

1. `motorcycles`: Menyimpan identitas motor (id, nickname, brand, model, motorcycle_type, manufacture_year, license_plate, propulsion_type, notes).
2. `odometer_readings`: Pencatatan kilometer (id, motorcycle_id, odometer_km, reading_date, source, is_correction, notes).
3. `maintenance_schedules`: Definisi jadwal perawatan (id, motorcycle_id, task_name, category, interval_km, interval_months, last_done_km, last_done_date, is_active).
4. `service_records`: Kunjungan servis (id, motorcycle_id, service_date, odometer_km, workshop_name, additional_cost, notes).
5. `service_record_items`: Rincian pekerjaan per kunjungan (id, service_record_id, maintenance_schedule_id, task_name, category, item_cost).
6. `service_attachments`: Metadata foto nota fisik (id, service_record_id, file_path, file_name, mime_type, file_size).
7. `notification_jobs`: Pelacak alarm notifikasi lokal (id, motorcycle_id, maintenance_schedule_id, notification_type, planned_at, cycle_key, state).
8. `app_settings`: Pengaturan konfigurasi kunci dan nilai (key, value).

---

## 6. Logika Perhitungan Status & Urgensi

### 6.1 Evaluasi Status Independen

Perhitungan status perawatan (`MaintenanceCalculator`) memisahkan evaluasi dimensi jarak tempuh (km) dan dimensi waktu (tanggal) secara mandiri:

- **Dimensi KM**:
  - `Terlambat`: Kilometer saat ini >= kilometer jatuh tempo (`dueKm`).
  - `Segera`: Sisa kilometer <= batas toleransi (500 km atau 10% interval).
  - `Aman`: Sisa kilometer berada di atas batas toleransi.
- **Dimensi Tanggal**:
  - `Terlambat`: Tanggal saat ini >= tanggal jatuh tempo (`dueDate`).
  - `Segera`: Sisa hari <= batas toleransi (14 hari atau 15% interval).
  - `Aman`: Sisa hari berada di atas batas toleransi.
- **Status Gabungan (`overallStatus`)**: Mengambil tingkat keparahan tertinggi di antara dimensi KM dan dimensi Tanggal (`Terlambat` > `Segera` > `Aman`).

### 6.2 Prioritas Urgensi Deterministik di Beranda

Untuk menampilkan 3 jadwal paling mendesak pada dasbor tanpa mengarang asumsi penggunaan harian, urutan ditentukan secara deterministik melalui kebijakan:
1. Status keparahan tertinggi (`Terlambat` lalu `Segera` lalu `Aman`).
2. Persentase kemajuan siklus normalisasi (`progress = elapsed / totalCycle`) menurun.
3. Pemecah seri (tie-breaker) deterministik berdasarkan nama pekerjaan secara alfabetis.

---

## 7. Manajemen Lampiran Foto & Penyimpanan

- **Batas Kapasitas File**: Ukuran file foto input maksimal 15MB, dengan target kompresi keluaran maksimal 2MB dan dimensi batas 1920 piksel.
- **Pemrosesan Latar Belakang**: Validasi format byte gambar dan kompresi dijalankan di thread background isolate (compute) agar antarmuka tidak tersendat (freeze).
- **Keamanan Penyimpanan**: Seluruh berkas disimpan di direktori dokumen privat aplikasi yang dilindungi dengan pemeriksaan path traversal (`_isSafePath`).
- **Pembersihan Berkas Fisik**:
  - Penghapusan satu lampiran menghapus berkas asli dan thumbnail terkait.
  - Penghapusan sepeda motor menghapus seluruh folder lampiran yang terhubung.
  - Lifecycle aplikasi menjalankan pembersihan otomatis terhadap file nota tanpa relasi (orphan files).

---

## 8. Notifikasi Lokal & Penanganan Zona Waktu

- **Engine Notifikasi**: Menggunakan `flutter_local_notifications` dengan konfigurasi Android channel berprioritas tinggi.
- **Zona Waktu Dinamis**: Sinkronisasi zona waktu perangkat (WIB / WITA / WIT) dikonfigurasi saat aplikasi pertama kali dibuka serta disegarkan setiap kali aplikasi kembali dari status jeda (resumed).
- **Penjadwalan Tepat Sasaran**:
  - Notifikasi tanggal dijadwalkan tepat pada jam pengingat default (pukul 09.00 waktu lokal) sebelum atau pada saat jatuh tempo.
  - Notifikasi kilometer hanya dipicu jika dimensi kilometer benar-benar mencapai ambang batas segera atau terlambat.
- **Transparansi Pembatalan**: Setiap pembatalan alarm mencatat status hasil pembatalan platform untuk mencegah alarm tertinggal.

---

## 9. Kebijakan Privasi & Android Auto Backup

- Aplikasi ini 100% offline-first dan tidak mengirimkan data ke internet. Izin `android.permission.INTERNET` dihilangkan sepenuhnya dari `AndroidManifest.xml`.
- Untuk mencegah sistem operasi menyalin basis data lokal dan foto nota pembayaran ke cadangan cloud akun Google pengguna tanpa disadari, berkas konfigurasi `backup_rules.xml` dan `data_extraction_rules.xml` dipasang dengan mengecualikan domain database, file, dan shared preferences, serta menetapkan `android:allowBackup="false"`.
- Fitur "Hapus Seluruh Data" di menu Pengaturan menyediakan verifikasi dua tahap yang membersihkan seluruh tabel database, membatalkan alarm pengingat, dan menghapus seluruh berkas fisik di disk.

---

## 10. Pengujian & Verifikasi Kualitas

Proyek ini dilengkapi dengan rangkaian pengujian otomatis lengkap yang mencakup unit test, widget test, dan integration workflow test:

- `test/unit/maintenance_calculator_test.dart`: Evaluasi independen dimensi km dan tanggal.
- `test/unit/service_odometer_consistency_test.dart`: Pencegahan penurunan odometer dan validasi kronologis.
- `test/unit/attachment_management_test.dart`: Validasi batas ukuran, kompresi foto, dan pembersihan orphan.
- `test/unit/safe_data_deletion_test.dart`: Verifikasi penghapusan menyeluruh dan laporan status terstruktur.
- `test/unit/report_calculations_test.dart`: Agregasi kueri laporan dan reaktivitas stream.
- `test/unit/notifications_reconciliation_test.dart`: Penjadwalan alarm, deteksi siklus, dan pembatalan pekerjaan.
- `test/unit/dashboard_reactivity_and_sorting_test.dart`: Urutan prioritas urgensi deterministik tanpa asumsi km/hari.
- `test/unit/database_migration_v1_to_v2_test.dart`: Keamanan migrasi skema SQLite Drift.
- `test/widget/`: Verifikasi tampilan dashboard, formulir motor, odometer, catatan servis, dan onboarding.
- `test/integration/app_workflows_integration_test.dart`: Simulasi alur kerja pengguna lengkap end-to-end.

Untuk menjalankan seluruh rangkaian uji:
```bash
flutter test
```

---

## 11. Panduan Build Rilis APK

Untuk menghasilkan paket aplikasi Android release siap pasang:

```bash
flutter build apk --release
```

Hasil berkas binary APK akan tersedia di:
`build/app/outputs/flutter-apk/app-release.apk`
