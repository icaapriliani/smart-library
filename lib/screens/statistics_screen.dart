import 'package:flutter/material.dart';
import '../models/book.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Book> books;

  const StatisticsScreen({super.key, required this.books});
@override
Widget build(BuildContext context) {
  final total = books.length;
  final done= books.where((b) => b.status == "Done").length;
  final reading= books.where((b) => b.status == "Reading").length;
  final newBook = books.where((b) => b.status == "New").length;

  return Scaffold(
    appBar: AppBar(title: const Text("Statistik Membaca")),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       buildCard("Total Buku", total, Colors.blue),
       buildCard("Selesai", done, Colors.green),
       buildCard("Sedang Dibaca", reading, Colors.orange),
       buildCard("Belum Dibaca", newBook, Colors.grey),
       
        ],
      ),
    ),
  );
}
 
 Widget buildCard(String title, int value, Color color) {
   return Card(
     margin: const EdgeInsets.symmetric(vertical: 10),
     child: ListTile(
       leading: CircleAvatar(
         backgroundColor: color,
       ),
       title: Text(title),
      trailing: Text(
          value.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), ),
     ),
   );
 }
}