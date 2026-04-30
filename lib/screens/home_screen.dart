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
  String searchQuery = "";
  String selectedStatus = "All";

  @override
  Widget build(BuildContext context) {
    final filteredBooks = books.where((book) {
      final Matchsearch = book.title.toLowerCase().contains(searchQuery.toLowerCase()) || book.author.toLowerCase().contains(searchQuery.toLowerCase());
      final Matchstatus = selectedStatus == "All" || book.status == selectedStatus;

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
                  return Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(
                    label: Text(status),
                    selected: selectedStatus == status,
                    onSelected: (selected) {
                      setState(() {
                        selectedStatus = status;
                      });
                      //filter berdasarkan status
                    },
                  ),);
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

                  return BookCard(
                    book:book,
                    onDelete: () {
                      setState(() {
                        books.removeAt(realIndex);
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
                          },
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          books[realIndex] = Book(
                            title: result["title"],
                            author: result["author"],
                            rating: book.rating,
                            progress: result["progress"] ?? book.progress,
                            status: book.status,
                            image: book.image,
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
                  progress: result["progress"] ?? 0,
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
