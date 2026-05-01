import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import 'add_book_screen.dart';
import 'detail_book_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookList = books
        .map(
          (book) => {
            "title": book.title,
            "author": book.author,
            "rating": book.rating,
            "progress": book.progress,
            "status": book.status,
            "image": book.image,
            "category": book.category,
          },
        )
        .toList();
    prefs.setString("books", jsonEncode(bookList));
  }

  Future<void> loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("books");

    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        books = decoded
            .map(
              (item) => Book(
                title: item["title"],
                author: item["author"],
                rating: item["rating"].toDouble(),
                progress: item["progress"],
                status: item["status"],
                image: item["image"],
                category: item["category"] ?? "Lainnya",
              ),
            )
            .toList();
      });
    }
  }

  List<Book> books = [
    Book(
      title: "laskar pelangi",
      author: "Andrea Hirata",
      rating: 4.7,
      progress: 70,
      status: "Reading",
      category: "Novel",
      image: "https://picsum.photos/200/300",
    ),
    Book(
      title: "Atomic Habits",
      author: "James Clear",
      rating: 4.8,
      progress: 100,
      status: "Done",
      category: "Pengembangan Diri",
      image: "https://picsum.photos/200/300",
    ),
  ];
  String searchQuery = "";
  String selectedStatus = "All";
  String getStatus(int progress) {
    if (progress == 100) return "Done";
    if (progress > 0) return "Reading";
    return "New";
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = books.where((book) {
      final Matchsearch =
          book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(searchQuery.toLowerCase());
      final Matchstatus =
          selectedStatus == "All" || book.status == selectedStatus;

      return Matchsearch && Matchstatus;
    }).toList();

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
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
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

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All", "Reading", "Done"].map((status) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: selectedStatus == status,
                      onSelected: (selected) {
                        setState(() {
                          selectedStatus = status;
                        });
                        //filter berdasarkan status
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            //list  buku
            Expanded(
              child: ListView.builder(
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = filteredBooks[index];
                  final realIndex = books.indexOf(book);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailBookScreen(book: book),
                        ),
                      );
                    },
                    child: BookCard(
                      book: book,
                      onDelete: () {
                        setState(() {
                          books.removeAt(realIndex);
                          saveBooks();
                        });
                      },
                      onEdit: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddBookScreen(
                              book: {
                                "title": book.title,
                                "author": book.author,
                                "progress": book.progress,
                                "rating": book.rating,
                                "category": book.category,
                              },
                            ),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            final newProgress =
                                result["progress"] ?? book.progress;

                            books[realIndex] = Book(
                              title: result["title"],
                              author: result["author"],
                              rating: result["rating"] ?? book.rating,
                              progress: newProgress,
                              status: getStatus(newProgress),
                              category: result["category"] ?? book.category,
                              image: book.image,
                            );
                            saveBooks();
                          });
                        }
                      },
                    ),
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
              final progress = result["progress"] ?? 0;
              books.add(
                Book(
                  title: result["title"],
                  author: result["author"],
                  rating: result["rating"] ?? 0,
                  progress: progress,
                  status: getStatus(progress),
                  category: result["category"] ?? "Lainnya",
                  image: "https://picsum.photos/200/300",
                ),
              );
              saveBooks();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
