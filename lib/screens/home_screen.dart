import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import 'add_book_screen.dart';
import 'detail_book_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'statistics_screen.dart';

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
            "year": book.year,
            "pages": book.pages,
            "language": book.language,
            "description": book.description,
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
                year: item["year"] ?? 0,
                pages: item["pages"] ?? 0,
                language: item["language"] ?? "Indonesia",
                description: item["description"] ?? "",
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
      year: 2005,
      pages: 529,
      language: "Indonesia",
      description: "Cerita inspiratif tentang anak-anak Belitung.",
    ),
    Book(
      title: "Atomic Habits",
      author: "James Clear",
      rating: 4.8,
      progress: 100,
      status: "Done",
      category: "Pengembangan Diri",
      image: "https://picsum.photos/200/300",
      year: 2010,
      pages: 300,
      language: "English",
      description: "Cerita inspiratif tentang anak-anak Belitung.",
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
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatisticsScreen(books: books),
                ),
              );
            },
          ),
        ],
      ),
      //header
      
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text ("Halo,Ica", style: TextStyle(color: Colors.grey),),
          const SizedBox(height: 4),
          const Text("Smart Libarary", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),
          const SizedBox(height: 4),
          const Text("kelola koleksi buku pribadimu dengan mudah" , style: TextStyle(color: Colors.grey),
          ),
        
      ],),
            ///search
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 10,
                  ),
                ],
              ),
            child: TextField(onChanged: (value){
                setState(() {
                  searchQuery = value;
                });
            },
              decoration: InputDecoration(
                hintText: "Cari buku, penulis, atau kategori...",
                prefixIcon:  Icon(Icons.search),
                suffixIcon: Icon (Icons.tune),
                border: InputBorder.none,
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
                              year: result["year"] ?? book.year,
                              pages: result["pages"] ?? book.pages,
                              language: result["language"] ?? book.language,
                              description:
                                  result["description"] ?? book.description,
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
                  year: result["year"] ?? 0,
                  pages: result["pages"] ?? 0,
                  language: result["language"] ?? "Indonesia",
                  description: result["description"] ?? "",
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
