import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../main.dart';


class AddBookScreen extends StatefulWidget {
  final Map<String, dynamic>? book;
  final List<String> categories;

  const AddBookScreen({super.key, this.book, required this.categories,});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final  titleController = TextEditingController();
  final  authorController = TextEditingController();
  final  yearController = TextEditingController();
  final  pagesController = TextEditingController();
  final languageController = TextEditingController();
  final  descriptionController = TextEditingController();
  double progress = 0;
  double rating = 0;
  late String selectedCategory;
   File? selectedImage;

  
  String getStatus(int progress) {
    if (progress == 100) return "Done";
    if (progress > 0) return "Reading";
    return "New";
  }
  Future<void> pickImage() async {
    final picked = await ImagePicker(). pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }
  @override
  void initState() {
    super.initState();

    if (widget.book != null) {
      titleController.text = widget.book!['title'] ?? "";
      authorController.text = widget.book!['author'] ?? "";
      progress = (widget.book!['progress'] ?? 0).toDouble();
      rating = (widget.book!['rating'] ?? 0).toDouble();
      
      String bookCategory = widget.book?["category"] ?? "Novel";
      // Pastikan kategori ada di list agar Dropdown tidak crash
      if (!widget.categories.contains(bookCategory)) {
        widget.categories.add(bookCategory);
      }
      selectedCategory = bookCategory;

      yearController.text = (widget.book!['year'] ?? 0).toString();
      pagesController.text = (widget.book!['pages'] ?? 0).toString();
      languageController.text = widget.book!['language'] ?? "";
      descriptionController.text = widget.book!['description'] ?? "";
    } else {
      // Mode tambah baru: gunakan "Novel" jika ada, jika tidak gunakan elemen pertama
      if (widget.categories.contains("Novel")) {
        selectedCategory = "Novel";
      } else if (widget.categories.isNotEmpty) {
        selectedCategory = widget.categories.first;
      } else {
        selectedCategory = "Lainnya";
        if (!widget.categories.contains("Lainnya")) {
          widget.categories.add("Lainnya");
        }
      }
    }
  }
  
  Widget buildCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
  @override
  Widget build(BuildContext context) {
      final isEdit = widget.book != null;
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? Localization.text('edit_buku') : Localization.text('tambah_buku')),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
             //cover
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                 
  
  image: selectedImage != null
      ? DecorationImage(
          image: FileImage(selectedImage!),
          fit: BoxFit.cover,
        )
      : (widget.book?["image"] != null
          ? DecorationImage(
              image: widget.book!["image"].toString().startsWith("http")
                  ? NetworkImage(widget.book!["image"])
                  : FileImage(File(widget.book!["image"])) as ImageProvider,
              fit: BoxFit.cover,
            )
          : null),
),
                child: selectedImage == null
                    ? Icon(Icons.add_a_photo, size: 30, color: Theme.of(context).colorScheme.onSurfaceVariant)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            //judul
           buildCard(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: Localization.text('judul_buku'),
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
            //penulis
            TextField(
              controller: authorController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: Localization.text('penulis'),
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
        
            //kategori
            DropdownButtonFormField<String>(
              value: selectedCategory,
              dropdownColor: Theme.of(context).colorScheme.surface,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: Localization.text('kategori'),
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    items: widget.categories
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedCategory = val!;
                         });
                    },
                  ),
                ],
              ),
            ),

            //tahun
             buildCard(
              child: Column(
                children: [
            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: Localization.text('tahun_terbit'),
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
    
            //pages
            TextField(
              controller: pagesController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: Localization.text('jumlah_halaman'),
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
  

            //bahasa
            TextField(
              controller: languageController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: Localization.text('bahasa'),
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
                ],
              ),
            ),

            /// ===== PROGRESS =====
            buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${Localization.text('progress')}: ${progress.toInt()}%", style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  Slider(
                    value: progress,
                    min: 0,
                    max: 100,
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Theme.of(context).colorScheme.surfaceVariant,
                    onChanged: (val) {
                      setState(() {
                        progress = val;
                      });
                    },
                  ),
                ],
              ),
            ),

            /// ===== RATING =====
            buildCard(
              child: Row(
                children: List.generate(5, (i) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        rating = i + 1;
                      });
                    },
                    icon: Icon(
                      Icons.star,
                      size: 28,
                      color:
                          i < rating ? Colors.amber : Theme.of(context).colorScheme.surfaceVariant,
                    ),
                  );
                }),
              ),
            ),

            /// ===== DESKRIPSI =====
            buildCard(
              child: TextField(
                controller: descriptionController,
                maxLines: 4,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// ===== BUTTON =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  if (titleController.text.isEmpty ||
                      authorController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Judul & Penulis wajib diisi"),
                      ),
                    );
                    return;
                  }

                   Navigator.pop(context, {
                  "title": titleController.text,
                  "author": authorController.text,
                  "progress": progress.toInt(),
                  "rating": rating,
                  "category": selectedCategory,
                   "status": getStatus(progress.toInt()),
                  "year": int.tryParse(yearController.text) ?? 0,
                  "pages": int.tryParse(pagesController.text) ?? 0,
                  "language": languageController.text,
                  "description": descriptionController.text,
               "image": selectedImage?.path ??
                        widget.book?["image"],
                });
                },
                child: Text(isEdit ? "Update" : "Simpan",   style: const TextStyle(color: Colors.white)),

              ),
            
              
           
            ),
          ],
        ),
      ),
    );
      },
    );
  }
}
