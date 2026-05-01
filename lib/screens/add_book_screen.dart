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
  final TextEditingController yearController = TextEditingController();
  final TextEditingController pagesController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
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
      yearController.text = widget.book!['year'].toString();
      pagesController.text = widget.book!['pages'].toString();
      languageController.text = widget.book!['language'];
      descriptionController.text = widget.book!['description'];
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

            //tahun
            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Tahun Terbit"),
            ),
            const SizedBox(height: 12),
            //pages
            TextField(
              controller: pagesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Jumlah Halaman"),
            ),
            const SizedBox(height: 12),

            //bahasa
            TextField(
              controller: languageController,
              decoration: const InputDecoration(labelText: "Bahasa"),
            ),
            const SizedBox(height: 12),

            //description
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Deskripsi"),
              maxLines: 3,
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
                  "year": int.tryParse(yearController.text) ?? 0,
                  "pages": int.tryParse(pagesController.text) ?? 0,
                  "language": languageController.text,
                  "description": descriptionController.text,
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
