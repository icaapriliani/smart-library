import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_screen.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<String> userNameNotifier = ValueNotifier("Ica");
final ValueNotifier<String> userImageNotifier = ValueNotifier("https://picsum.photos/200/300");
final ValueNotifier<String> languageNotifier = ValueNotifier("Indonesia");
final ValueNotifier<bool> notificationsNotifier = ValueNotifier(true);
final ValueNotifier<int> notificationCountNotifier = ValueNotifier(0);


class Localization {
  static final Map<String, Map<String, String>> _values = {
    'Indonesia': {
      'home': 'Home',
      'kategori': 'Kategori',
      'statistik': 'Statistik',
      'profile': 'Profil',
      'tambah_buku': 'Tambah Buku',
      'edit_buku': 'Edit Buku',
      'penulis': 'Penulis',
      'progress': 'Progres',
      'deskripsi': 'Deskripsi',
      'bahasa': 'Bahasa',
      'notifikasi': 'Notifikasi',
      'tentang': 'Tentang Aplikasi',
      'kebijakan': 'Kebijakan Privasi',
      'bantuan': 'Bantuan',
      'simpan': 'Simpan',
      'hapus': 'Hapus',
      'cari': 'Cari buku...',
      'statistik_membaca': 'Statistik Membaca',
      'total_buku': 'Total Buku',
      'selesai': 'Selesai',
      'membaca': 'Membaca',
      'baru': 'Baru',
      'semua': 'Semua',
      'ringkasan': 'Ringkasan',
      'target': 'Target Bacaan',
      'favorit': 'Kategori Favorit',
      'pengaturan': 'Pengaturan',
      'batal': 'Batal',
      'tahun': 'Tahun Terbit',
      'halaman': 'Jumlah Halaman',
      'pilih_kategori': 'Pilih Kategori',
      'judul_buku': 'Judul Buku',
      'tahun_terbit': 'Tahun Terbit',
      'jumlah_halaman': 'Jumlah Halaman',
      'by': 'oleh',
      'buku_favorit': 'Buku Favorit',
      'notif_welcome': 'Jangan lupa lanjut membaca hari ini 📚',
      'notif_title': 'Reminder Membaca',
      'notif_body': 'Waktunya lanjut membaca buku favoritmu!',
      'no_notif': 'Belum ada notifikasi',
      'mark_read': 'Tandai semua dibaca',
      'notif_center': 'Pusat Notifikasi',
      'just_now': 'Baru saja',
      'hour_ago': '1 jam lalu',
      'today': 'Hari ini',
      'reading_progress': 'Lanjutkan membaca',
      'unfinished_msg': 'buku belum selesai',
      'target_msg': 'Target membaca belum tercapai',
      'fav_msg': 'Buku favoritmu belum dibaca hari ini',
      'konfirmasi_hapus_kategori': 'Yakin ingin menghapus kategori ini?',
      'hapus_kategori_bawaan_msg': 'Kategori bawaan aplikasi tidak dapat dihapus',
      'peringatan_hapus_kategori': 'Kategori ini masih digunakan oleh beberapa buku. Jika kategori dihapus, semua buku dalam kategori ini juga akan ikut terhapus.',
      'hapus_semua': 'Hapus Semua',
      'progress_membaca': 'Progress Membaca',
      'detail': 'Detail Informasi',
      'edit': 'Edit',
    },
    'English': {
      'home': 'Home',
      'kategori': 'Category',
      'statistik': 'Statistics',
      'profile': 'Profile',
      'tambah_buku': 'Add Book',
      'edit_buku': 'Edit Book',
      'penulis': 'Author',
      'progress': 'Progress',
      'deskripsi': 'Description',
      'bahasa': 'Language',
      'notifikasi': 'Notifications',
      'tentang': 'About App',
      'kebijakan': 'Privacy Policy',
      'bantuan': 'Help',
      'simpan': 'Save',
      'hapus': 'Delete',
      'cari': 'Search books...',
      'statistik_membaca': 'Reading Statistics',
      'total_buku': 'Total Books',
      'selesai': 'Done',
      'membaca': 'Reading',
      'baru': 'New',
      'semua': 'All',
      'ringkasan': 'Summary',
      'target': 'Reading Target',
      'favorit': 'Favorite',
      'pengaturan': 'Settings',
      'batal': 'Cancel',
      'tahun': 'Release Year',
      'halaman': 'Pages',
      'pilih_kategori': 'Select Category',
      'judul_buku': 'Book Title',
      'tahun_terbit': 'Release Year',
      'jumlah_halaman': 'Total Pages',
      'by': 'by',
      'buku_favorit': 'Favorite Books',
      'notif_welcome': 'Don\'t forget to continue reading today 📚',
      'notif_title': 'Reading Reminder',
      'notif_body': 'Time to continue reading your favorite book!',
      'no_notif': 'No notifications yet',
      'mark_read': 'Mark all as read',
      'notif_center': 'Notification Center',
      'just_now': 'Just now',
      'hour_ago': '1 hour ago',
      'today': 'Today',
      'reading_progress': 'Continue reading',
      'unfinished_msg': 'unfinished books',
      'target_msg': 'Reading target not reached',
      'fav_msg': 'Your favorite book hasn\'t been read today',
      'konfirmasi_hapus_kategori': 'Are you sure you want to delete this category?',
      'hapus_kategori_bawaan_msg': 'App default category cannot be deleted',
      'peringatan_hapus_kategori': 'This category is still used by several books. If the category is deleted, all books in this category will also be deleted.',
      'hapus_semua': 'Delete All',
      'progress_membaca': 'Reading Progress',
      'detail': 'Detailed Information',
      'edit': 'Edit',
    },
  };

  static String text(String key) {
    return _values[languageNotifier.value]?[key] ?? key;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  bool isDark = prefs.getBool('isDark') ?? false;
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  
  userNameNotifier.value = prefs.getString('userName') ?? "Ica";
  userImageNotifier.value = prefs.getString('userImage') ?? "https://picsum.photos/200/300";
  languageNotifier.value = prefs.getString('selectedLanguage') ?? "Indonesia";
  notificationsNotifier.value = prefs.getBool('notificationsEnabled') ?? true;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'smart library',
          themeMode: currentMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
              surface: const Color(0xFFF8F9FD),
            ),
            scaffoldBackgroundColor: const Color(0xFFF8F9FD),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black87),
              titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: const Color(0xFFF8F9FD),
              surfaceTintColor: Colors.transparent,
              titleTextStyle: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
              contentTextStyle: const TextStyle(color: Colors.black87),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
              surface: const Color(0xFF1A1C1E),
              onSurface: const Color(0xFFE2E2E6),
              onSurfaceVariant: const Color(0xFFC2C7CF),
            ),
            scaffoldBackgroundColor: const Color(0xFF111315),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Color(0xFFE2E2E6)),
              titleTextStyle: TextStyle(color: Color(0xFFE2E2E6), fontSize: 20, fontWeight: FontWeight.bold),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1A1C1E),
              surfaceTintColor: Colors.transparent,
              titleTextStyle: TextStyle(color: Color(0xFFE2E2E6), fontSize: 20, fontWeight: FontWeight.bold),
              contentTextStyle: TextStyle(color: Color(0xFFE2E2E6)),
            ),
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}



