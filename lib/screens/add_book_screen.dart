import 'package:flutter/material.dart';

class AddBookScreen extends StatefulWidget {
  final Map<String, dynamic>? book;

  const AddBookScreen({super.key, this.book});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  double progress = 0;
  double rating = 0;
  String selectedCategory = "Novel";

  final List<String> categories = [
    "Novel",
    "Pengembangan Diri",
    "Sejarah",
    "Bisnis",
    "Teknologi",
  ];
  @override
  void initState() {
    super.initState();

    if (widget.book != null) {
      titleController.text = widget.book!['title'];
      authorController.text = widget.book!['author'];
      progress = (widget.book!['progress'] ?? 0).toDouble();
      rating = (widget.book!['rating'] ?? 0).toDouble();
      selectedCategory = widget.book?["category"] ?? "Novel";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book != null ? "Edit Buku" : "Tambah Buku"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //judul
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Judul Buku"),
            ),
            const SizedBox(height: 12),
            //penulis
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: "Penulis"),
            ),
            const SizedBox(height: 12),
            //kategori
            DropdownButtonFormField(
              value: selectedCategory,
              items: categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Kategori"),
            ),
            const SizedBox(height: 20),

            //progres
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Progress: ${progress.toInt()}%"),
            ),
            Slider(
              value: progress,
              min: 0,
              max: 100,
              label: progress.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  progress = value;
                });
              },
            ),
            const SizedBox(height: 20),

            //rating
            Align(alignment: Alignment.centerLeft, child: Text('Rating')),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    color: index < rating ? Colors.amber : Colors.grey,
                  ),
                );
              }),
            ),
            //tombol simpan
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty ||
                    authorController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Judul dan Penulis tidak boleh kosong"),
                    ),
                  );
                  return;
                }
                final newBook = {
                  "title": titleController.text,
                  "author": authorController.text,
                  "progress": progress.toInt(),
                  "rating": rating,
                  "category": selectedCategory,
                };

                Navigator.pop(context, newBook);
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
