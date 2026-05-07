import 'package:flutter/material.dart';
import '../models/book.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Book> books;

  const StatisticsScreen({super.key, required this.books});
  @override
  Widget build(BuildContext context) {
    final totalBooks = books.length;
    final doneBooks = books.where((b) => b.status == "Done").length;
    final readingBooks = books.where((b) => b.status == "Reading").length;
    final newBooks = books.where((b) => b.status == "New").length;

final avgProgress = books.isEmpty
        ? 0.0
        : books
                .map((b) => b.progress)
                .reduce((a, b) => a + b) /
            books.length;

    return Scaffold(
      
       backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        
        title: const Text(
          "Reading Statistics",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,),
            ),
      ),
      body: SingleChildScrollView(

        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //top card
             buildTopCard(totalBooks),
             const SizedBox(height: 28),
             //ringkasn
              buildSectionTitle("Ringkasan"),

             const SizedBox(height: 16),
            buildSummaryRow(
              doneBooks,
              readingBooks,
              newBooks,
            ),
            const SizedBox(height: 28), 
            //progres
            buildSectionTitle("Progress Membaca"),

            const SizedBox(height: 16),

            buildProgressCard(avgProgress),

            const SizedBox(height: 30),

            //chart title
             buildChartTitle(),

            const SizedBox(height: 18),

            //chart
           buildMonthlyChart(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  //section title
  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

//top card
Widget buildTopCard(int totalBooks) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28), 
      gradient: const LinearGradient(begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ Color(0xFF6A5AE0),
            Color(0xFF8E7CFF),
            ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.25),blurRadius: 18, offset: const Offset(0, 8),
              ),
            ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Total Buku", style: TextStyle(
              color: Colors.white70,
              fontSize: 14,),),
               const SizedBox(height: 8),

               Text("$totalBooks Buku",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,),
               ),
      ],
    ),
  );
}

//summary row
Widget buildSummaryRow(
    int done,
    int reading,
    int newBook,
  ) {
    return Row(
      children: [

        Expanded(
          child: buildMiniCard(
            title: "Done",
            value: done,
            icon: Icons.check_circle,
            color: Colors.green,
          ),
        ),
const SizedBox(width: 12),
Expanded(
          child: buildMiniCard(
            title: "Reading",
            value: reading,
            icon: Icons.auto_stories,
            color: Colors.orange,
          ),
        ),

        const SizedBox(width: 12),
        Expanded(child: buildMiniCard(
            title: "New",
            value: newBook,
            icon: Icons.menu_book,
            color: Colors.blueGrey,),
        ),
      ],
    );
  }
  //mini card
  Widget buildMiniCard({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18,),
       decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
child: Column(
        children: [
CircleAvatar(
  radius: 20,
  backgroundColor: color.withOpacity(0.12),

            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  //progres card
  Widget buildProgressCard(double avgProgress) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [

              const Text(
                "Total Progress",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),

              Text(
                "${avgProgress.toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: LinearProgressIndicator(
              value: avgProgress / 100,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
  //chart title
  Widget buildChartTitle(){
    return Row(
       mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Grafik Bulanan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
        ),
        ),
        Text(
          "2026",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
//monthly chart
 Widget buildMonthlyChart() {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
child:BarChart(
        BarChartData(
          maxY: 100,
          alignment:BarChartAlignment.spaceAround, 
          borderData:
              FlBorderData(show: false),

          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: 20,

            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(

            topTitles: AxisTitles(
              sideTitles:
                  SideTitles(showTitles: false),
            ),

            rightTitles: AxisTitles(
              sideTitles:
                  SideTitles(showTitles: false),
            ),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 20,

                getTitlesWidget:
                    (value, meta) {

                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

            bottomTitles:AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months=[
                    "Jan","Feb","Mar","Apr","Mei","Jun",
                  ];
                  return Padding(
                    padding:
                        const EdgeInsets.only(
                            top: 8),

                    child: Text(
                      months[value.toInt()],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
 barGroups:
              List.generate(6, (index) {

            final value = books.isEmpty
                ? 20.0
                : books[index % books.length]
                    .progress
                    .toDouble();

            return BarChartGroupData(
              x: index,

              barRods: [

                BarChartRodData(
                  toY: value,

                  width: 18,
borderRadius: BorderRadius.circular(8),
gradient: const LinearGradient(begin:  Alignment.bottomCenter,
                    end: Alignment.topCenter,

                    colors: [
                      Color(0xFF6A5AE0),
                      Color(0xFF9C8CFF),
                      

       ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}