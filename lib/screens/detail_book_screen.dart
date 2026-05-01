import 'package:flutter/material.dart';
import '../models/book.dart';

class DetailBookScreen extends StatelessWidget {
  final Book book;

  const DetailBookScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        actions: const[
          Icon( Icons.share),
          SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //top section
             Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            //gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                book.image,
                height: 140,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            //info
            Expanded(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //judul
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        book.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                      ),
                    ),
                    ),
                    

                    //bookmark
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(padding: EdgeInsets.all(6),
                      child: Icon(Icons.star, color: Colors.white, size: 16),
                      ),
                      ),
                
                  ],
                ),
                const SizedBox(height: 4),

            //judul
            Text(
              "by ${book.author}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),

            Row(children: [const Icon(Icons.star, color: Colors.amber, size: 16),
             const SizedBox(width: 4),
            Text("${book.rating}"),
            ],),

          const SizedBox(height: 8),
                    // status
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          book.status,
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                       ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

                    //progres
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Progress Membaca"),
                      Text("${book.progress}%"),
                      ],
                    ),
                    const SizedBox(height: 8),

                    LinearProgressIndicator(
                      value: book.progress / 100,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 20),

                  //detail info
                  buildInfo(Icons.category, "Kategori", book.category),
                  buildInfo(Icons.calendar_today, "Tahun Terbit", book.year.toString()),
                  buildInfo(Icons.menu_book, "Jumlah Halaman", "${book.pages} halaman"),
                  buildInfo(Icons.language, "Bahasa", book.language),

                 
            const SizedBox(height: 16),

            //deskripsi
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Deskripsi",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            Text(
             book.description,
              style: const TextStyle(color: Colors.grey),
            ),

            const Spacer(),

            //buttons
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(onPressed: () {},
                icon: const Icon(Icons.edit), label: const Text("Edit Book"),
                ),
                ),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton.icon(
                 style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,),
                onPressed: () {}, icon: const Icon(Icons.delete), label: const Text("Delete Book"),
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
Widget buildInfo(IconData icon, String title, String value){
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
       Expanded(child: Text(title)),
        Text(value, style: const TextStyle(color: Colors.grey)),
      ],
    ),
  );
}
}

                
        
            

