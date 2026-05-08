
import 'package:flutter/material.dart';
import '../models/book.dart';

class CategoryScreen extends StatelessWidget {
final List<Book> books;

  const CategoryScreen({
    super.key,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {

    final Map<String, int> categoryCount = {};

    for (var book in books) {
      categoryCount[book.category] =
          (categoryCount[book.category] ?? 0) + 1;
    }

  final categories=[
    {
     "title":"Novel", 
     "count":12,
     "icon": Icons.menu_book,
     "color":Colors.deepPurple,
    },
    {
      "title": "Pengembangan Diri",
      "count": 8,
      "icon": Icons.psychology,
      "color": Colors.green,
    },
    {
      "title": "Sejarah",
      "count": 8,
      "icon": Icons.psychology,
      "color": Colors.orange,
    },
    {
      "title": "Biografi",
      "count": 8,
      "icon": Icons.psychology,
      "color": Colors.blue,
    },
    {
      "title": "Bisnis",
      "count": 8,
      "icon": Icons.psychology,
      "color": Colors.red,
    },
  ];

  
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),

      appBar:AppBar(
         title: const Text("Kategori Buku"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category=categories[index];
          final title = category["title"] as String;

          final count = categoryCount[title] ?? 0;

          return CategoryTile(
            title: title,
            count: count,
            icon: category["icon"] as IconData,
            color: category["color"] as Color,
          );
        },
      ),
      
    );

  }
}

class CategoryTile extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const CategoryTile({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          //icon
          Container(
            padding: const EdgeInsets.all(12),

             decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 14),
          

          //text
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15,),),

              const SizedBox(height: 4),
              Text(
                  "$count Buku",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          //arrow
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
            ],
          ),
          );
          
        
  }
}