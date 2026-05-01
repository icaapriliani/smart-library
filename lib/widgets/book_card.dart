import 'package:flutter/material.dart';
import '../models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const BookCard({
    super.key,
    required this.book,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              book.image,
              width: 60,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          //info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(book.author, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                //kategori
                Text(
                  book.category,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                //rating
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      size: 16,
                      color: index < book.rating ? Colors.amber : Colors.grey,
                    );
                  }),
                ),

                const SizedBox(height: 6),
                //progress
                LinearProgressIndicator(value: book.progress / 100),

                const SizedBox(height: 4),
                Text("${book.progress}% "),
              ],
            ),
          ),
          //delete dan edit
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
