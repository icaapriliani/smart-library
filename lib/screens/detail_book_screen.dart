import 'package:flutter/material.dart';
import '../models/book.dart';
import 'add_book_screen.dart';
import 'dart:io';
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
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.book.isFavorite;
  }

  Widget buildInfo(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface))),
          Text(
            value,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold),
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
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, {
              "index": widget.index,
              "updatedBook": {
                "title": widget.book.title,
                "author": widget.book.author,
                "rating": widget.book.rating,
                "progress": widget.book.progress,
                "status": widget.book.status,
                "category": widget.book.category,
                "year": widget.book.year,
                "pages": widget.book.pages,
                "language": widget.book.language,
                "description": widget.book.description,
                "image": widget.book.image,
                "isFavorite": isFavorite,
              }
            });
            return false;
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context, {
                    "index": widget.index,
                    "updatedBook": {
                      "title": widget.book.title,
                      "author": widget.book.author,
                      "rating": widget.book.rating,
                      "progress": widget.book.progress,
                      "status": widget.book.status,
                      "category": widget.book.category,
                      "year": widget.book.year,
                      "pages": widget.book.pages,
                      "language": widget.book.language,
                      "description": widget.book.description,
                      "image": widget.book.image,
                      "isFavorite": isFavorite,
                    }
                  });
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Theme.of(context).colorScheme.onBackground,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                ),
                Icon(Icons.share, color: Theme.of(context).colorScheme.onBackground),
                const SizedBox(width: 12),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // top section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // gambar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: (widget.book.image.isNotEmpty)
                            ? (widget.book.image.toString().startsWith("http")
                                ? Image.network(
                                    widget.book.image,
                                    height: 140,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(widget.book.image),
                                    height: 140,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ))
                            : Container(
                                height: 140,
                                width: 100,
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                child: Icon(Icons.image, color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                      ),
                      const SizedBox(width: 16),
                      // info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // judul
                            Text(
                              widget.book.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // author
                            Text(
                              "${Localization.text('by')} ${widget.book.author}",
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text("${widget.book.rating}", style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // status
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.book.status,
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // progres
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Localization.text('progress'), style: TextStyle(color: Theme.of(context).colorScheme.onBackground)),
                      Text("${widget.book.progress}%", style: TextStyle(color: Theme.of(context).colorScheme.onBackground)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: widget.book.progress / 100,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),

                  // detail info
                  buildInfo(Icons.person_outline, Localization.text('penulis'), widget.book.author),
                  buildInfo(Icons.grid_view, Localization.text('kategori'), widget.book.category),
                  buildInfo(Icons.calendar_today_outlined, Localization.text('tahun'), widget.book.year.toString()),
                  buildInfo(Icons.auto_stories_outlined, Localization.text('halaman'), widget.book.pages.toString()),
                  buildInfo(Icons.language_outlined, Localization.text('bahasa'), widget.book.language),

                  const SizedBox(height: 16),

                  // deskripsi
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      Localization.text('deskripsi'),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.book.description,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),

                  const SizedBox(height: 24),

                  // buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddBookScreen(
                                  categories: widget.categories,
                                  book: {
                                    "title": widget.book.title,
                                    "author": widget.book.author,
                                    "category": widget.book.category,
                                    "rating": widget.book.rating,
                                    "progress": widget.book.progress,
                                    "status": widget.book.status,
                                    "year": widget.book.year,
                                    "pages": widget.book.pages,
                                    "language": widget.book.language,
                                    "description": widget.book.description,
                                    "image": widget.book.image,
                                    "isFavorite": isFavorite,
                                  },
                                ),
                              ),
                            );

                            if (result != null) {
                              Navigator.pop(context, {
                                "index": widget.index,
                                "updatedBook": result,
                              });
                            }
                          },
                          icon: const Icon(Icons.edit),
                          label: Text(Localization.text('edit_buku')),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            side: BorderSide(color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(Localization.text('hapus')),
                                content: Text("Apakah Anda yakin ingin menghapus buku ini?"),
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
                          icon: const Icon(Icons.delete_outline, color: Colors.white),
                          label: Text(Localization.text('hapus'), style: const TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
