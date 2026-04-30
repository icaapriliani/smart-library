import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import 'add_book_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> books = [
    Book(
      title: "laskar pelangi",
      author: "Andrea Hirata",
      rating: 4.7,
      progress: 70,
      status: "Reading",
      image: "https://picsum.photos/200/300",
    ),
    Book(
      title: "Atomic Habits",
      author: "James Clear",
      rating: 4.8,
      progress: 100,
      status: "Done",
      image: "https://picsum.photos/200/300",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),

      appBar: AppBar(
        title: const Text("Smart Library"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //search bar
            TextField(
              decoration: InputDecoration(
                hintText: "Cari buku...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            //list  buku
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return BookCard(
                    book: books[index],
                    onDelete: () {
                      setState(() {
                        books.removeAt(index);
                      });
                    },
                    onEdit: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddBookScreen(
                            book: {
                            "title": books[index].title,
                            "author": books[index].author,
                          },
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          books[index] = Book(
                            title: result["title"],
                            author: result["author"],
                            rating: books[index].rating,
                            progress: books[index].progress,
                            status: books[index].status,
                            image: books[index].image,
                             );
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookScreen()),
          );
          if (result != null) {
            setState(() {
              books.add(
                Book(
                  title: result["title"],
                  author: result["author"],
                  rating: 0,
                  progress: 0,
                  status: 'New',
                  image: "https://picsum.photos/200/300",
                ),
              );
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
