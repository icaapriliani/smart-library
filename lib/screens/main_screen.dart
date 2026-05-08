import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'category_screen.dart';
import 'statistics_screen.dart';
import '../models/book.dart';
class MainScreen extends StatefulWidget{
  const MainScreen({super.key});
  
  @override
 State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
   int selectedIndex = 0;

  final List<Book> books = [
  Book(
    title: "Atomic Habits",
    author: "James Clear",
    rating: 4.8,
    progress: 70,
    status: "Reading",
    category: "Pengembangan Diri",
    image: "https://picsum.photos/200/300",
    year: 2020,
    pages: 320,
    language: "English",
    description: "Buku pengembangan diri",
  ),
];


 void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


@override

 Widget build(BuildContext context) {

  final screens = [
    HomeScreen(books: books, onTabChange: onItemTapped,),
    CategoryScreen(books: books),
    StatisticsScreen(books: books),
    const Center(
      child: Text("Profile Screen"),
    ),
  ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "Kategori",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Statistik",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),

        ],
      ),
    
    );

}
}