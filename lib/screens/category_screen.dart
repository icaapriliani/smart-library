import 'package:flutter/material.dart';
import '../models/book.dart';
import '../main.dart';

class CategoryScreen extends StatefulWidget {
  final List<String> categories;
  final List<Book> books;
  final Function(String) onAddCategory;
  final Function(String) onDeleteCategory;

  const CategoryScreen({
    super.key,
    required this.books,
    required this.categories,
    required this.onAddCategory,
    required this.onDeleteCategory,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<String> defaultCategories = [
    "Novel",
    "Pengembangan Diri",
    "Sejarah",
    "Bisnis",
  ];

  void addCategory() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Localization.text('tambah_buku')),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: Localization.text('kategori'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(Localization.text('batal')),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  widget.onAddCategory(controller.text);
                  Navigator.pop(context);
                }
              },
              child: Text(Localization.text('simpan')),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(String category) {
    if (defaultCategories.contains(category)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localization.text('hapus_kategori_bawaan_msg')),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final hasBooks = widget.books.any((book) => book.category == category);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Localization.text('hapus')),
        content: Text(
          hasBooks
              ? Localization.text('peringatan_hapus_kategori')
              : Localization.text('konfirmasi_hapus_kategori'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Localization.text('batal')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              widget.onDeleteCategory(category);
              Navigator.pop(context);
            },
            child: Text(
              hasBooks ? Localization.text('hapus_semua') : Localization.text('hapus'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: Text(Localization.text('kategori')),
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
              final category = widget.categories[index];
              final totalBooks = widget.books.where((book) => book.category == category).length;

              return CategoryTile(
                title: category,
                count: totalBooks,
                icon: Icons.menu_book,
                color: Colors.deepPurple,
                onDelete: () => _confirmDelete(category),
                isDefault: defaultCategories.contains(category),
              );
            },
          ),
        );
      },
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onDelete;
  final bool isDefault;

  const CategoryTile({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onDelete,
    required this.isDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
          IconButton(
            icon: Icon(
              isDefault ? Icons.lock_outline : Icons.delete_outline,
              color: isDefault
                  ? Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4)
                  : Theme.of(context).colorScheme.error.withOpacity(0.7),
              size: 22,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}