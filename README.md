# Blueprint Aplikasi Smart Library


## 1. Gambaran Umum Aplikasi

### Nama Aplikasi

Smart Library

### Deskripsi

Aplikasi mobile untuk mengelola koleksi buku pribadi dengan fitur:

* Menambah buku
* Edit buku
* Hapus buku
* Statistik membaca
* Kategori buku dinamis
* Upload cover buku
* Progress membaca
* Rating buku

### Tujuan

Membantu pengguna mencatat dan memonitor aktivitas membaca secara praktis dan modern.

---

# 2. Teknologi yang Digunakan

| Teknologi         | Fungsi                       |
| ----------------- | ---------------------------- |
| Flutter           | Framework utama aplikasi     |
| Dart              | Bahasa pemrograman           |
| SharedPreferences | Penyimpanan data lokal       |
| Image Picker      | Mengambil gambar dari galeri |

---

# 3. Struktur Fitur Utama

## A. Home Screen

### Fungsi

Halaman utama aplikasi.

### Isi

* Header aplikasi
* Search bar
* Filter status buku
* List buku
* Statistik singkat
* Floating button tambah buku

### Fitur

✅ Cari buku
✅ Filter status
✅ Edit buku
✅ Hapus buku
✅ Navigasi detail buku
✅ Statistik cepat

---

## B. Add Book Screen

### Fungsi

Menambah dan mengedit buku.

### Input Data

| Field          | Tipe            |
| -------------- | --------------- |
| Judul Buku     | Text            |
| Penulis        | Text            |
| Kategori       | Dropdown        |
| Tahun Terbit   | Number          |
| Jumlah Halaman | Number          |
| Bahasa         | Text            |
| Progress       | Slider          |
| Rating         | Star Rating     |
| Deskripsi      | Multi-line Text |
| Cover Buku     | Image Picker    |

### Fitur

✅ Upload gambar
✅ Edit data
✅ Validasi input
✅ Simpan buku

---

## C. Detail Book Screen

### Fungsi

Menampilkan detail lengkap buku.

### Informasi yang Ditampilkan

* Cover buku
* Judul
* Penulis
* Rating
* Status membaca
* Progress membaca
* Kategori
* Tahun terbit
* Jumlah halaman
* Bahasa
* Deskripsi

### Fitur

✅ Edit buku
✅ Hapus buku
✅ Progress indicator

---

## D. Category Screen

### Fungsi

Mengelola kategori buku.

### Fitur

✅ Menampilkan semua kategori
✅ Menampilkan jumlah buku per kategori
✅ Menambah kategori baru
✅ Sinkron dengan Home & Add Book

### Sistem

Kategori disimpan terpusat di:

```dart
MainScreen
```

---

## E. Statistics Screen

### Fungsi

Menampilkan statistik membaca.

### Statistik

* Total buku
* Buku selesai
* Sedang dibaca
* Buku baru

### Kemungkinan Pengembangan

✅ Grafik membaca
✅ Statistik bulanan
✅ Persentase progress

---

# 4. Struktur Navigasi

```text
MainScreen
│
├── HomeScreen
│   ├── DetailBookScreen
│   │   └── AddBookScreen
│   └── AddBookScreen
│
├── CategoryScreen
│
├── StatisticsScreen
│
└── ProfileScreen
```

---

# 5. Struktur Data

## Model Book

```dart
class Book {
  String title;
  String author;
  double rating;
  int progress;
  String status;
  String category;
  String image;
  int year;
  int pages;
  String language;
  String description;
}
```

---

# 6. State Management

### Saat Ini

Menggunakan:

```dart
setState()
```

### Alur Data

```text
MainScreen
   ↓
HomeScreen
   ↓
DetailBookScreen
   ↓
AddBookScreen
```

### Shared Data

* books
* categories

Dikirim menggunakan constructor antar screen.

---

# 7. Penyimpanan Data

## Sistem Storage

Menggunakan:

```dart
SharedPreferences
```

## Data yang Disimpan

### Books

```json
[
  {
    "title": "Atomic Habits",
    "author": "James Clear"
  }
]
```

### Categories

```json
[
  "Novel",
  "Bisnis"
]
```

---

# 8. UI / Design System

## Warna Utama

| Warna       | Kode    |
| ----------- | ------- |
| Deep Purple | #6A5AE0 |
| Background  | #F8F9FD |
| White       | #FFFFFF |

---

## Komponen UI

### Digunakan

✅ Card Design
✅ Rounded Corner
✅ Gradient
✅ Choice Chip
✅ Floating Action Button
✅ Progress Indicator
✅ Slider
✅ Dialog

---

# 9. Arsitektur Folder

```text
lib/
│
├── models/
│   └── book.dart
│
├── screens/
│   ├── main_screen.dart
│   ├── home_screen.dart
│   ├── add_book_screen.dart
│   ├── detail_book_screen.dart
│   ├── category_screen.dart
│   └── statistics_screen.dart
│
├── widgets/
│   └── book_card.dart
│
└── main.dart
```

---

# 10. Alur Kerja Aplikasi

## Tambah Buku

```text
User klik +
↓
Input data buku
↓
Simpan
↓
Masuk ke list Home
↓
Data tersimpan di SharedPreferences
```

---

## Edit Buku

```text
Klik buku
↓
Detail buku
↓
Edit
↓
Update data
↓
List otomatis berubah
```

---

## Tambah Kategori

```text
Masuk Category
↓
Klik +
↓
Tambah kategori
↓
Kategori muncul di AddBook
↓
Sinkron ke seluruh aplikasi
```

---

# 11. Dependency yang Digunakan

Di `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter

  shared_preferences: ^2.2.2
  image_picker: ^1.0.7
```

---

# 12. Fitur yang Sudah Selesai

✅ CRUD Buku
✅ Upload Gambar
✅ Statistik
✅ Filter Buku
✅ Search Buku
✅ Dynamic Category
✅ SharedPreferences
✅ Edit Buku
✅ Delete Buku
✅ Detail Buku

---

# 13. Pengembangan Selanjutnya

## Fitur Future

### User

* Login/Register
* Cloud sync

### Buku

* Favorite
* Bookmark
* PDF reader
* Notes & highlight

### Statistik

* Grafik mingguan
* Target membaca

### UI

* Dark mode
* Animasi
* Custom theme

### Database

* SQLite
* Firebase




