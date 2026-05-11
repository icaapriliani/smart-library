import 'package:flutter/material.dart';
import '../models/book.dart';

class ProfileScreen extends StatefulWidget {
  final List<Book> books;

  const ProfileScreen({super.key, required this.books});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;

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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Profil Saya",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Avatar & Info
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white24,
                                shape: BoxShape.circle,
                              ),
                              child: const CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage("https://picsum.photos/200/300"),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Ica Apriliani",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Pembaca Antusias",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
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
                            value: isDarkMode,
                            activeColor: const Color(0xFF6A5AE0),
                            onChanged: (val) {
                              setState(() {
                                isDarkMode = val;
                              });
                            },
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
