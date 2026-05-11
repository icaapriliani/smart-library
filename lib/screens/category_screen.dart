import 'package:flutter/material.dart';
import '../models/book.dart';

class CategoryScreen extends StatefulWidget {
   final List<String> categories;
   final List<Book> books;
  final Function(String) onAddCategory;
  const CategoryScreen({super.key, required this.books, required this.categories,
    required this.onAddCategory,});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

 
  void addCategory() {

    final controller = TextEditingController();

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(

          title: const Text("Tambah Kategori"),

          content: TextField(
            controller: controller,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: "Masukkan kategori",
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),

            ElevatedButton(
              onPressed: () {

                if (controller.text.isNotEmpty) {
                    widget.onAddCategory(controller.text);

                  Navigator.pop(context);
                }
              },
              child: const Text("Tambah"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        title: const Text("Kategori Buku"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,

        actions: [

          IconButton(
            onPressed: addCategory,
            icon: const Icon(Icons.add),
          ),

        ],
      ),

      body: ListView.builder(

        padding: const EdgeInsets.all(16),

        itemCount: widget.categories.length,

      itemBuilder: (context, index) {
  final category =widget.categories[index];

  final totalBooks = widget.books
      .where((book) => book.category == category)
      .length;

  return CategoryTile(
    title: category,
    count: totalBooks,
    icon: Icons.menu_book,
    color: Colors.deepPurple,
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [

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

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "$count Buku",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}