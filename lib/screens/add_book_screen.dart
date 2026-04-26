import 'package:flutter/material.dart';

class AddBookScreen extends StatelessWidget {
const AddBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Buku"),
      ),
      body: const Center(
        child: Text("Halaman Tambah Buku"),
      ),
    );
  }
}