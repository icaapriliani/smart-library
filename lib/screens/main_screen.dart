import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'category_screen.dart';
import 'statistics_screen.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});
  
  @override
 State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  int selectedIndex=0;
  final List<Widget>screens=[
    HomeScreen(),
    CategoryScreen(),
     StatisticsScreen(
      books: [],
     ),
     const Center(child: Text("Profile Screen"),),
  ];
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
@override
  Widget build(BuildContext context) {
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