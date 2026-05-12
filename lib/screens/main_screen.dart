import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'category_screen.dart';
import 'statistics_screen.dart';
import 'profile_screen.dart';
import '../models/book.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../main.dart';
import '../services/notification_service.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});
  
  @override
 State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
   int selectedIndex = 0;

  List<String> categories = [];
  final List<Book> books = [];

  final List<String> defaultCategories = [
    "Novel",
    "Pengembangan Diri",
    "Sejarah",
    "Bisnis",
  ];
  @override
  void initState() {
    super.initState();
    NotificationService().init();
    initializeApp();
    notificationsNotifier.addListener(_onNotificationToggle);
  }

  @override
  void dispose() {
    notificationsNotifier.removeListener(_onNotificationToggle);
    super.dispose();
  }

  void _onNotificationToggle() {
    NotificationService().updateNotificationCount(books);
    if (notificationsNotifier.value) {
      NotificationService().scheduleDailyReminder();
    }
  }

  Future<void> initializeApp() async {
    await loadBooks();
    await loadCategories();
    NotificationService().updateNotificationCount(books);
  }

  Future<void> loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("books");
    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        books.clear();
        books.addAll(decoded.map((item) => Book(
              title: item["title"],
              author: item["author"],
              rating: item["rating"].toDouble(),
              progress: item["progress"],
              status: item["status"],
              image: item["image"],
              category: item["category"] ?? "Lainnya",
              year: item["year"] ?? 0,
              pages: item["pages"] ?? 0,
              language: item["language"] ?? "Indonesia",
              description: item["description"] ?? "",
              isFavorite: item["isFavorite"] ?? false,
            )));
      });
    }
  }

  Future<void> saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookList = books
        .map(
          (book) => {
            "title": book.title,
            "author": book.author,
            "rating": book.rating,
            "progress": book.progress,
            "status": book.status,
            "image": book.image,
            "category": book.category,
            "year": book.year,
            "pages": book.pages,
            "language": book.language,
            "description": book.description,
            "isFavorite": book.isFavorite,
          },
        )
        .toList();
    await prefs.setString("books", jsonEncode(bookList));
  }

  Future<void> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedCategories = prefs.getStringList("categories") ?? [];
    
    // Ambil kategori dari buku
    final List<String> bookCategories = books.map((b) => b.category).toList();
    
    // Gabungkan semua
    final allCategories = {
      ...defaultCategories,
      ...savedCategories,
      ...bookCategories
    }.where((c) => c.isNotEmpty).toList();

    setState(() {
      categories = allCategories;
    });
  }

  Future<void> saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("categories", categories);
  }

  void onBooksUpdated() {
    loadCategories();
  }

 void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


@override

 Widget build(BuildContext context) {

  final screens = [
    HomeScreen(
      books: books, 
      categories: categories,
      onTabChange: onItemTapped,
      onBooksUpdated: onBooksUpdated,
    ),
    CategoryScreen(
        categories: categories,
        books: books,
        onAddCategory: (newCategory) {
          if (newCategory.isNotEmpty && !categories.contains(newCategory)) {
            setState(() {
              categories.add(newCategory);
            });
            saveCategories();
          }
        },
        onDeleteCategory: (categoryToDelete) {
          setState(() {
            // Hapus dari daftar kategori
            categories.remove(categoryToDelete);
            
            // Hapus semua buku yang memakai kategori ini
            books.removeWhere((book) => book.category == categoryToDelete);
          });
          saveCategories();
          saveBooks();
          NotificationService().updateNotificationCount(books);
        },
      ),
    StatisticsScreen(books: books),
    ProfileScreen(books: books),
  ];

    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          body: screens[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
            backgroundColor: Theme.of(context).colorScheme.surface,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: Localization.text('home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.grid_view),
                label: Localization.text('kategori'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart),
                label: Localization.text('statistik'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: Localization.text('profile'),
              ),
            ],
          ),
        );
      },
    );

}
}