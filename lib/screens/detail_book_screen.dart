import 'package:flutter/material.dart';
import '../models/book.dart';
import 'add_book_screen.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class DetailBookScreen extends StatefulWidget {
  final Book book;
  final int index;
  final List<String> categories;

  const DetailBookScreen({
    super.key,
    required this.book,
    required this.index,
    required this.categories,
  });

  @override
  State<DetailBookScreen> createState() => _DetailBookScreenState();
}

class _DetailBookScreenState extends State<DetailBookScreen> {
  late Book currentBook;
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    currentBook = widget.book;
    isFavorite = widget.book.isFavorite;
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6A5AE0), size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
              onPressed: () => Navigator.pop(context, {
                "index": widget.index,
                "updatedBook": {
                  "title": currentBook.title,
                  "author": currentBook.author,
                  "rating": currentBook.rating,
                  "progress": currentBook.progress,
                  "status": currentBook.status,
                  "category": currentBook.category,
                  "year": currentBook.year,
                  "pages": currentBook.pages,
                  "language": currentBook.language,
                  "description": currentBook.description,
                  "image": currentBook.image,
                  "isFavorite": isFavorite,
                }
              }),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share_outlined, color: colorScheme.onSurface),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Cover & Basic Info Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cover Image
                    Container(
                      width: 130,
                      height: 190,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: currentBook.image.isNotEmpty
                            ? (currentBook.image.startsWith("http")
                                ? Image.network(currentBook.image, fit: BoxFit.cover)
                                : Image.file(File(currentBook.image), fit: BoxFit.cover))
                            : Container(
                                color: colorScheme.surfaceVariant,
                                child: Icon(Icons.image, color: colorScheme.onSurfaceVariant),
                              ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Info Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Favorite Button (Purple Box)
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () => setState(() => isFavorite = !isFavorite),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6A5AE0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  isFavorite ? Icons.star : Icons.star_border,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            currentBook.title,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currentBook.author,
                            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                "${currentBook.rating} (2.318)", // Matches dummy text in image
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_outline, color: Colors.green, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  currentBook.status,
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Progress Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Localization.text('progress_membaca'),
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    Text(
                      "${currentBook.progress}%",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: currentBook.progress / 100,
                    minHeight: 8,
                    backgroundColor: colorScheme.surfaceVariant,
                    color: const Color(0xFF6A5AE0),
                  ),
                ),
                const SizedBox(height: 24),

                // Detail Info Section
                _buildDetailItem(Icons.grid_view_outlined, Localization.text('kategori'), currentBook.category),
                _buildDetailItem(Icons.calendar_today_outlined, Localization.text('tahun_terbit'), currentBook.year.toString()),
                _buildDetailItem(Icons.auto_stories_outlined, Localization.text('jumlah_halaman'), "${currentBook.pages} Halaman"),
                _buildDetailItem(Icons.language_outlined, Localization.text('bahasa'), currentBook.language),

                const SizedBox(height: 24),

                // Description
                Text(
                  Localization.text('deskripsi'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  currentBook.description,
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14, height: 1.5),
                ),

                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddBookScreen(
                                categories: widget.categories,
                                index: widget.index,
                                book: {
                                  "title": currentBook.title,
                                  "author": currentBook.author,
                                  "category": currentBook.category,
                                  "rating": currentBook.rating,
                                  "progress": currentBook.progress,
                                  "status": currentBook.status,
                                  "year": currentBook.year,
                                  "pages": currentBook.pages,
                                  "language": currentBook.language,
                                  "description": currentBook.description,
                                  "image": currentBook.image,
                                  "isFavorite": isFavorite,
                                  "dateAdded": currentBook.dateAdded?.toIso8601String(),
                                  "dateCompleted": currentBook.dateCompleted?.toIso8601String(),
                                },
                              ),
                            ),
                          );

                          if (result == true) {
                            // Cek result == true, refresh data menggunakan setState
                            final prefs = await SharedPreferences.getInstance();
                            final booksString = prefs.getString('books');
                            if (booksString != null) {
                              List<dynamic> jsonList = jsonDecode(booksString);
                              final updatedMap = jsonList[widget.index];
                              setState(() {
                                currentBook = currentBook.copyWith(
                                  title: updatedMap["title"],
                                  author: updatedMap["author"],
                                  rating: updatedMap["rating"]?.toDouble() ?? 0.0,
                                  progress: updatedMap["progress"],
                                  status: updatedMap["status"],
                                  category: updatedMap["category"],
                                  year: updatedMap["year"],
                                  pages: updatedMap["pages"],
                                  language: updatedMap["language"],
                                  description: updatedMap["description"],
                                  image: updatedMap["image"] ?? "",
                                );
                              });
                            }
                          }
                        },
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: Text(Localization.text('edit')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF0EFFF),
                          foregroundColor: const Color(0xFF6A5AE0),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(Localization.text('hapus')),
                              content: const Text("Apakah Anda yakin ingin menghapus buku ini?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(Localization.text('batal')),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // close dialog
                                    Navigator.pop(context, {
                                      "delete": true,
                                      "index": widget.index,
                                    });
                                  },
                                  child: Text(Localization.text('hapus'), style: const TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: Text(Localization.text('hapus')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFEBEE),
                          foregroundColor: Colors.red,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
