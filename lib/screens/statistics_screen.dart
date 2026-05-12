import 'package:flutter/material.dart';
import '../models/book.dart';
import 'package:fl_chart/fl_chart.dart';
import '../main.dart';

class StatisticsScreen extends StatefulWidget {
  final List<Book> books;

  const StatisticsScreen({super.key, required this.books});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late int totalBooks;
  late int doneBooks;
  late int readingBooks;
  late int newBooks;
  late double avgProgress;
  late List<double> monthsData;
  late List<String> monthLabels;

  @override
  void initState() {
    super.initState();
    _calculateStats();
  }

  @override
  void didUpdateWidget(StatisticsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.books != widget.books) {
      _calculateStats();
    }
  }

  void _calculateStats() {
    final books = widget.books;
    totalBooks = books.length;
    doneBooks = books.where((b) => b.status == "Done").length;
    readingBooks = books.where((b) => b.status == "Reading").length;
    newBooks = books.where((b) => b.status == "New").length;

    avgProgress = books.isEmpty
        ? 0.0
        : books.map((b) => b.progress).reduce((a, b) => a + b) / books.length;

    final now = DateTime.now();
    final monthNames = ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"];
    
    monthsData = List.generate(6, (index) {
      final monthIndex = (now.month - (5 - index)) % 12;
      final targetMonth = monthIndex <= 0 ? monthIndex + 12 : monthIndex;
      final targetYear = now.year - (monthIndex <= 0 ? 1 : 0);

      double score = 0;
      for (var book in books) {
        if (book.dateAdded != null &&
            book.dateAdded!.year == targetYear &&
            book.dateAdded!.month == targetMonth) {
          score += 30;
        }
        if (book.dateCompleted != null &&
            book.dateCompleted!.year == targetYear &&
            book.dateCompleted!.month == targetMonth) {
          score += 50;
        } else if (book.status == "Reading" && book.dateAdded != null) {
          if (book.dateAdded!.isBefore(DateTime(targetYear, targetMonth + 1, 1))) {
            score += 10;
          }
        }
      }
      return score > 100 ? 100.0 : (score < 10 ? 10.0 : score);
    });

    monthLabels = List.generate(6, (index) {
      final monthIdx = (now.month - (5 - index) - 1) % 12;
      return monthNames[monthIdx < 0 ? monthIdx + 12 : monthIdx];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              Localization.text('statistik_membaca'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTopCard(context, totalBooks),
                const SizedBox(height: 28),
                buildSectionTitle(context, Localization.text('ringkasan')),
                const SizedBox(height: 16),
                buildSummaryRow(context, doneBooks, readingBooks, newBooks),
                const SizedBox(height: 28),
                buildSectionTitle(context, Localization.text('progress')),
                const SizedBox(height: 16),
                buildProgressCard(context, avgProgress),
                const SizedBox(height: 30),
                buildChartTitle(context),
                const SizedBox(height: 18),
                buildMonthlyChart(context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget buildTopCard(BuildContext context, int totalBooks) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6A5AE0), Color(0xFF8E7CFF)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Localization.text('total_buku'),
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            "$totalBooks Buku",
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildSummaryRow(BuildContext context, int done, int reading, int newBook) {
    return Row(
      children: [
        Expanded(
          child: buildMiniCard(
            context,
            title: Localization.text('selesai'),
            value: done,
            icon: Icons.check_circle,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildMiniCard(
            context,
            title: Localization.text('membaca'),
            value: reading,
            icon: Icons.auto_stories,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildMiniCard(
            context,
            title: Localization.text('baru'),
            value: newBook,
            icon: Icons.menu_book,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  Widget buildMiniCard(BuildContext context, {required String title, required int value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget buildProgressCard(BuildContext context, double avgProgress) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Progress",
                style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface),
              ),
              Text(
                "${avgProgress.toStringAsFixed(0)}%",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: avgProgress / 100,
              minHeight: 12,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChartTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Grafik Bulanan",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
        ),
        Text(
          "2026",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget buildMonthlyChart(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 6)),
        ],
      ),
      child: BarChart(
        BarChartData(
          maxY: 100,
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5), strokeWidth: 1);
            },
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      monthLabels[value.toInt()],
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(6, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: monthsData[index],
                  width: 16,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xFF6A5AE0), Color(0xFF9C8CFF)],
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 100,
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
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