BLUEPRINT APLIKASI
SMART LIBRARY
Identitas Proyek

Keterangan	Isi
Nama Aplikasi	Smart Library
Platform	Mobile Application
Framework	Flutter
Bahasa Pemrograman	Dart
Penyimpanan Data	SharedPreferences
Target Pengguna	Pelajar, Mahasiswa, dan Pembaca Buku
Jenis Aplikasi	Manajemen dan Monitoring Buku

1. Deskripsi Aplikasi
Smart Library merupakan aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengguna dalam mengelola koleksi buku, memantau progres membaca, serta menyimpan data bacaan secara praktis dan modern.
Aplikasi ini memiliki fitur autentikasi sederhana menggunakan SharedPreferences, pengelolaan data buku, statistik membaca, notifikasi pengingat membaca, serta tampilan antarmuka modern yang nyaman digunakan.
Aplikasi Smart Library dibuat untuk memberikan pengalaman membaca yang lebih terorganisir sehingga pengguna dapat mencatat buku yang sedang dibaca, selesai dibaca, maupun buku yang ingin dibaca.
2. Tujuan Pengembangan Aplikasi
Tujuan dari pengembangan aplikasi Smart Library adalah:
1.	Membantu pengguna mengelola koleksi buku secara digital.
2.	Mempermudah pengguna dalam memantau progres membaca.
3.	Memberikan pengingat membaca melalui notifikasi.
4.	Menyediakan tampilan aplikasi yang modern dan user friendly.
5.	Meningkatkan minat membaca melalui monitoring aktivitas membaca.
3. Target Pengguna
Target pengguna aplikasi Smart Library yaitu:
•	Mahasiswa
•	Pelajar
•	Pengguna umum
•	Pecinta buku
•	Pengguna yang ingin mengelola aktivitas membaca
4. Konsep Tampilan Aplikasi
Konsep desain aplikasi Smart Library menggunakan:
•	Modern UI
•	Minimalis
•	Clean Design
•	Warna lembut dan nyaman
•	Navigasi sederhana
•	Responsive layout
Dominasi warna:
•	Biru
•	Putih
•	Abu-abu
5. Struktur Navigasi
Alur Navigasi Aplikasi
[ SPLASH SCREEN ]
↓
[ ONBOARDING ]
↓
[ LOGIN / REGISTER ]
↓
[ HOME SCREEN ]
├── Detail Buku
├── Tambah Buku
├── Edit Buku
├── Statistik
├── Notifikasi
└── Profile
6. Fitur Utama Aplikasi
6.1 Splash Screen
Fungsi:
•	Menampilkan logo aplikasi.
•	Mengecek status login pengguna.
•	Mengarahkan pengguna ke halaman berikutnya.

 
6.2 Onboarding Screen
Fungsi:
•	Menampilkan pengenalan aplikasi.
•	Memberikan informasi fitur utama aplikasi




6.3 Register
Fungsi:
•	Membuat akun pengguna.
•	Menyimpan username, email, dan password menggunakan SharedPreferences.
Validasi:
•	Username wajib diisi.
•	Email harus valid.
•	Password minimal 6 karakter.
•	Konfirmasi password harus sama.
 
6.4 Login
Fungsi:
•	Login menggunakan akun yang sudah didaftarkan.
•	Validasi email dan password.
 
6.5 Home Screen
Fungsi:
•	Menampilkan daftar buku.
•	Menampilkan sapaan nama pengguna.
•	Menampilkan statistik singkat.
•	Navigasi utama aplikasi.
Fitur:
•	Search buku
•	Filter kategori
•	Progress membaca
•	Statistik singkat

6.6 Tambah Buku
Fungsi:
•	Menambahkan data buku baru.
Data yang diinput:
•	Judul buku
•	Penulis
•	Kategori
•	Deskripsi
•	Progress membaca
•	Gambar buku
6.7 Detail Buku
Fungsi:
•	Menampilkan informasi detail buku.
•	Menampilkan progres membaca.
•	Menampilkan deskripsi buku.
6.8 Edit Buku
Fungsi:
•	Mengubah data buku.
•	Menyimpan perubahan buku.
•	Sinkronisasi perubahan dengan HomeScreen.
6.9 Statistik Membaca
Fungsi:
•	Menampilkan grafik progres membaca.
•	Menampilkan jumlah buku.
•	Menampilkan statistik kategori.
Library:
•	fl_chart
6.10 Profile Screen
Fungsi:
•	Menampilkan data pengguna.
•	Edit profile.
•	Logout.
•	Hapus akun.
Fitur:
•	Sinkronisasi nama profile dengan HomeScreen.
•	Logout akun.
•	Delete account.
7. Teknologi yang Digunakan
Teknologi	Fungsi
Flutter	Framework aplikasi
Dart	Bahasa pemrograman
SharedPreferences	Penyimpanan data lokal
fl_chart	Menampilkan grafik statistik
image_picker	Mengambil gambar buku
flutter_local_notifications	Notifikasi pengingat
path_provider	Penyimpanan file lokal

8. Penyimpanan Data
Aplikasi Smart Library menggunakan SharedPreferences sebagai media penyimpanan data lokal.
Data yang disimpan:
•	Username
•	Email
•	Password
•	Status login
•	Data buku
•	Progress membaca
9. Keunggulan Aplikasi
Keunggulan aplikasi Smart Library:
1.	Tampilan modern dan sederhana.
2.	Ringan digunakan.
3.	Sistem login sederhana.
4.	Mendukung monitoring progres membaca.
5.	Dilengkapi grafik statistik.
6.	Mendukung upload gambar buku.
7.	Data tersimpan secara lokal.
8.	Terdapat fitur logout dan hapus akun.
10. Kekurangan Aplikasi
Kekurangan aplikasi Smart Library:
1.	Data belum tersimpan secara online.
2.	Akun akan hilang jika aplikasi dihapus.
3.	Belum mendukung sinkronisasi cloud.
4.	Belum mendukung multi-device.
11. Rencana Pengembangan
Pengembangan selanjutnya:
•	Integrasi Firebase
•	Sinkronisasi cloud
•	Dark mode
•	Multi bahasa
•	Backup data online
•	Sistem rekomendasi buku
•	Fitur komunitas membaca
12. Kesimpulan
Smart Library merupakan aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengguna dalam mengelola aktivitas membaca secara digital.
Dengan fitur login, manajemen buku, statistik membaca, notifikasi, serta tampilan modern, aplikasi ini mampu memberikan pengalaman membaca yang lebih terstruktur dan praktis.
Aplikasi ini diharapkan dapat membantu meningkatkan produktivitas dan minat membaca pengguna melalui monitoring progres membaca secara efektif.
Lampiran Gambar
 
