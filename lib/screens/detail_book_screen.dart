import 'package:flutter/material.dart';
import '../models/book.dart';
import 'add_book_screen.dart';
import 'dart:io';
import '../main.dart';
class DetailBookScreen extends StatelessWidget {
  final Book book;
  final int index;
  final List<String> categories;

  const DetailBookScreen({super.key, required this.book, required this.index, required this.categories,});

  @override
  Widget build(BuildContext context) {
    Widget buildInfo(IconData icon, String title, String value){
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface))),
            Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        actions: [
          Icon(Icons.share, color: Theme.of(context).colorScheme.onBackground),
          const SizedBox(width: 12),
        ],
      ),
      body:SingleChildScrollView(
       
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //top section
             Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            //gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (book.image.isNotEmpty)
    ? (book.image.toString().startsWith("http")
        ? Image.network(
            book.image,
            height: 140,
            width: 100,
            fit: BoxFit.cover,
          )
        : Image.file(
            File(book.image),
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

            //info
            Expanded(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //judul
                Row(
                 
                  children: [
                    Expanded(
                      child: Text(
                        book.title,
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                    

                    //bookmark
                    Container(
                      padding: const  EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                     
                      child: Icon(Icons.star, color: Colors.white, size: 16),
                      
                      ),
                
                  ],
                ),
                const SizedBox(height: 4),

            //author
            Text(
              "${Localization.text('by')} ${book.author}",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),

            Row(children: [const Icon(Icons.star, color: Colors.amber, size: 16),
             const SizedBox(width: 4),
            Text("${book.rating}", style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            ],),

          const SizedBox(height: 8),
                    // status
                     
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          book.status,
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

                    //progres
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Localization.text('progress'), style: TextStyle(color: Theme.of(context).colorScheme.onBackground)),
                      Text("${book.progress}%", style: TextStyle(color: Theme.of(context).colorScheme.onBackground)),
                      ],
                    ),
                    const SizedBox(height: 8),

                    LinearProgressIndicator(
                      value: book.progress / 100,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),

                  //detail info
                  buildInfo(Icons.person_outline, Localization.text('penulis'), book.author),
                  buildInfo(Icons.grid_view, Localization.text('kategori'), book.category),
                  buildInfo(Icons.calendar_today_outlined, Localization.text('tahun'), book.year.toString()),
                  buildInfo(Icons.auto_stories_outlined, Localization.text('halaman'), book.pages.toString()),
                  buildInfo(Icons.language_outlined, Localization.text('bahasa'), book.language),

                 
            const SizedBox(height: 16),

            //deskripsi
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Deskripsi",
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
            const SizedBox(height: 6),
            Text(
             book.description,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),

             const SizedBox(height: 24),

            //buttons
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(onPressed: () async {
                  final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddBookScreen(
                            categories:categories,
                            book: {
                              "title": book.title,
                              "author": book.author,
                              "category": book.category,
                              "rating": book.rating,
                              "progress": book.progress,
                              "status": book.status,
                              "year": book.year,
                              "pages": book.pages,
                              "language": book.language,
                              "description": book.description,
                              "image":book.image
                            },
                          ),
                        ),
                      );

                      // KIRIM BALIK KE HOME
                      if (result != null) {
                        Navigator.pop(context, {
                          "index": index,
                          "updatedBook": result,
                        });
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),

               
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton.icon(
                 style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,),
                onPressed: () async {
                  final confirm = await showDialog(
                     context: context,
        builder: (context) => AlertDialog(
          title: const Text("Hapus Buku"),
          content: const Text("Yakin ingin menghapus buku ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Hapus"),
            ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    Navigator.pop(context, {
                      "index": index,
                      "delete": true,
                    });
                  }
                },
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
      },
    );
  }
}

                
        
            

