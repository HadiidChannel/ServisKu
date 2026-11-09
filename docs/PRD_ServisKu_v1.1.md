# PRODUCT REQUIREMENTS DOCUMENT (PRD)

# ServisKu

**Versi:** 1.1  
**Tanggal:** 6 November 2026  
**Catatan revisi:** Memperjelas pendekatan visual-first, penggunaan gambar dan ilustrasi, prinsip animasi, fallback aksesibilitas, serta pedoman penulisan tanpa en-dash dan em-dash.  
**Platform utama:** Android  
**Framework:** Flutter  
**Status dokumen:** Revisi arahan visual untuk penyusunan FSD dan implementasi MVP  
**Target pengguna:** Pemilik kendaraan pribadi, khusus sepeda motor

---

## 1. Ringkasan Produk

### 1.1 Deskripsi

ServisKu adalah aplikasi mobile untuk membantu pemilik sepeda motor menyimpan riwayat perawatan, memantau jadwal servis, mencatat biaya, dan mengingatkan pengguna ketika perawatan mendekati atau melewati jadwal.

Aplikasi dirancang untuk penggunaan pribadi. Pengguna dapat menyimpan satu atau beberapa sepeda motor dalam satu perangkat, memperbarui kilometer secara manual, mencatat pekerjaan servis, serta melihat riwayat dan pengeluaran setiap kendaraan.

Versi MVP menggunakan pendekatan **offline-first**. Data utama disimpan secara lokal di perangkat sehingga fitur inti tetap dapat digunakan tanpa koneksi internet. MVP tidak membutuhkan registrasi, login, backend, atau akun pengguna.

### 1.2 Masalah yang Ingin Diselesaikan

Pemilik sepeda motor sering menghadapi beberapa masalah berikut:

1. Lupa kapan terakhir mengganti oli atau melakukan perawatan lain.
2. Tidak memiliki catatan servis yang tersusun dan mudah dicari.
3. Sulit mengetahui total biaya perawatan kendaraan dari waktu ke waktu.
4. Nota servis mudah hilang atau tercecer.
5. Jadwal perawatan berdasarkan kilometer dan waktu sering tercampur atau hanya diingat secara manual.

ServisKu menggabungkan catatan kendaraan, jadwal perawatan, riwayat servis, dokumentasi, dan pengeluaran dalam satu aplikasi.

### 1.3 Proposisi Nilai

**ServisKu membantu pemilik motor merawat kendaraannya dengan catatan yang rapi, pengingat yang mudah dipahami, dan riwayat biaya yang dapat diperiksa kapan saja.**

### 1.4 Prinsip Produk

- **Mudah digunakan:** aktivitas umum dapat dilakukan dalam beberapa langkah.
- **Offline-first:** data inti dapat dibaca dan ditulis tanpa internet.
- **Personal:** aplikasi ditujukan untuk pemilik kendaraan, bukan pengelola bengkel.
- **Jelas:** status jadwal servis harus menjelaskan alasan suatu perawatan dianggap dekat atau terlambat.
- **Tidak berlebihan:** MVP memprioritaskan pencatatan dan pengingat, bukan fitur otomotif yang kompleks.
- **Aman dan privat:** data kendaraan disimpan secara lokal dan tidak dikirim ke server pada MVP.
- **Visual-first:** ilustrasi, gambar, dan animasi menjadi bagian penting dari pengalaman, tetapi tidak boleh mengganggu keterbacaan atau menyulitkan pengguna menyelesaikan tugas.
- **Berkarakter:** tampilan harus terasa seperti produk otomotif yang dirancang dengan sengaja, bukan kumpulan kartu generik atau template dashboard.

---

## 2. Tujuan, Sasaran, dan Batasan

### 2.1 Tujuan Produk

1. Memudahkan pengguna mengelola data sepeda motor pribadi.
2. Menyediakan riwayat servis yang terstruktur berdasarkan kendaraan.
3. Membantu pengguna mengetahui jadwal perawatan berikutnya.
4. Mengurangi risiko lupa perawatan melalui notifikasi lokal.
5. Menyediakan ringkasan biaya perawatan per kendaraan dan per periode.
6. Menjadi aplikasi Flutter portofolio yang memperlihatkan penerapan database lokal, state management, notifikasi, pengelolaan file, dan visualisasi data.

### 2.2 Sasaran MVP

MVP dianggap berhasil apabila pengguna dapat:

- Menambahkan dan mengelola data motor.
- Memperbarui kilometer kendaraan.
- Membuat jadwal perawatan berdasarkan kilometer, tanggal, atau keduanya.
- Mencatat satu kunjungan servis yang berisi satu atau beberapa pekerjaan.
- Melampirkan foto nota atau bukti servis.
- Melihat riwayat servis dan biaya.
- Menerima pengingat tanggal serta pemberitahuan ketika pembaruan kilometer menyebabkan jadwal mendekati atau melewati batas.
- Menggunakan seluruh fitur inti tanpa koneksi internet.

### 2.3 Di Luar Tujuan Produk

ServisKu bukan:

- Aplikasi pemesanan servis atau booking bengkel.
- Marketplace suku cadang atau layanan otomotif.
- Sistem kasir atau manajemen operasional bengkel.
- Aplikasi pelacakan GPS kendaraan.
- Sistem diagnostik kerusakan mesin.
- Pengganti buku manual kendaraan, rekomendasi pabrikan, atau pemeriksaan mekanik.

### 2.4 Platform dan Cakupan Kendaraan

| Aspek | Keputusan MVP |
|---|---|
| Platform | Android sebagai target rilis pertama |
| Framework | Flutter dan Dart |
| Jenis kendaraan | Sepeda motor |
| Varian motor | Matic, bebek, dan sport |
| Jumlah kendaraan | Satu atau lebih motor per pengguna/perangkat |
| Satuan jarak | Kilometer (km) |
| Mata uang | Rupiah (IDR) sebagai default |
| Bahasa | Bahasa Indonesia |
| Koneksi | Tidak wajib untuk fitur inti |
| Akun pengguna | Tidak tersedia pada MVP |

Motor listrik dapat menggunakan pencatatan perawatan kustom. Template perawatan bawaan MVP terutama ditujukan untuk motor berbahan bakar bensin. Template tidak boleh dianggap sebagai rekomendasi teknis resmi untuk semua model kendaraan.

---

## 3. Pengguna dan Kebutuhan

### 3.1 Persona Utama

**Pemilik motor pribadi**

- Memiliki satu atau beberapa sepeda motor.
- Menggunakan motor untuk kebutuhan harian.
- Melakukan servis di bengkel resmi atau bengkel umum.
- Tidak selalu menyimpan nota dan catatan perawatan secara teratur.
- Ingin mengetahui kapan kendaraan terakhir diservis dan kapan perawatan berikutnya perlu dilakukan.
- Tidak membutuhkan fitur manajemen bengkel atau administrasi armada.

### 3.2 Kebutuhan Pengguna

| ID | Kebutuhan | Nilai bagi pengguna |
|---|---|---|
| U-01 | Menyimpan data motor | Informasi kendaraan mudah ditemukan |
| U-02 | Memperbarui kilometer | Status jadwal berdasarkan jarak lebih relevan |
| U-03 | Mencatat servis | Riwayat perawatan tidak tercecer |
| U-04 | Mengatur jadwal perawatan | Pengguna memiliki acuan perawatan berikutnya |
| U-05 | Menerima pengingat | Mengurangi risiko lupa jadwal |
| U-06 | Menyimpan foto nota | Bukti servis tersimpan bersama riwayat |
| U-07 | Melihat biaya | Pengeluaran perawatan lebih mudah dievaluasi |
| U-08 | Menggunakan aplikasi tanpa internet | Aplikasi tetap berguna dalam kondisi offline |

### 3.3 Jobs to Be Done

- Ketika selesai servis, pengguna ingin mencatat pekerjaan dan biayanya agar dapat memeriksa riwayat kendaraan di kemudian hari.
- Ketika kilometer motor bertambah, pengguna ingin mengetahui apakah ada jadwal perawatan yang sudah dekat.
- Ketika jadwal servis mendekat, pengguna ingin menerima pengingat tanpa harus membuka aplikasi setiap hari.
- Ketika ingin mengevaluasi pengeluaran, pengguna ingin melihat total biaya perawatan dalam periode tertentu.

---

## 4. Ruang Lingkup Fitur

### 4.1 Prioritas

- **P0:** wajib tersedia agar MVP dapat digunakan.
- **P1:** penting, tetapi dapat ditambahkan setelah alur inti stabil.
- **P2:** pengembangan lanjutan.

| Modul | Fitur | Prioritas |
|---|---|---|
| Onboarding | Pengenalan singkat dan pembuatan motor pertama | P0 |
| Kendaraan | Tambah, lihat, ubah, hapus, dan pilih motor aktif | P0 |
| Odometer | Input dan riwayat pembaruan kilometer | P0 |
| Dashboard | Ringkasan motor, jadwal, dan aktivitas terbaru | P0 |
| Jadwal perawatan | Template, jadwal kustom, status, dan perhitungan jatuh tempo | P0 |
| Riwayat servis | Membuat, melihat, mengubah, dan menghapus catatan servis | P0 |
| Item servis | Satu kunjungan dapat berisi beberapa pekerjaan | P0 |
| Dokumentasi | Lampiran foto nota atau bukti servis | P0 |
| Pengingat | Notifikasi lokal berdasarkan tanggal dan pembaruan kilometer | P0 |
| Biaya | Ringkasan pengeluaran dan grafik sederhana | P0 |
| Pencarian | Cari dan filter riwayat servis | P1 |
| Backup dan restore | Ekspor dan impor data beserta lampiran | P1 |
| Tema | Light mode dan dark mode | P1 |
| Kunci aplikasi | PIN atau autentikasi biometrik | P2 |
| Sinkronisasi cloud | Sinkronisasi lintas perangkat | P2 |
| Ekspor laporan PDF | Laporan per kendaraan atau rentang tanggal | P2 |

---

## 5. Struktur Navigasi dan Halaman

### 5.1 Navigasi Utama

MVP menggunakan navigasi bawah dengan empat menu:

1. **Beranda:** ringkasan motor terpilih, jadwal yang perlu diperhatikan, dan aktivitas terakhir.
2. **Kendaraan:** daftar dan pengelolaan motor.
3. **Riwayat:** daftar kunjungan servis dan detail catatan.
4. **Laporan:** ringkasan biaya perawatan.

Pengaturan aplikasi dapat dibuka dari ikon pengaturan pada halaman Beranda atau melalui menu profil sederhana. Tombol aksi utama untuk menambahkan catatan servis harus mudah ditemukan.

### 5.2 Daftar Halaman

| ID | Halaman | Tujuan |
|---|---|---|
| SCR-01 | Splash | Menampilkan identitas aplikasi saat dibuka |
| SCR-02 | Onboarding | Menjelaskan manfaat dan alur awal |
| SCR-03 | Tambah Motor | Mengisi data motor pertama atau motor tambahan |
| SCR-04 | Beranda | Menampilkan ringkasan kendaraan dan status perawatan |
| SCR-05 | Daftar Kendaraan | Menampilkan seluruh motor pengguna |
| SCR-06 | Detail Kendaraan | Menampilkan data, kilometer, jadwal, dan ringkasan motor |
| SCR-07 | Form Odometer | Memperbarui kilometer saat ini |
| SCR-08 | Jadwal Perawatan | Mengelola daftar perawatan terjadwal |
| SCR-09 | Form Jadwal | Membuat atau mengubah jadwal perawatan |
| SCR-10 | Riwayat Servis | Menampilkan daftar kunjungan servis |
| SCR-11 | Form Catatan Servis | Membuat atau mengubah catatan kunjungan servis |
| SCR-12 | Detail Servis | Melihat pekerjaan, biaya, catatan, dan lampiran |
| SCR-13 | Laporan Biaya | Menampilkan ringkasan pengeluaran |
| SCR-14 | Pengaturan | Mengatur preferensi aplikasi dan notifikasi |
| SCR-15 | Backup dan Restore | Mengelola file cadangan ketika fitur P1 diterapkan |

### 5.3 Persyaratan UX Umum

- Desain harus mengutamakan keterbacaan, ruang kosong yang cukup, dan hierarki informasi yang jelas.
- Gunakan ilustrasi, gambar kendaraan, ikon kategori, dan visual status secara konsisten agar aplikasi terasa hidup dan mudah dikenali.
- Dashboard boleh memiliki area visual utama yang menampilkan ilustrasi atau foto motor aktif, tetapi informasi kilometer dan status servis harus tetap terlihat tanpa harus menggulir terlalu jauh.
- Gunakan visual untuk membantu pemahaman, bukan sekadar memenuhi ruang. Hindari menumpuk gambar, kartu, grafik, dan angka pada satu layar.
- Gunakan warna status secara konsisten: aman, segera, dan terlambat. Status tidak boleh hanya dibedakan dengan warna; sertakan teks atau ikon.
- Form menggunakan label yang jelas, validasi dekat dengan kolom terkait, serta nilai default yang masuk akal.
- Tanggal ditampilkan dalam format Indonesia, misalnya `6 Nov 2026`.
- Angka kilometer dan biaya menggunakan pemisah ribuan yang mudah dibaca.
- Light mode menggunakan latar terang, dominan putih atau netral. Dark mode disediakan sebagai preferensi P1.
- Animasi digunakan pada momen yang memiliki tujuan, seperti onboarding, pergantian kendaraan, perubahan status jadwal, progres, dan konfirmasi tindakan. Animasi tidak boleh menghambat interaksi.
- Hindari animasi berulang yang tidak memberi informasi, gerakan berlebihan, dan efek yang membuat teks sulit dibaca.
- Setiap halaman harus memiliki tampilan loading, kosong, berhasil, dan gagal sesuai kebutuhan. Empty state dan onboarding sebaiknya menggunakan ilustrasi yang relevan.
- Area sentuh tombol harus nyaman digunakan pada layar ponsel.
- Seluruh teks produk dan dokumentasi harus menggunakan tanda baca biasa. Jangan gunakan en-dash atau em-dash.

---

## 6. Persyaratan Fungsional

### 6.1 Onboarding dan Inisialisasi

**FR-ONB-01** Aplikasi harus menampilkan pengenalan singkat saat pertama kali dibuka.

**FR-ONB-02** Pengguna harus dapat melewati pengenalan dan langsung menambahkan motor.

**FR-ONB-03** Pengguna wajib membuat minimal satu data motor sebelum dapat menggunakan dashboard utama.

**FR-ONB-04** Setelah motor pertama berhasil disimpan, aplikasi menampilkan dashboard motor tersebut.

**FR-ONB-05** Onboarding tidak ditampilkan kembali setelah selesai, kecuali pengguna menghapus data aplikasi atau menginisialisasi ulang aplikasi.

### 6.2 Manajemen Kendaraan

**FR-VEH-01** Pengguna dapat menambahkan lebih dari satu sepeda motor.

**FR-VEH-02** Data minimal kendaraan terdiri dari nama panggilan, merek, model, dan kilometer saat ini.

**FR-VEH-03** Data tambahan kendaraan meliputi:

- Tipe motor: matic, bebek, atau sport.
- Tahun produksi.
- Nomor polisi, opsional.
- Jenis penggerak: bensin atau listrik.
- Catatan kendaraan, opsional.
- Foto kendaraan, opsional dan dapat ditambahkan setelah MVP.

**FR-VEH-04** Pengguna dapat mengubah data kendaraan.

**FR-VEH-05** Pengguna dapat menghapus kendaraan melalui dialog konfirmasi.

**FR-VEH-06** Penghapusan kendaraan harus menjelaskan bahwa jadwal, riwayat servis, odometer, dan lampiran yang terkait juga akan dihapus.

**FR-VEH-07** Pengguna dapat menentukan satu kendaraan sebagai kendaraan aktif untuk dashboard.

**FR-VEH-08** Saat aplikasi dibuka kembali, kendaraan aktif terakhir tetap dipilih.

**FR-VEH-09** Jika kendaraan aktif dihapus, aplikasi harus memilih kendaraan lain yang tersedia atau menampilkan alur tambah kendaraan apabila tidak ada kendaraan tersisa.

### 6.3 Odometer atau Kilometer

**FR-ODO-01** Pengguna dapat memperbarui kilometer kendaraan secara manual.

**FR-ODO-02** Setiap pembaruan kilometer menyimpan nilai kilometer dan tanggal pencatatan.

**FR-ODO-03** Aplikasi menampilkan kilometer terakhir dan tanggal pembaruannya.

**FR-ODO-04** Nilai kilometer tidak boleh negatif atau kosong.

**FR-ODO-05** Secara default, nilai kilometer baru tidak boleh lebih rendah daripada pembacaan terakhir. Jika pengguna perlu memperbaiki kesalahan input, aplikasi harus menyediakan alur koreksi dengan konfirmasi yang jelas.

**FR-ODO-06** Kilometer pada catatan servis juga menjadi sumber pembaruan odometer kendaraan apabila nilainya valid dan tidak bertentangan dengan aturan koreksi.

**FR-ODO-07** Riwayat pembaruan kilometer dapat dilihat pengguna.

**FR-ODO-08** Aplikasi tidak membaca kilometer secara otomatis dari kendaraan. Pengguna bertanggung jawab memperbarui angka odometer.

### 6.4 Dashboard

**FR-DASH-01** Dashboard menampilkan kendaraan aktif beserta nama, model, dan kilometer terakhir.

**FR-DASH-02** Dashboard menampilkan jumlah jadwal perawatan yang terlambat dan mendekati jatuh tempo.

**FR-DASH-03** Dashboard menampilkan maksimal tiga jadwal yang paling perlu diperhatikan.

**FR-DASH-04** Dashboard menampilkan aktivitas servis terakhir.

**FR-DASH-05** Dashboard menampilkan ringkasan biaya bulan berjalan untuk kendaraan aktif.

**FR-DASH-06** Pengguna dapat berpindah kendaraan tanpa harus kembali ke halaman awal.

**FR-DASH-07** Jika belum ada riwayat servis atau jadwal perawatan, dashboard menampilkan empty state dengan ajakan untuk menambahkan data.

### 6.5 Jadwal Perawatan

**FR-MNT-01** Pengguna dapat membuat jadwal perawatan untuk setiap kendaraan.

**FR-MNT-02** Pengguna dapat memilih jadwal berdasarkan salah satu atau kedua parameter berikut:

- Interval kilometer, misalnya setiap sejumlah km.
- Interval waktu, misalnya setiap sejumlah bulan.

**FR-MNT-03** Pengguna dapat membuat jadwal berdasarkan template umum atau mengisi jadwal kustom.

**FR-MNT-04** Template bawaan dapat mencakup, sesuai tipe motor:

- Oli mesin.
- Oli gardan untuk motor yang menggunakannya.
- Filter udara.
- Busi.
- Kampas rem.
- Minyak rem.
- Cairan pendingin untuk motor yang menggunakannya.
- CVT, roller, atau komponen transmisi terkait untuk motor matic.
- Rantai dan gear untuk motor yang menggunakannya.
- Ban.
- Aki atau baterai.
- Pemeriksaan umum.

**FR-MNT-05** Template hanya menjadi titik awal. Pengguna dapat menyesuaikan interval berdasarkan buku manual kendaraan atau arahan mekanik.

**FR-MNT-06** Setiap jadwal memiliki nama perawatan, interval, tanggal terakhir dilakukan, kilometer terakhir dilakukan, dan preferensi pengingat.

**FR-MNT-07** Pengguna dapat mengubah, menonaktifkan, atau menghapus jadwal.

**FR-MNT-08** Aplikasi menghitung jatuh tempo berdasarkan kilometer dan/atau tanggal.

**FR-MNT-09** Jika jadwal memiliki interval kilometer dan waktu sekaligus, status dianggap mendekati atau terlambat ketika salah satu batas tercapai.

**FR-MNT-10** Status jadwal minimal terdiri dari:

- **Aman:** belum memasuki rentang pengingat.
- **Segera:** sudah memasuki rentang pengingat.
- **Terlambat:** salah satu batas jatuh tempo telah tercapai atau terlewati.
- **Belum diatur:** data awal belum cukup untuk menghitung jadwal.

**FR-MNT-11** Pengguna dapat membuka detail jadwal untuk melihat alasan status, misalnya `tersisa 300 km` atau `terlambat 5 hari`.

**FR-MNT-12** Pengguna dapat menghubungkan pekerjaan servis dengan jadwal tertentu. Setelah pekerjaan tersebut dicatat selesai, tanggal dan kilometer terakhir pada jadwal diperbarui.

**FR-MNT-13** Jika tidak ada data tanggal atau kilometer terakhir, aplikasi harus meminta pengguna melengkapinya atau menandai jadwal sebagai belum diatur. Aplikasi tidak boleh membuat tanggal atau kilometer terakhir secara diam-diam.

### 6.6 Riwayat Servis

**FR-SRV-01** Pengguna dapat membuat catatan kunjungan servis untuk kendaraan tertentu.

**FR-SRV-02** Satu kunjungan servis dapat berisi satu atau beberapa pekerjaan.

**FR-SRV-03** Data kunjungan servis terdiri dari:

- Kendaraan.
- Tanggal servis.
- Kilometer saat servis.
- Nama bengkel atau lokasi servis, opsional.
- Satu atau beberapa item pekerjaan.
- Biaya setiap item.
- Catatan tambahan, opsional.
- Lampiran foto nota atau bukti servis, opsional.

**FR-SRV-04** Item pekerjaan minimal memiliki nama pekerjaan dan biaya. Kategori dan jadwal perawatan terkait dapat dipilih atau dibiarkan kosong.

**FR-SRV-05** Total biaya kunjungan dihitung dari jumlah biaya item pekerjaan dan komponen biaya tambahan jika disediakan.

**FR-SRV-06** Pengguna dapat melihat detail satu kunjungan servis.

**FR-SRV-07** Pengguna dapat mengubah atau menghapus catatan servis.

**FR-SRV-08** Saat catatan servis dihapus, aplikasi harus memberi tahu pengguna apabila catatan tersebut menjadi dasar pembaruan jadwal perawatan.

**FR-SRV-09** Aplikasi harus menjaga hubungan antara catatan servis, item pekerjaan, kendaraan, jadwal, dan lampiran.

**FR-SRV-10** Pengguna dapat melihat riwayat servis dalam urutan tanggal terbaru.

### 6.7 Lampiran dan Dokumentasi

**FR-ATT-01** Pengguna dapat menambahkan foto nota atau bukti servis ke kunjungan servis.

**FR-ATT-02** Pengguna dapat memilih gambar dari galeri atau mengambil foto melalui kamera jika izin tersedia.

**FR-ATT-03** Aplikasi memvalidasi tipe berkas gambar yang didukung dan menangani berkas yang tidak dapat dibaca.

**FR-ATT-04** Lampiran disimpan dalam direktori privat aplikasi, sedangkan database menyimpan metadata dan lokasi berkas.

**FR-ATT-05** Pengguna dapat melihat dan menghapus lampiran dari detail servis.

**FR-ATT-06** Jika gambar gagal disalin atau disimpan, catatan servis tetap dapat disimpan tanpa lampiran dan pengguna mendapat informasi yang jelas.

**FR-ATT-07** Penghapusan catatan servis atau kendaraan harus membersihkan lampiran terkait agar tidak meninggalkan berkas yatim.

### 6.8 Pengingat dan Notifikasi

**FR-NOT-01** Aplikasi menggunakan notifikasi lokal perangkat, bukan layanan push server.

**FR-NOT-02** Pengguna dapat mengaktifkan atau menonaktifkan pengingat.

**FR-NOT-03** Pengingat berbasis tanggal dapat dijadwalkan oleh aplikasi.

**FR-NOT-04** Pengingat berbasis kilometer diperiksa ketika pengguna memperbarui odometer atau ketika aplikasi menghitung ulang status jadwal.

**FR-NOT-05** Pengguna dapat mengatur jarak pengingat sebelum jadwal, misalnya beberapa ratus kilometer sebelum jatuh tempo.

**FR-NOT-06** Pengguna dapat mengatur waktu pengingat sebelum tanggal jatuh tempo, misalnya beberapa hari sebelumnya.

**FR-NOT-07** Jika izin notifikasi ditolak, fitur pencatatan tetap berjalan dan status jadwal tetap terlihat di dalam aplikasi.

**FR-NOT-08** Aplikasi harus mencegah notifikasi berulang untuk jadwal dan periode yang sama.

**FR-NOT-09** Setelah jadwal ditandai selesai melalui catatan servis, pengingat lama harus dibatalkan dan jadwal siklus berikutnya dihitung ulang.

**FR-NOT-10** Notifikasi harus menyebutkan nama perawatan dan kendaraan secara singkat tanpa memuat informasi yang tidak diperlukan.

**Catatan batasan:** Aplikasi tidak dapat mengetahui pertambahan kilometer kendaraan secara otomatis. Pengingat kilometer hanya akurat sesuai pembacaan odometer terakhir yang dimasukkan pengguna. Pengingat tanggal juga bergantung pada izin notifikasi serta kebijakan penghemat baterai dan sistem operasi perangkat.

### 6.9 Laporan dan Pengeluaran

**FR-REP-01** Aplikasi menghitung total biaya perawatan untuk kendaraan aktif.

**FR-REP-02** Pengguna dapat melihat total pengeluaran bulan berjalan.

**FR-REP-03** Pengguna dapat memilih rentang waktu laporan: bulan ini, tiga bulan terakhir, tahun ini, atau rentang kustom.

**FR-REP-04** Aplikasi menampilkan grafik pengeluaran per bulan.

**FR-REP-05** Aplikasi menampilkan rincian biaya berdasarkan kategori pekerjaan jika kategori tersedia.

**FR-REP-06** Pengguna dapat memfilter laporan berdasarkan kendaraan.

**FR-REP-07** Nilai total laporan harus berasal dari catatan servis yang tersimpan dan tidak boleh dihitung ganda.

### 6.10 Pencarian dan Filter

Fitur ini masuk prioritas P1.

**FR-SRC-01** Pengguna dapat mencari riwayat berdasarkan nama pekerjaan, nama bengkel, atau catatan.

**FR-SRC-02** Pengguna dapat memfilter riwayat berdasarkan kendaraan, kategori, dan rentang tanggal.

**FR-SRC-03** Hasil pencarian tetap menampilkan tanggal, kendaraan, ringkasan pekerjaan, dan total biaya.

### 6.11 Backup dan Restore

Fitur ini masuk prioritas P1.

**FR-BKP-01** Pengguna dapat mengekspor database dan lampiran menjadi satu paket cadangan.

**FR-BKP-02** Pengguna dapat memilih lokasi penyimpanan file melalui file picker sistem.

**FR-BKP-03** Pengguna dapat mengimpor file cadangan yang valid.

**FR-BKP-04** Sebelum restore, aplikasi harus menjelaskan apakah data yang ada akan diganti atau digabung. MVP P1 dapat memilih strategi replace-all untuk mengurangi konflik data, dengan konfirmasi eksplisit.

**FR-BKP-05** Aplikasi harus memvalidasi versi format, integritas file, dan struktur data sebelum memulihkan cadangan.

**FR-BKP-06** Jika restore gagal, database aktif tidak boleh berada dalam kondisi setengah terpulihkan.

### 6.12 Pengaturan

**FR-SET-01** Pengguna dapat mengatur preferensi notifikasi.

**FR-SET-02** Pengguna dapat mengatur tema aplikasi pada versi P1.

**FR-SET-03** Pengguna dapat melihat versi aplikasi dan informasi singkat privasi.

**FR-SET-04** Pengguna dapat menghapus seluruh data aplikasi melalui tindakan yang memerlukan konfirmasi berlapis.

---

## 7. Aturan Bisnis

### 7.1 Aturan Data Kendaraan

1. Setiap catatan servis, jadwal, dan pembacaan odometer harus terhubung ke satu kendaraan.
2. Nama panggilan kendaraan wajib diisi agar kendaraan mudah dibedakan.
3. Nomor polisi bersifat opsional karena tidak semua pengguna ingin menyimpannya.
4. Penghapusan kendaraan menghapus seluruh data turunannya setelah konfirmasi.

### 7.2 Aturan Odometer

1. Kilometer disimpan sebagai bilangan bulat dalam satuan km.
2. Kilometer tidak boleh bernilai negatif.
3. Pembacaan terbaru menjadi acuan status jadwal berbasis jarak.
4. Pengguna harus dapat melihat kapan kilometer terakhir diperbarui.
5. Koreksi pembacaan lama harus ditangani secara eksplisit agar histori dan perhitungan jadwal tidak berubah tanpa sepengetahuan pengguna.

### 7.3 Perhitungan Jadwal Perawatan

Untuk jadwal berbasis kilometer:

`km_jatuh_tempo = km_terakhir_dikerjakan + interval_km`

Untuk jadwal berbasis waktu:

`tanggal_jatuh_tempo = tanggal_terakhir_dikerjakan + interval_bulan`

Jika kedua interval tersedia, aplikasi memeriksa kedua batas. Perawatan dianggap jatuh tempo ketika salah satu batas tercapai.

Contoh:

- Perawatan terakhir dilakukan pada 10.000 km.
- Interval perawatan ditetapkan setiap 2.000 km.
- Jatuh tempo kilometer berikutnya adalah 12.000 km.
- Jika kilometer terkini 11.700 km, jadwal dapat berstatus segera apabila batas pengingat ditetapkan 500 km.
- Jika kilometer terkini 12.000 km atau lebih, jadwal berstatus terlambat atau jatuh tempo.

Untuk interval tanggal:

- Perawatan terakhir dilakukan pada 1 Januari.
- Interval ditetapkan setiap 3 bulan.
- Tanggal jatuh tempo adalah 1 April.
- Jika tanggal saat ini memasuki rentang pengingat, status menjadi segera.
- Jika tanggal saat ini sama dengan atau melewati tanggal jatuh tempo, status menjadi terlambat.

**Aturan penting:** tanggal dan kilometer tidak boleh diperkirakan otomatis. Jika data awal tidak tersedia, pengguna harus memasukkannya atau membiarkan jadwal berstatus belum diatur.

### 7.4 Urutan Prioritas Status

Jika kondisi kilometer dan tanggal menghasilkan status berbeda, gunakan status yang paling mendesak:

1. Terlambat.
2. Segera.
3. Aman.
4. Belum diatur jika data minimum tidak tersedia.

Jika salah satu batas yang aktif sudah terlewati, status keseluruhan adalah terlambat meskipun batas lainnya masih aman.

### 7.5 Aturan Pengingat

1. Pengingat tanggal dijadwalkan berdasarkan tanggal jatuh tempo dan preferensi lead time pengguna.
2. Pengingat kilometer diperiksa ketika odometer diperbarui.
3. Aplikasi tidak boleh menjanjikan pengingat kilometer real-time tanpa input odometer baru.
4. Satu siklus jadwal hanya boleh menghasilkan pengingat yang relevan sesuai konfigurasi. Aplikasi menyimpan identitas siklus dan waktu notifikasi terakhir untuk menghindari duplikasi.
5. Ketika jadwal selesai, identitas siklus pengingat diperbarui.

### 7.6 Aturan Biaya

1. Semua biaya disimpan sebagai bilangan bulat rupiah.
2. Biaya tidak boleh negatif.
3. Total kunjungan servis merupakan penjumlahan item pekerjaan dan biaya tambahan yang dicatat.
4. Laporan hanya menjumlahkan transaksi yang terkait dengan kendaraan dan periode terpilih.
5. Pengubahan atau penghapusan catatan harus langsung tercermin pada laporan.

### 7.7 Aturan Tanggal

1. Tanggal servis tidak boleh berada di masa depan secara default.
2. Pengguna dapat mencatat servis lama dengan memilih tanggal sebelumnya.
3. Aplikasi harus menggunakan tanggal lokal perangkat untuk tampilan dan penjadwalan.
4. Perhitungan bulan harus menangani tanggal yang tidak tersedia pada bulan tujuan. Contoh: penambahan satu bulan dari 31 Januari mengikuti tanggal valid terakhir pada bulan Februari.

---

## 8. Alur Pengguna Utama

### 8.1 Pengguna Baru

1. Pengguna membuka ServisKu.
2. Aplikasi menampilkan onboarding singkat.
3. Pengguna memilih mulai.
4. Aplikasi meminta pengguna menambahkan motor pertama.
5. Pengguna mengisi nama motor, merek, model, tipe, tahun jika diketahui, dan kilometer saat ini.
6. Aplikasi menyimpan data secara lokal.
7. Aplikasi mengarahkan pengguna ke dashboard.
8. Dashboard menampilkan instruksi untuk menambahkan jadwal perawatan pertama.

### 8.2 Menambahkan Motor Kedua

1. Pengguna membuka menu Kendaraan.
2. Pengguna memilih Tambah Motor.
3. Pengguna mengisi data kendaraan.
4. Aplikasi memvalidasi dan menyimpan data.
5. Motor baru muncul di daftar kendaraan.
6. Pengguna dapat menjadikannya kendaraan aktif.

### 8.3 Mencatat Servis

1. Pengguna memilih kendaraan.
2. Pengguna menekan tombol Tambah Catatan Servis.
3. Pengguna mengisi tanggal dan kilometer saat servis.
4. Pengguna menambahkan satu atau beberapa item pekerjaan.
5. Pengguna mengisi biaya setiap pekerjaan dan informasi bengkel jika ada.
6. Pengguna dapat menambahkan catatan dan foto nota.
7. Pengguna menyimpan catatan.
8. Aplikasi memvalidasi data, menyimpan kunjungan beserta itemnya, memperbarui odometer jika sesuai, dan memperbarui jadwal yang terhubung.
9. Aplikasi menampilkan detail servis atau konfirmasi berhasil.

### 8.4 Membuat Jadwal Perawatan

1. Pengguna membuka halaman Jadwal Perawatan.
2. Pengguna memilih template atau membuat jadwal kustom.
3. Pengguna mengisi nama perawatan.
4. Pengguna memilih interval kilometer, interval waktu, atau keduanya.
5. Pengguna mengisi tanggal dan/atau kilometer terakhir dilakukan.
6. Pengguna mengatur pengingat sebelum jatuh tempo.
7. Aplikasi menampilkan estimasi jatuh tempo jika data cukup.
8. Pengguna menyimpan jadwal.
9. Aplikasi menampilkan status jadwal.

### 8.5 Memperbarui Kilometer

1. Pengguna membuka dashboard atau detail kendaraan.
2. Pengguna menekan Perbarui Kilometer.
3. Aplikasi menampilkan nilai terakhir.
4. Pengguna memasukkan angka odometer terbaru.
5. Aplikasi memvalidasi nilai.
6. Pengguna menyimpan pembaruan.
7. Aplikasi memperbarui pembacaan odometer dan menghitung ulang seluruh jadwal berbasis kilometer.
8. Jika ada jadwal yang memasuki rentang pengingat atau terlambat, aplikasi menampilkan status baru dan mengirim notifikasi lokal sesuai aturan deduplikasi.

### 8.6 Melihat Pengeluaran

1. Pengguna membuka halaman Laporan.
2. Pengguna memilih kendaraan dan periode.
3. Aplikasi menghitung total biaya dari catatan servis.
4. Aplikasi menampilkan ringkasan dan grafik.
5. Pengguna dapat membuka catatan servis yang membentuk nilai laporan.

---

## 9. Model Data Konseptual

Database lokal menggunakan SQLite. Nama tabel dan kolom berikut merupakan rancangan konseptual yang dapat disesuaikan saat penyusunan FSD.

### 9.1 `motorcycles`

| Kolom | Tipe konseptual | Keterangan |
|---|---|---|
| id | TEXT/UUID | Primary key |
| nickname | TEXT | Nama panggilan motor, wajib |
| brand | TEXT | Merek |
| model | TEXT | Model atau varian |
| motorcycle_type | TEXT | Matic, bebek, sport |
| manufacture_year | INTEGER, nullable | Tahun produksi |
| license_plate | TEXT, nullable | Nomor polisi |
| propulsion_type | TEXT | Bensin atau listrik |
| notes | TEXT, nullable | Catatan |
| is_archived | INTEGER | Penanda arsip jika diperlukan |
| created_at | TEXT | Waktu pembuatan |
| updated_at | TEXT | Waktu perubahan |

### 9.2 `odometer_readings`

| Kolom | Tipe konseptual | Keterangan |
|---|---|---|
| id | TEXT/UUID | Primary key |
| motorcycle_id | TEXT | Relasi ke `motorcycles` |
| odometer_km | INTEGER | Pembacaan kilometer |
| reading_date | TEXT | Tanggal pembacaan |
| source | TEXT | Manual atau catatan servis |
| notes | TEXT, nullable | Catatan koreksi atau konteks |
| created_at | TEXT | Waktu pencatatan |

### 9.3 `maintenance_schedules`

| Kolom | Tipe konseptual | Keterangan |
|---|---|---|
| id | TEXT/UUID | Primary key |
| motorcycle_id | TEXT | Relasi ke `motorcycles` |
| name | TEXT | Nama perawatan |
| category | TEXT | Kategori perawatan |
| interval_km | INTEGER, nullable | Interval kilometer |
| interval_months | INTEGER, nullable | Interval bulan |
| last_done_km | INTEGER, nullable | Kilometer terakhir dilakukan |
| last_done_date | TEXT, nullable | Tanggal terakhir dilakukan |
| reminder_lead_km | INTEGER, nullable | Jarak pengingat sebelum jatuh tempo |
| reminder_lead_days | INTEGER, nullable | Hari pengingat sebelum jatuh tempo |
| is_active | INTEGER | Status aktif |
| created_at | TEXT | Waktu pembuatan |
| updated_at | TEXT | Waktu perubahan |

### 9.4 `service_records`

| Kolom | Tipe konseptual | Keterangan |
|---|---|---|
| id | TEXT/UUID | Primary key |
| motorcycle_id | TEXT | Relasi ke `motorcycles` |
| service_date | TEXT | Tanggal servis |
| odometer_km | INTEGER | Kilometer saat servis |
| workshop_name | TEXT, nullable | Nama bengkel atau lokasi |
| additional_cost | INTEGER | Biaya tambahan, default 0 |
| notes | TEXT, nullable | Catatan kunjungan |
| created_at | TEXT | Waktu pembuatan |
| updated_at | TEXT | Waktu perubahan |

### 9.5 `service_record_items`

| Kolom | Tipe konseptual | Keterangan |
|---|---|---|
| id | TEXT/UUID | Primary key |
| service_record_id | TEXT | Relasi ke `service_records` |
| maintenance_schedule_id | TEXT, nullable | Relasi ke jadwal jika pekerjaan menyelesaikan jadwal tertentu |
| item_name | TEXT | Nama pekerjaan |
| category | TEXT | Kategori pekerjaan |
| item_cost | INTEGER | Biaya pekerjaan |
| notes | TEXT, nullable | Catatan pekerjaan |

### 9.6 `service_attachments`

| Kolom | Tipe konseptual | Keterangan |
|---|---|---|
| id | TEXT/UUID | Primary key |
| service_record_id | TEXT | Relasi ke `service_records` |
| local_path | TEXT | Lokasi file privat aplikasi |
| file_name | TEXT | Nama tampilan |
| mime_type | TEXT | Tipe file |
| file_size | INTEGER | Ukuran file dalam byte |
| created_at | TEXT | Waktu lampiran dibuat |

### 9.7 `app_settings`

| Kolom | Tipe konseptual | Keterangan |
|---|---|---|
| key | TEXT | Primary key |
| value | TEXT | Nilai preferensi |
| updated_at | TEXT | Waktu perubahan |

### 9.8 Relasi Utama

- Satu `motorcycles` memiliki banyak `odometer_readings`.
- Satu `motorcycles` memiliki banyak `maintenance_schedules`.
- Satu `motorcycles` memiliki banyak `service_records`.
- Satu `service_records` memiliki satu atau banyak `service_record_items`.
- Satu `service_records` dapat memiliki nol atau banyak `service_attachments`.
- Satu `service_record_items` dapat terhubung ke nol atau satu `maintenance_schedules`.

### 9.9 Ketentuan Integritas Data

- Gunakan primary key yang stabil, disarankan UUID.
- Gunakan foreign key dan aturan cascade yang eksplisit.
- Simpan biaya sebagai integer rupiah, bukan floating point.
- Simpan tanggal dalam format ISO 8601 yang konsisten.
- Gunakan transaksi database ketika menyimpan kunjungan servis beserta item pekerjaan dan perubahan jadwal.
- Operasi penghapusan lampiran harus menangani kegagalan file system agar database dan berkas tidak menjadi tidak konsisten.

---

## 10. Rekomendasi Arsitektur dan Teknologi

Bagian ini merupakan arahan produk dan teknis awal, bukan pengganti FSD.

### 10.1 Stack yang Disarankan

| Komponen | Rekomendasi | Alasan |
|---|---|---|
| Mobile framework | Flutter | Satu basis kode untuk aplikasi mobile |
| Bahasa | Dart | Bahasa utama Flutter |
| State management | Riverpod | Pengelolaan state dan dependency yang terstruktur |
| Navigation | go_router | Navigasi dan pengelolaan route |
| Database | SQLite melalui Drift | Database relasional lokal dan dukungan query bertipe |
| Local notifications | flutter_local_notifications | Menjadwalkan notifikasi di perangkat |
| Grafik | fl_chart | Grafik biaya sederhana |
| Image selection | image_picker | Memilih atau mengambil foto |
| File path | path_provider | Menentukan direktori privat aplikasi |
| Formatting | intl | Format tanggal dan rupiah |

Versi package ditetapkan saat implementasi dengan memeriksa kompatibilitas terhadap versi Flutter stable yang digunakan. Hindari mengunci versi package berdasarkan dokumen PRD ini.

### 10.2 Pola Arsitektur

Gunakan pemisahan tanggung jawab sederhana:

- **Presentation:** halaman, widget, komponen visual, dan interaksi pengguna.
- **State/Application:** state management, validasi alur, dan koordinasi use case.
- **Domain:** entitas dan aturan bisnis seperti perhitungan jatuh tempo.
- **Data:** repository, database lokal, pemrosesan file, dan notifikasi.

Logika perhitungan jadwal tidak boleh ditempatkan langsung di widget UI. Buat fungsi atau service domain yang dapat diuji secara terpisah.

### 10.3 Prinsip Penyimpanan

- SQLite menjadi sumber utama data terstruktur.
- Foto disimpan di direktori privat aplikasi.
- Database hanya menyimpan metadata dan referensi berkas.
- Gunakan transaksi untuk operasi yang melibatkan beberapa tabel.
- Sediakan skema migrasi database agar perubahan versi aplikasi tidak merusak data lama.
- Hindari menyimpan data aplikasi pada direktori publik tanpa kebutuhan yang jelas.

### 10.4 Ketergantungan Jaringan

MVP tidak membutuhkan server. Jika koneksi internet tidak tersedia, pengguna tetap dapat:

- Membuka dashboard.
- Mengelola kendaraan.
- Mengubah odometer.
- Mengelola jadwal.
- Mencatat servis.
- Membuka lampiran.
- Melihat laporan.

Tidak boleh ada fitur inti yang gagal hanya karena perangkat sedang offline.

---

## 11. Persyaratan Nonfungsional

### 11.1 Performa

**NFR-PER-01** Aplikasi harus dapat dibuka dan digunakan pada perangkat Android kelas menengah yang masih didukung Flutter.

**NFR-PER-02** Operasi baca dan tulis lokal untuk data umum harus terasa responsif dan tidak membekukan antarmuka.

**NFR-PER-03** Proses pemilihan dan penyimpanan foto harus menampilkan indikator proses jika membutuhkan waktu.

**NFR-PER-04** Grafik dan daftar riwayat harus tetap lancar untuk jumlah data penggunaan pribadi yang wajar.

### 11.2 Keandalan

**NFR-REL-01** Data yang telah berhasil disimpan harus tetap tersedia setelah aplikasi ditutup dan dibuka kembali.

**NFR-REL-02** Kegagalan menyimpan lampiran tidak boleh menghapus catatan servis yang sudah berhasil disimpan.

**NFR-REL-03** Operasi multi-tabel harus menggunakan transaksi agar tidak meninggalkan data parsial.

**NFR-REL-04** Aplikasi harus menangani database kosong, lampiran hilang, izin ditolak, dan kegagalan notifikasi tanpa crash.

**NFR-REL-05** Database harus memiliki mekanisme migrasi yang diuji sebelum versi baru dirilis.

### 11.3 Keamanan dan Privasi

**NFR-SEC-01** Data kendaraan dan riwayat servis disimpan di ruang privat aplikasi pada perangkat.

**NFR-SEC-02** MVP tidak mengirim nomor polisi, foto nota, data kendaraan, atau riwayat servis ke server mana pun.

**NFR-SEC-03** Aplikasi hanya meminta izin perangkat yang diperlukan, seperti kamera, foto/media, dan notifikasi sesuai fitur yang digunakan.

**NFR-SEC-04** Aplikasi tidak boleh mencatat informasi sensitif seperti nomor polisi atau isi nota ke log produksi.

**NFR-SEC-05** Input pengguna harus divalidasi dan query database harus menggunakan parameter binding atau mekanisme aman dari library database.

**NFR-SEC-06** File lampiran harus diproses sebagai file lokal, memvalidasi tipe dan ukuran, serta tidak dieksekusi sebagai kode.

**NFR-SEC-07** Aplikasi harus menjelaskan konsekuensi penghapusan data kendaraan atau seluruh data aplikasi.

**NFR-SEC-08** Jika backup dan restore dirilis, format cadangan harus divalidasi sebelum data aktif diganti. Dukungan enkripsi file backup perlu ditetapkan sebelum fitur tersebut dirilis ke publik.

**NFR-SEC-09** Aplikasi tidak boleh mengklaim data sepenuhnya aman dari semua bentuk kompromi perangkat. Risiko perangkat yang hilang, di-root, atau diakses pihak lain tetap berada di luar kendali aplikasi.

### 11.4 Privasi

- Tidak wajib membuat akun.
- Tidak ada pelacakan lokasi atau GPS.
- Tidak ada pengumpulan analitik pihak ketiga pada MVP.
- Informasi privasi harus menjelaskan bahwa data disimpan secara lokal.
- Pengguna harus dapat menghapus data melalui aplikasi.
- Pengguna perlu diberi tahu bahwa menghapus aplikasi atau membersihkan data aplikasi dapat menghilangkan data lokal jika belum dicadangkan.

### 11.5 Usability dan Aksesibilitas

**NFR-UX-01** Antarmuka menggunakan Bahasa Indonesia yang konsisten.

**NFR-UX-02** Istilah teknis harus dijelaskan dengan bahasa sederhana.

**NFR-UX-03** Ukuran teks, kontras, dan area sentuh harus nyaman pada layar smartphone.

**NFR-UX-04** Status tidak boleh disampaikan hanya melalui warna.

**NFR-UX-05** Form harus mempertahankan input ketika validasi gagal.

**NFR-UX-06** Pengguna harus menerima umpan balik setelah tindakan penting, seperti menyimpan atau menghapus data.

**NFR-UX-07** Ilustrasi dan gambar harus menjadi elemen visual utama pada area yang relevan, seperti onboarding, ringkasan kendaraan, kategori perawatan, empty state, dan detail dokumentasi. Gambar tidak boleh mengurangi keterbacaan informasi inti.

**NFR-UX-08** Setiap ilustrasi harus memiliki tujuan yang jelas, seperti mengenalkan fitur, memberi konteks kendaraan, menjelaskan status, atau membantu pengguna memahami kondisi tanpa data.

**NFR-UX-09** Animasi harus memiliki tujuan interaksi atau komunikasi. Prioritaskan animasi transisi, micro-interaction, feedback keberhasilan, perubahan status, dan visualisasi progres.

**NFR-UX-10** Animasi harus berjalan lancar pada perangkat Android kelas menengah yang menjadi target. Animasi tidak boleh menyebabkan input terlambat, scroll tersendat, atau konsumsi sumber daya yang tidak perlu.

**NFR-UX-11** Sediakan tampilan statis sebagai fallback untuk animasi yang gagal dimuat atau ketika pengaturan aksesibilitas perangkat meminta gerakan dikurangi. Informasi penting tidak boleh hanya tersedia melalui animasi.

**NFR-UX-12** Gambar lokal harus dioptimalkan dari sisi resolusi dan ukuran berkas. Aplikasi tidak boleh bergantung pada koneksi internet untuk menampilkan ilustrasi inti atau menyelesaikan alur utama.

**NFR-UX-13** Gerakan, warna, dan ilustrasi tidak boleh menjadi satu-satunya cara menyampaikan status. Gunakan teks, ikon, label, atau nilai yang tetap terbaca.

### 11.6 Kompatibilitas

- Target utama adalah Android.
- Layout harus responsif terhadap variasi ukuran layar smartphone.
- Orientasi utama adalah portrait.
- Versi minimum Android ditetapkan saat implementasi berdasarkan versi Flutter dan package yang dipilih.

---

## 12. Desain Visual, Ilustrasi, dan Interaksi Animasi

### 12.1 Arah Visual

ServisKu menggunakan pendekatan **visual-first**, dengan gambar dan ilustrasi sebagai bagian utama dari identitas produk. Aplikasi harus terasa modern, bersahabat, dan dekat dengan aktivitas pemilik motor. Tampilan tidak boleh terasa seperti dashboard administrasi yang kaku atau template aplikasi generik.

Arah visual yang diinginkan:

- Light mode menjadi tampilan utama dengan latar putih atau netral yang terang.
- Gunakan satu warna aksen utama yang kuat tetapi tidak menyilaukan, didukung palet netral dan warna status yang konsisten.
- Gunakan ilustrasi motor, komponen kendaraan, perlengkapan servis, dan visual perawatan sebagai aksen visual yang mudah dikenali.
- Gunakan komposisi asimetris secara terukur, area hero, tipografi yang jelas, dan ruang kosong yang cukup agar tampilan memiliki karakter.
- Dashboard harus menggabungkan satu visual utama dengan informasi penting seperti kilometer, jadwal terdekat, dan aktivitas terakhir.
- Hindari menampilkan terlalu banyak kartu dengan bentuk, ukuran, dan warna yang sama. Variasikan komposisi berdasarkan fungsi konten.
- Gunakan foto motor milik pengguna sebagai opsi personalisasi ketika fitur foto kendaraan tersedia. Jika belum ada foto, tampilkan ilustrasi bawaan yang konsisten.
- Hindari penggunaan foto stok yang tidak relevan, gambar dekoratif yang berulang, gradient berlebihan, dan ornamen yang tidak memiliki fungsi.
- Jangan menggunakan logo atau identitas merek kendaraan tanpa kebutuhan dan izin yang sesuai. Ilustrasi generik lebih aman sebagai aset bawaan.

### 12.2 Penggunaan Gambar dan Ilustrasi

Gambar merupakan elemen penting, bukan sekadar hiasan. Area penggunaan visual meliputi:

| Area | Bentuk visual | Tujuan |
|---|---|---|
| Onboarding | Ilustrasi motor dan aktivitas perawatan | Menjelaskan manfaat aplikasi dengan cepat |
| Dashboard | Ilustrasi atau foto motor aktif | Memberi identitas visual pada kendaraan pengguna |
| Kategori perawatan | Ikon atau ilustrasi komponen | Membantu pengguna mengenali jenis pekerjaan |
| Jadwal perawatan | Ikon, ilustrasi kecil, dan indikator progres | Menjelaskan kondisi jadwal dengan cepat |
| Empty state | Ilustrasi kontekstual | Memberi arahan saat belum ada data |
| Riwayat servis | Thumbnail lampiran dan ikon pekerjaan | Memudahkan pemindaian catatan |
| Laporan | Grafik dan ilustrasi pendukung seperlunya | Membantu pengguna memahami pengeluaran |
| Konfirmasi tindakan | Ilustrasi atau ikon status | Memberikan umpan balik yang jelas |

Ketentuan aset visual:

- Ilustrasi bawaan sebaiknya menggunakan gaya yang konsisten, misalnya vector illustration dengan bentuk sederhana dan detail yang terkontrol.
- Aset inti disimpan secara lokal di dalam aplikasi. Jangan mengambil gambar dari internet setiap kali halaman dibuka.
- Gunakan format SVG atau vector yang sesuai untuk ilustrasi, serta WebP atau format raster teroptimasi untuk foto dan gambar kompleks.
- Foto yang dipilih pengguna harus disimpan di direktori privat aplikasi sesuai ketentuan lampiran.
- Setiap gambar harus memiliki rasio, ukuran, dan ruang penempatan yang direncanakan agar layout tidak bergeser ketika gambar dimuat.
- Sediakan placeholder atau fallback jika foto kendaraan maupun lampiran tidak tersedia.
- Hindari gambar resolusi sangat besar jika tidak dibutuhkan. Buat thumbnail untuk daftar dan gunakan gambar resolusi lebih tinggi hanya pada halaman detail.

### 12.3 Prinsip Animasi dan Motion

Animasi harus memberi kesan aplikasi yang responsif dan dirancang dengan baik. Animasi bukan tujuan tersendiri dan tidak boleh memperlambat pekerjaan pengguna.

Animasi yang direkomendasikan:

| Momen | Animasi | Tujuan |
|---|---|---|
| Splash dan onboarding | Ilustrasi masuk dengan gerakan ringan | Memperkenalkan karakter aplikasi |
| Dashboard | Konten muncul bertahap dengan transisi halus | Membangun hierarki visual tanpa membuat layar ramai |
| Pergantian motor aktif | Transisi gambar dan informasi kendaraan | Menegaskan bahwa konteks kendaraan berubah |
| Pembaruan odometer | Angka berubah dengan animasi singkat | Memberi umpan balik pada nilai baru |
| Status jadwal | Indikator atau progress ring berubah | Membantu memahami jarak menuju jatuh tempo |
| Simpan catatan servis | Check animation atau feedback sukses | Menegaskan bahwa data berhasil disimpan |
| Empty state | Ilustrasi dengan gerakan ringan saat pertama tampil | Membuat layar kosong terasa informatif |
| Navigasi halaman | Transisi singkat dan konsisten | Menjaga kesinambungan perpindahan halaman |

Batasan motion:

- Durasi animasi mikro umumnya sekitar 150 sampai 300 milidetik. Animasi ilustrasi dapat sedikit lebih lama jika tidak menghambat alur.
- Hindari animasi panjang sebelum pengguna dapat berinteraksi dengan halaman.
- Hindari autoplay berulang pada animasi dekoratif. Animasi loop hanya boleh digunakan jika sangat ringan dan memiliki tujuan yang jelas.
- Jangan menjalankan beberapa animasi besar secara bersamaan pada satu layar.
- Jangan menganimasikan seluruh item daftar ketika pengguna melakukan scroll.
- Animasi tidak boleh menggeser tombol, nilai, atau teks penting secara tidak terduga.
- Hormati preferensi aksesibilitas untuk mengurangi gerakan jika tersedia. Sediakan versi statis ketika animasi dinonaktifkan.
- Gunakan animasi bawaan Flutter untuk interaksi sederhana. Lottie atau Rive dapat dipertimbangkan untuk ilustrasi khusus, tetapi bukan ketergantungan wajib.

### 12.4 Komposisi Halaman Utama

**Beranda**

- Memiliki area visual utama untuk motor aktif, berupa foto pengguna atau ilustrasi bawaan.
- Menampilkan nama motor dan kilometer dengan hierarki yang mudah dilihat.
- Menampilkan satu fokus utama, yaitu jadwal perawatan yang paling mendesak.
- Menyediakan ringkasan jadwal lain dan aktivitas terakhir tanpa memadati layar.
- Tombol tambah catatan servis harus mudah ditemukan dan dapat dijangkau dengan satu tangan.

**Detail Kendaraan**

- Menampilkan foto atau ilustrasi motor pada bagian atas.
- Mengelompokkan informasi dasar, kilometer, jadwal, dan riwayat secara terpisah.
- Menyediakan akses cepat untuk memperbarui kilometer dan mencatat servis.

**Jadwal Perawatan**

- Menggunakan ikon atau ilustrasi berbeda untuk kategori utama.
- Menampilkan label status, sisa kilometer, atau sisa hari dengan jelas.
- Indikator progres bersifat pendukung dan harus disertai angka atau keterangan teks.

**Riwayat Servis**

- Menggunakan thumbnail nota jika tersedia.
- Menampilkan tanggal, kilometer, ringkasan pekerjaan, dan biaya tanpa membuka detail terlebih dahulu.
- Memakai timeline atau pengelompokan waktu jika membantu pemindaian riwayat.

**Laporan**

- Grafik menjadi fokus visual, tetapi nilai total dan periode harus tetap terbaca.
- Hindari terlalu banyak warna kategori dalam satu grafik.
- Tampilkan empty state ilustratif ketika belum ada transaksi.

### 12.5 Komponen UI Utama

- Vehicle hero atau vehicle selector dengan ilustrasi atau foto motor.
- Odometer display dengan animasi angka yang singkat.
- Maintenance status visual dengan ikon, label, dan indikator progres.
- Maintenance category illustration.
- Service history item dengan thumbnail lampiran.
- Expense chart dan ringkasan biaya.
- Empty state illustration untuk daftar yang belum memiliki data.
- Success feedback dengan animasi singkat.
- Confirmation dialog dengan ilustrasi hanya jika konteksnya penting, misalnya penghapusan data.
- Bottom sheet untuk aksi cepat jika relevan.
- Form input dengan label, validasi, dan fokus visual yang jelas.

### 12.6 Umpan Balik Sistem

Contoh pesan yang disarankan:

- `Kilometer berhasil diperbarui.`
- `Catatan servis berhasil disimpan.`
- `Jadwal perawatan berhasil diperbarui.`
- `Izin notifikasi belum diberikan. Pengingat tetap dapat dilihat di aplikasi.`
- `Kilometer yang dimasukkan lebih rendah dari pembacaan terakhir. Periksa kembali atau gunakan koreksi odometer.`

Pesan penting harus tetap tampil sebagai teks. Animasi dan ilustrasi hanya memperkuat feedback, bukan menggantikan pesan.

### 12.7 Pedoman Penulisan dan Gaya Konten

- Gunakan Bahasa Indonesia yang ringkas, natural, dan tidak terlalu formal.
- Hindari kalimat promosi yang berlebihan, jargon yang tidak perlu, dan teks placeholder generik.
- Jangan menggunakan en-dash atau em-dash pada teks UI, dokumentasi produk, maupun materi pengembangan. Gunakan koma, titik, titik dua, atau tanda kurung sesuai konteks.
- Nama tombol harus menjelaskan tindakan, misalnya `Tambah catatan servis`, `Perbarui kilometer`, dan `Simpan jadwal`.
- Hindari penggunaan terlalu banyak huruf kapital, label dekoratif, atau istilah bahasa Inggris jika istilah Indonesia lebih mudah dipahami.

---

## 13. Kriteria Penerimaan MVP

MVP dinyatakan memenuhi kebutuhan dasar apabila seluruh skenario P0 berikut berhasil.

### 13.1 Kendaraan

- [ ] Pengguna dapat menambahkan motor dengan data wajib.
- [ ] Pengguna dapat mengubah data motor.
- [ ] Pengguna dapat menyimpan lebih dari satu motor.
- [ ] Pengguna dapat berpindah kendaraan aktif.
- [ ] Penghapusan motor menampilkan konsekuensi dan meminta konfirmasi.

### 13.2 Odometer

- [ ] Pengguna dapat memperbarui kilometer.
- [ ] Nilai negatif dan input kosong ditolak.
- [ ] Input yang lebih rendah dari pembacaan terakhir ditangani melalui validasi atau alur koreksi.
- [ ] Riwayat pembacaan kilometer tersimpan.
- [ ] Jadwal berbasis kilometer dihitung ulang setelah pembaruan.

### 13.3 Jadwal Perawatan

- [ ] Pengguna dapat membuat jadwal dengan interval kilometer.
- [ ] Pengguna dapat membuat jadwal dengan interval waktu.
- [ ] Pengguna dapat membuat jadwal dengan kedua interval.
- [ ] Status aman, segera, terlambat, dan belum diatur muncul sesuai aturan.
- [ ] Detail jadwal menjelaskan dasar status.
- [ ] Jadwal yang dihubungkan dengan pekerjaan servis diperbarui setelah servis disimpan.

### 13.4 Riwayat Servis

- [ ] Pengguna dapat membuat satu kunjungan dengan beberapa item pekerjaan.
- [ ] Total biaya dihitung dengan benar.
- [ ] Pengguna dapat melihat detail servis.
- [ ] Pengguna dapat mengubah dan menghapus catatan.
- [ ] Perubahan catatan tercermin pada laporan biaya.

### 13.5 Lampiran

- [ ] Pengguna dapat memilih foto dari galeri.
- [ ] Aplikasi dapat menyimpan dan menampilkan foto.
- [ ] Aplikasi menangani izin yang ditolak.
- [ ] Penghapusan catatan membersihkan lampiran terkait.

### 13.6 Notifikasi

- [ ] Pengguna dapat mengaktifkan dan menonaktifkan pengingat.
- [ ] Pengingat tanggal dijadwalkan sesuai konfigurasi.
- [ ] Perubahan kilometer memicu evaluasi jadwal berbasis jarak.
- [ ] Notifikasi tidak dikirim berulang untuk siklus yang sama.
- [ ] Aplikasi tetap berjalan ketika izin notifikasi ditolak.

### 13.7 Laporan dan Offline

- [ ] Total pengeluaran dihitung berdasarkan periode dan kendaraan yang dipilih.
- [ ] Grafik menampilkan data sesuai transaksi tersimpan.
- [ ] Dashboard, riwayat, jadwal, dan laporan dapat dibuka tanpa internet.
- [ ] Data tetap tersedia setelah aplikasi ditutup dan dibuka kembali.

### 13.8 Visual, Gambar, dan Animasi

- [ ] Onboarding menggunakan ilustrasi yang relevan dengan perawatan motor.
- [ ] Dashboard menampilkan foto motor pengguna atau ilustrasi bawaan.
- [ ] Kategori perawatan utama memiliki ikon atau ilustrasi yang konsisten.
- [ ] Empty state menggunakan ilustrasi dan arahan tindakan yang relevan.
- [ ] Perubahan motor aktif, pembaruan kilometer, dan penyimpanan servis memiliki feedback visual yang sesuai.
- [ ] Animasi tidak menghalangi input, navigasi, atau pembacaan informasi.
- [ ] Informasi penting tetap tersedia dalam bentuk teks atau tampilan statis.
- [ ] Aplikasi tetap dapat menampilkan aset visual inti tanpa koneksi internet.
- [ ] Tampilan tetap nyaman digunakan ketika animasi dikurangi atau dinonaktifkan.
- [ ] Gambar dan animasi diuji pada perangkat Android kelas menengah.

---

## 14. Skenario Pengujian Penting

| ID | Skenario | Hasil yang diharapkan |
|---|---|---|
| TC-01 | Tambah motor tanpa nama panggilan | Sistem menolak dan menunjukkan validasi |
| TC-02 | Tambah motor dengan data valid | Motor tersimpan dan tampil di daftar |
| TC-03 | Input odometer negatif | Sistem menolak input |
| TC-04 | Input odometer lebih rendah dari nilai terakhir | Sistem meminta pemeriksaan atau koreksi eksplisit |
| TC-05 | Jadwal hanya memiliki interval km | Status dihitung berdasarkan kilometer |
| TC-06 | Jadwal hanya memiliki interval bulan | Status dihitung berdasarkan tanggal |
| TC-07 | Jadwal memiliki interval km dan bulan | Batas yang lebih mendesak menentukan status |
| TC-08 | Jadwal tidak memiliki data terakhir | Status belum diatur dan aplikasi meminta data yang kurang |
| TC-09 | Pengguna menambah servis dengan tiga item | Semua item tersimpan dan total dihitung benar |
| TC-10 | Foto gagal disimpan | Catatan servis tetap tersimpan dan pesan kegagalan ditampilkan |
| TC-11 | Pengguna menghapus kendaraan | Data terkait dihapus setelah konfirmasi |
| TC-12 | Pengguna menolak izin notifikasi | Fitur lain tetap berjalan dan status jadwal tetap tampil |
| TC-13 | Odometer melewati batas pengingat | Status jadwal dihitung ulang dan notifikasi diproses sesuai aturan |
| TC-14 | Catatan servis diedit | Ringkasan biaya dan jadwal terkait diperbarui secara konsisten |
| TC-15 | Aplikasi dibuka tanpa internet | Seluruh fitur inti tetap dapat digunakan |
| TC-16 | Aplikasi ditutup paksa setelah penyimpanan selesai | Data yang sudah berhasil disimpan tetap tersedia |
| TC-17 | Jadwal tanggal jatuh tempo pada akhir bulan | Perhitungan bulan menghasilkan tanggal valid |
| TC-18 | Jadwal diubah setelah notifikasi dibuat | Notifikasi lama dibatalkan dan jadwal baru dihitung ulang |
| TC-19 | Aplikasi dibuka tanpa koneksi internet | Ilustrasi dan aset visual inti tetap tampil |
| TC-20 | Foto motor belum ditambahkan | Dashboard menampilkan ilustrasi bawaan tanpa layout kosong |
| TC-21 | Animasi dinonaktifkan atau gerakan dikurangi | Informasi tetap lengkap dan semua aksi tetap dapat digunakan |
| TC-22 | Perangkat mengalami penurunan performa saat animasi | Aplikasi tetap responsif dan tidak mengunci interaksi |
| TC-23 | Gambar lampiran gagal dimuat | Placeholder ditampilkan dan halaman tidak crash |

---

## 15. Risiko dan Mitigasi

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Pengguna lupa memperbarui odometer | Pengingat berbasis km kurang akurat | Tampilkan tanggal pembacaan terakhir dan ajakan memperbarui km |
| Izin notifikasi ditolak | Pengguna tidak menerima pengingat | Tetap tampilkan status jadwal di dashboard dan halaman jadwal |
| Kebijakan baterai perangkat membatasi notifikasi | Pengingat tanggal dapat terlambat | Jelaskan keterbatasan sistem dan uji pada beberapa perangkat |
| Data lokal hilang saat aplikasi dihapus | Riwayat pengguna hilang | Sediakan backup pada prioritas P1 dan peringatan privasi |
| Foto berukuran besar | Penyimpanan cepat penuh | Kompres gambar dan batasi ukuran/kuantitas lampiran |
| Pengguna memasukkan jadwal yang tidak sesuai motor | Perawatan tidak tepat waktu | Jelaskan bahwa interval perlu mengacu pada buku manual atau mekanik |
| Perubahan skema database | Data versi lama berisiko rusak | Gunakan migrasi dan uji upgrade database |
| Perhitungan tanggal atau kilometer tidak konsisten | Status servis salah | Pisahkan business logic dan buat unit test untuk batas perhitungan |
| Penghapusan data tidak menyeluruh | File yatim atau data tertinggal | Terapkan prosedur penghapusan relasional dan pembersihan file |

---

## 16. Roadmap Pengembangan

### Tahap 1: Fondasi Aplikasi

- Inisialisasi proyek Flutter.
- Struktur folder dan arsitektur.
- Konfigurasi database SQLite.
- Skema tabel dan migrasi awal.
- Sistem navigasi dan tema dasar.
- Penetapan design system, tipografi, palet warna, ikon, dan gaya ilustrasi.
- Pembuatan aset visual inti untuk onboarding, kendaraan, kategori perawatan, dan empty state.

**Hasil:** aplikasi dapat berjalan, menyimpan data kendaraan lokal, dan memiliki fondasi visual yang konsisten.

### Tahap 2: Kendaraan dan Odometer

- Onboarding.
- Tambah, ubah, hapus, dan pilih motor.
- Pembaruan odometer.
- Riwayat pembacaan kilometer.

**Hasil:** pengguna dapat mengelola motor dan pembacaan kilometernya.

### Tahap 3: Jadwal Perawatan

- Template perawatan.
- Form jadwal kustom.
- Kalkulasi status berdasarkan km dan tanggal.
- Pengujian aturan jatuh tempo.

**Hasil:** pengguna dapat mengelola dan memantau jadwal perawatan.

### Tahap 4: Riwayat Servis dan Lampiran

- Form kunjungan servis.
- Item pekerjaan dan biaya.
- Relasi ke jadwal perawatan.
- Foto nota atau bukti servis.

**Hasil:** setiap aktivitas servis dapat dicatat dan ditelusuri.

### Tahap 5: Pengingat dan Dashboard

- Notifikasi lokal.
- Evaluasi jadwal setelah pembaruan odometer.
- Pencegahan notifikasi duplikat.
- Dashboard ringkas.

**Hasil:** pengguna memperoleh pengingat dan ringkasan kondisi perawatan.

### Tahap 6: Laporan dan Penyempurnaan

- Ringkasan biaya.
- Grafik pengeluaran.
- Validasi alur utama.
- Pengujian offline dan migrasi database.
- Penyempurnaan ilustrasi, micro-interaction, transisi, dan feedback animasi.
- Pengujian performa motion pada perangkat Android kelas menengah.
- Penyempurnaan tampilan statis dan aksesibilitas.

**Hasil:** MVP siap digunakan dan didemonstrasikan sebagai proyek portofolio dengan identitas visual yang kuat.

### Tahap 7: Pengembangan Setelah MVP

- Pencarian dan filter lanjutan.
- Backup dan restore.
- Dark mode.
- Ekspor laporan PDF.
- Kunci aplikasi.
- Sinkronisasi cloud jika kebutuhan pengguna sudah tervalidasi.

---

## 17. Indikator Keberhasilan Produk

Indikator berikut dapat digunakan untuk evaluasi manual atau pengujian portofolio. MVP tidak perlu mengirim data analitik ke pihak ketiga.

| Indikator | Target evaluasi |
|---|---|
| Penyelesaian onboarding | Pengguna uji berhasil menambahkan motor pertama tanpa bantuan |
| Pencatatan servis | Pengguna uji berhasil membuat catatan servis beserta beberapa item |
| Akurasi perhitungan | Semua unit test perhitungan jadwal lulus |
| Persistensi lokal | Data tetap ada setelah aplikasi ditutup dan dibuka kembali |
| Operasi offline | Semua fitur P0 berhasil diuji tanpa internet |
| Pengingat | Notifikasi tanggal dan evaluasi kilometer berjalan sesuai skenario uji |
| Konsistensi laporan | Total biaya sesuai dengan penjumlahan catatan servis |
| Kemudahan penggunaan | Pengguna uji dapat menemukan fungsi utama tanpa instruksi panjang |

---

## 18. Asumsi dan Keputusan yang Perlu Dipertahankan

1. ServisKu adalah aplikasi untuk pemilik motor pribadi, bukan untuk bengkel.
2. Pengguna dapat menyimpan lebih dari satu motor dalam satu instalasi aplikasi.
3. MVP tidak memiliki login, akun, backend, atau sinkronisasi cloud.
4. Data utama disimpan secara lokal.
5. Pengguna memasukkan kilometer secara manual.
6. Notifikasi adalah notifikasi lokal pada perangkat.
7. Pengguna bertanggung jawab menyesuaikan interval servis dengan buku manual kendaraan atau arahan mekanik.
8. Template perawatan hanya membantu memulai pencatatan dan bukan rekomendasi teknis universal.
9. Android menjadi target implementasi dan pengujian pertama.
10. Backup dan restore, dark mode, pencarian lanjutan, serta PDF termasuk pengembangan P1 atau P2, bukan syarat untuk menyelesaikan alur inti MVP.

---

## 19. Glosarium

| Istilah | Definisi |
|---|---|
| Odometer | Penunjuk jarak tempuh kendaraan yang ditampilkan dalam kilometer |
| Jadwal perawatan | Rencana perawatan berdasarkan interval waktu, kilometer, atau keduanya |
| Jatuh tempo | Batas waktu atau kilometer ketika perawatan perlu dilakukan |
| Segera | Status ketika kendaraan memasuki rentang pengingat sebelum jatuh tempo |
| Terlambat | Status ketika batas waktu atau kilometer telah tercapai atau terlewati |
| Kunjungan servis | Satu kejadian kendaraan dibawa untuk pemeriksaan atau perawatan |
| Item pekerjaan | Tindakan atau komponen yang dikerjakan dalam satu kunjungan servis |
| Offline-first | Pendekatan yang membuat fitur utama tetap bekerja tanpa koneksi internet |
| Notifikasi lokal | Notifikasi yang dijadwalkan dan ditampilkan oleh perangkat tanpa server push |

---

## 20. Penutup

ServisKu MVP berfokus pada empat kebutuhan inti pemilik motor: mengelola kendaraan, mencatat kilometer, mengingat jadwal perawatan, dan menyimpan riwayat servis beserta biayanya. Dengan pendekatan offline-first, ruang lingkup aplikasi tetap realistis untuk dikembangkan menggunakan Flutter sebagai proyek portofolio individual.

Keberhasilan MVP tidak diukur dari banyaknya fitur, tetapi dari konsistensi data, ketepatan perhitungan jadwal, keandalan penyimpanan lokal, dan kemudahan pengguna menyelesaikan aktivitas utama.

Dokumen ini menjadi baseline produk untuk penyusunan **Functional Specification Document (FSD)**, desain UI/UX, perancangan database teknis, dan implementasi aplikasi.
