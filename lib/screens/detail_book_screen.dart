import 'package:flutter/material.dart';
import '../models/book.dart';

class DetailBookScreen extends StatelessWidget {
  final Book book;

  const DetailBookScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Buku")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                book.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            //judul
            Text(
              "by ${book.author}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            //progres
            Text("Progress: ${book.progress}%"),
            const SizedBox(height: 8),

            LinearProgressIndicator(value: book.progress / 100),
            const SizedBox(height: 16),

            //status
            Chip(label: Text(book.status)),
          ],
        ),
      ),
    );
  }
}
