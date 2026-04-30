import 'package:flutter/material.dart';

class AddBookScreen extends StatefulWidget {
  final Map<String, dynamic>? book;
  
const AddBookScreen({super.key, this.book});

@override 
void initState() {
  super.initState();

  if (widget.book != null) {
    titleController.text = widget.book!['title'];
    authorController.text = widget.book!['author'];
  }
}

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State <AddBookScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Buku"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Judul Buku",
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: authorController,
            decoration: const InputDecoration(
              labelText: "Penulis",
            ),
          ),
          const SizedBox(height: 20),

          //tombol simpan
          ElevatedButton(onPressed: (){
            if (titleController.text.isEmpty || authorController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Judul dan Penulis tidak boleh kosong")),
              );
              return;
            }
            final newBook={
              "title":titleController.text,
              "author":authorController.text,
            };
            Navigator.pop(  context, newBook);
          },
           child: const Text("Simpan"),
          ),
        ],
        ),
      ),
    );
  }
}