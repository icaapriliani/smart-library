import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import 'add_book_screen.dart';
import 'detail_book_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
   final Function(int) onTabChange;
    final List<String>categories;
  final List<Book> books;
 

  const HomeScreen({ required this.onTabChange,
    super.key,
    required this.books,
    required this.categories,
  });
   @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 String searchQuery = "";
  String selectedStatus = "All";
  @override
  void initState() {
    super.initState();
    loadBooks();
  }
  String getStatus(int progress) {
    if (progress == 100) return "Done";
    if (progress > 0) return "Reading";
    return "New";
  }



  Future<void> saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookList = widget.books
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
        widget.books.clear();

        widget.books.addAll(
      decoded.map(
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
        );
      });
    }
  }

  
 
  

  Widget buildStat(String title, int value){
    return Column(
      children: [
        Text(value.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        Text(title, style: const TextStyle(color: Colors.grey),)
        ],
    );
  }
  Widget buildStatItem(IconData icon, String title, int value) {
  return Column(
    children: [
      CircleAvatar(
        radius: 16,
        backgroundColor: Colors.white,
        child: Icon(icon, size: 16, color: Colors.deepPurple),
      ),
      const SizedBox(height: 6),
      Text(
        value.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 11,
        ),
      ),
    ],
  );
}

  @override
  
  Widget build(BuildContext context) {
    final books = widget.books;
    final filteredBooks = books.where((book) {
      final matchsearch =
          book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(searchQuery.toLowerCase());
      final matchstatus =
          selectedStatus == "All" || book.status == selectedStatus;

      return matchsearch && matchstatus;
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
          
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        //header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: 

            //left text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:const [
                
                  Text("Halo, Ica",
                  style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "smart library", 
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                     SizedBox(height: 4),
        Text(
          "Kelola koleksi buku pribadimu dengan mudah",
          style: TextStyle(color: Colors.grey),
        ),
              ],
            ),
            ),
            //right icon
            Row(
              children: [
                //notifikasi
                Stack(
                  children: [
                    const Icon(Icons.notifications_none, size: 26),
                    Positioned(right: 0, child: Container(
                     padding: const EdgeInsets.all(4),
                     decoration: BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
                     child: const Text("3", style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                //avatar
                const CircleAvatar(
                  backgroundImage: NetworkImage("https://picsum.photos/200/300"),
                ),
            
              ],
            ),
          ],
        
        ),
          const SizedBox(height: 16),
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
            //filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All", "New","Reading", "Done"].map((status) {
                  final isSelected = selectedStatus == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: isSelected,
                      selectedColor: Colors.deepPurple,
                      backgroundColor: Colors.grey.shade200,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onSelected: (_) {
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
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailBookScreen(
                            book: book,
                            index: realIndex,
                            categories: widget.categories,
                          ),
                        ),
                      );

                      /// 🔥 terima data dari detail
                      if (result != null) {
                          if (result["delete"] == true) {
    setState(() {
      books.removeAt(result["index"]);
    });
    saveBooks();
    return;
  }
  // hadle edit
  setState(() {
    final updated = result["updatedBook"];
                          books[result["index"]] = Book(
                            title: updated["title"],
                            author: updated["author"],
                            rating: updated["rating"],
                            progress: updated["progress"],
                            status: updated["status"],
                            category: updated["category"],
                            year: updated["year"] ?? book.year,
                            pages: updated["pages"] ?? book.pages,
                            language: updated["language"] ?? book.language,
                            description:
                                updated["description"] ?? book.description,
                              image: updated["image"],
                          );
                        });

                        saveBooks();
                      }
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
                             categories: widget.categories,
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
                             image: result["image"],
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
            
            //stat card
            Container(
               margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
            
              borderRadius: BorderRadius.circular(16),
             gradient: const LinearGradient(
      colors: [Color(0xFF6A5AE0), Color(0xFF8E7CFF)],
         ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
children:  [
          const Text(
            "Statistik Membaca",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        GestureDetector(
  onTap: () {
    widget.onTabChange(2);
  },
      child: const Text(
        "Lihat Detail",
        style: TextStyle(color: Colors.white70),
      ),
    ),
  ],
),
      const SizedBox(height: 16),

      //stats row
      Row(
        mainAxisAlignment:MainAxisAlignment.spaceAround,
        children: [
           buildStatItem(Icons.menu_book, "Total", books.length),
          buildStatItem(Icons.check_circle, "Selesai",
              books.where((b) => b.status == "Done").length),
          buildStatItem(Icons.auto_stories, "Reading",
              books.where((b) => b.status == "Reading").length),
          buildStatItem(Icons.book, "New",
              books.where((b) => b.status == "New").length),


      
       ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
           

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookScreen(categories:widget.categories)),
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
                     image: result["image"] ?? "",
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
