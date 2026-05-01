import 'package:flutter/material.dart';
import '../models/book.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Book> books;

  const StatisticsScreen({super.key, required this.books});
  @override
  Widget build(BuildContext context) {
    final total = books.length;
    final done = books.where((b) => b.status == "Done").length;
    final reading = books.where((b) => b.status == "Reading").length;
    final newBook = books.where((b) => b.status == "New").length;

    return Scaffold(
      appBar: AppBar(title: const Text("Statistik Buku")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Statistik Buku",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: done.toDouble(),
                      color: Colors.green,
                      title: "Done",
                    ),
                    PieChartSectionData(
                      value: reading.toDouble(),
                      color: Colors.orange,
                      title: "Sedang Dibaca",
                    ),
                    PieChartSectionData(
                      value: newBook.toDouble(),
                      color: Colors.grey,
                      title: "Belum Dibaca",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text("Total Buku: $total"),
            Text("Done: $done"),
            Text("Sedang Dibaca: $reading"),
            Text("Belum Dibaca: $newBook"),
          ],
        ),
      ),
    );
  }
}
