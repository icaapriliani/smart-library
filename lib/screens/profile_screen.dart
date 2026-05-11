import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../models/book.dart';

class ProfileScreen extends StatefulWidget {
  final List<Book> books;

  const ProfileScreen({super.key, required this.books});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _toggleDarkMode(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', val);
    themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
    setState(() {});
  }

  Future<void> _showEditProfileDialog() async {
    final nameController = TextEditingController(text: userNameNotifier.value);
    final imageController = TextEditingController(text: userImageNotifier.value);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Edit Profil"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama Pengguna",
                hintText: "Masukkan nama Anda",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: "URL Foto Profil",
                hintText: "Masukkan URL gambar",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A5AE0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('userName', nameController.text);
              await prefs.setString('userImage', imageController.text);
              userNameNotifier.value = nameController.text;
              userImageNotifier.value = imageController.text;
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menghitung statistik
    int totalBooks = widget.books.length;
    int completedBooks = widget.books.where((b) => b.status == "Done").length;
    
    // Menghitung kategori favorit
    String favoriteCategory = "Belum ada";
    if (widget.books.isNotEmpty) {
      Map<String, int> counts = {};
      for (var book in widget.books) {
        counts[book.category] = (counts[book.category] ?? 0) + 1;
      }
      favoriteCategory = counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    // Progress target (contoh statis: 5 dari 10 buku)
    double targetProgress = completedBooks / 10.0;
    if (targetProgress > 1.0) targetProgress = 1.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan Gradien
            Stack(
              children: [
                Container(
                  height: 280,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6A5AE0), Color(0xFF8E7CFF)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 48), // Spasi seimbang dengan IconButton
                            const Text(
                              "Profil Saya",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: _showEditProfileDialog,
                              icon: const Icon(Icons.edit, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Avatar & Info
                        Row(
                          children: [
                            ValueListenableBuilder<String>(
                              valueListenable: userImageNotifier,
                              builder: (context, imageUrl, _) {
                                return Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white24,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(imageUrl),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ValueListenableBuilder<String>(
                                    valueListenable: userNameNotifier,
                                    builder: (context, name, _) {
                                      return Text(
                                        name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                  const Text(
                                    "Pembaca Antusias",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Reading Target Progress
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Target Bacaan 2024",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "$completedBooks / 10 Buku",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: targetProgress,
                                  backgroundColor: Colors.white24,
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                  minHeight: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ringkasan Bacaan
                  const Text(
                    "Ringkasan Bacaan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1D2B),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _buildSummaryCard(
                        "Total Buku",
                        totalBooks.toString(),
                        Icons.collections_bookmark,
                        const Color(0xFF6A5AE0).withOpacity(0.1),
                        const Color(0xFF6A5AE0),
                      ),
                      const SizedBox(width: 15),
                      _buildSummaryCard(
                        "Selesai",
                        completedBooks.toString(),
                        Icons.check_circle_rounded,
                        const Color(0xFF4CAF50).withOpacity(0.1),
                        const Color(0xFF4CAF50),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildFavoriteCard(favoriteCategory),

                  const SizedBox(height: 25),
                  // Pengaturan
                  const Text(
                    "Pengaturan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1D2B),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSettingItem(
                          Icons.dark_mode_outlined,
                          "Mode Gelap",
                          trailing: Switch(
                            value: themeNotifier.value == ThemeMode.dark,
                            activeColor: const Color(0xFF6A5AE0),
                            onChanged: _toggleDarkMode,
                          ),
                        ),
                        _buildDivider(),
                        _buildSettingItem(Icons.notifications_none, "Notifikasi"),
                        _buildDivider(),
                        _buildSettingItem(Icons.language, "Bahasa"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  // Tentang
                  const Text(
                    "Tentang Aplikasi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1D2B),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSettingItem(Icons.info_outline, "Versi Aplikasi", trailing: const Text("v1.0.0", style: TextStyle(color: Colors.grey))),
                        _buildDivider(),
                        _buildSettingItem(Icons.star_outline, "Beri Rating"),
                        _buildDivider(),
                        _buildSettingItem(Icons.privacy_tip_outlined, "Kebijakan Privasi"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color bgColor, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 15),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1D2B),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(String category) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite, color: Colors.orange, size: 28),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Kategori Favorit",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1D2B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1F1D2B)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F1D2B),
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 20,
      endIndent: 20,
      color: Colors.grey.withOpacity(0.1),
    );
  }
}
