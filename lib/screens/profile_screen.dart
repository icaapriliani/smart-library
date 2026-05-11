import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../main.dart';
import '../models/book.dart';

class ProfileScreen extends StatefulWidget {
  final List<Book> books;

  const ProfileScreen({super.key, required this.books});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isNotificationsEnabled = true;
  String _selectedLanguage = "Indonesia";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? "Indonesia";
    });
  }

  Future<void> _toggleNotifications(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', val);
    setState(() {
      _isNotificationsEnabled = val;
    });
  }

  Future<void> _showLanguageDialog() async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Pilih Bahasa"),
        children: [
          _buildLanguageOption("Indonesia"),
          _buildLanguageOption("English"),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String lang) {
    return SimpleDialogOption(
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selectedLanguage', lang);
        languageNotifier.value = lang;
        setState(() {
          _selectedLanguage = lang;
        });
        if (mounted) Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lang, style: const TextStyle(fontSize: 16)),
            if (_selectedLanguage == lang)
              const Icon(Icons.check_circle, color: Color(0xFF6A5AE0)),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Bantuan & FAQ"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: const [
              _FAQItem(
                question: "Bagaimana cara menambah buku?",
                answer: "Klik tombol '+' di halaman Home, isi data buku, lalu simpan.",
              ),
              _FAQItem(
                question: "Bagaimana cara mengedit buku?",
                answer: "Klik buku yang ingin diedit, lalu tekan ikon pensil di pojok kanan atas.",
              ),
              _FAQItem(
                question: "Bagaimana cara mengubah tema?",
                answer: "Masuk ke Profile, lalu aktifkan switch Mode Gelap.",
              ),
              _FAQItem(
                question: "Bagaimana cara menambah kategori?",
                answer: "Buka menu Kategori, klik tombol '+', masukkan nama kategori baru.",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup")),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Kebijakan Privasi"),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Data Anda Aman",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                "Smart Library menyimpan data buku dan preferensi Anda secara lokal di perangkat. Kami tidak mengirimkan data pribadi Anda ke server eksternal.",
              ),
              SizedBox(height: 16),
              Text(
                "Penggunaan Data",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                "Data digunakan hanya untuk keperluan fungsionalitas aplikasi seperti statistik membaca dan manajemen koleksi buku pribadi.",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Mengerti")),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Tentang Aplikasi"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF6A5AE0),
              child: Icon(Icons.library_books, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              "Smart Library",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Text("Versi 1.0.0"),
            const SizedBox(height: 16),
            const Text(
              "Aplikasi manajemen perpustakaan pribadi yang modern dan elegan untuk mencatat progres bacaan Anda.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              "© 2024 Smart Library Team",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup")),
        ],
      ),
    );
  }

  Future<void> _toggleDarkMode(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', val);
    themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
    setState(() {});
  }

  Future<void> _pickImage(TextEditingController imageController) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageController.text = image.path;
    }
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
              decoration: InputDecoration(
                labelText: "Foto Profil (URL atau Jalur File)",
                hintText: "Masukkan URL atau pilih dari galeri",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => _pickImage(imageController),
                ),
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

    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
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
                                const SizedBox(width: 48),
                                Text(
                                  Localization.text('profile'),
                                  style: const TextStyle(
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
                                    backgroundColor: Colors.white24,
                                    backgroundImage: imageUrl.isNotEmpty
                                        ? (imageUrl.startsWith('http')
                                            ? NetworkImage(imageUrl)
                                            : FileImage(File(imageUrl)) as ImageProvider)
                                        : null,
                                    child: imageUrl.isEmpty
                                        ? const Icon(Icons.person, color: Colors.white, size: 40)
                                        : null,
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
                                  Text(
                                    "${Localization.text('target')} 2024",
                                    style: const TextStyle(
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
                  Text(
                    Localization.text('ringkasan'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _buildSummaryCard(
                        Localization.text('total_buku'),
                        totalBooks.toString(),
                        Icons.collections_bookmark,
                        const Color(0xFF6A5AE0).withOpacity(0.1),
                        const Color(0xFF6A5AE0),
                      ),
                      const SizedBox(width: 15),
                      _buildSummaryCard(
                        Localization.text('selesai'),
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
                  Text(
                    Localization.text('pengaturan'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
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
                            activeColor: Theme.of(context).colorScheme.primary,
                            onChanged: _toggleDarkMode,
                          ),
                        ),
                        _buildDivider(),
                        _buildSettingItem(
                          Icons.notifications_none,
                          Localization.text('notifikasi'),
                          trailing: Switch(
                            value: _isNotificationsEnabled,
                            activeColor: Theme.of(context).colorScheme.primary,
                            onChanged: _toggleNotifications,
                          ),
                        ),
                        _buildDivider(),
                        _buildSettingItem(
                          Icons.language,
                          Localization.text('bahasa'),
                          trailing: Text(
                            _selectedLanguage,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                          onTap: _showLanguageDialog,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  // Tentang
                  Text(
                    Localization.text('tentang'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSettingItem(
                          Icons.info_outline,
                          Localization.text('tentang'),
                          onTap: _showAboutDialog,
                          trailing: Text("v1.0.0",
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        ),
                        _buildDivider(),
                        _buildSettingItem(
                          Icons.help_outline,
                          Localization.text('bantuan'),
                          onTap: _showHelpDialog,
                        ),
                        _buildDivider(),
                        _buildSettingItem(
                          Icons.privacy_tip_outlined,
                          Localization.text('kebijakan'),
                          onTap: _showPrivacyPolicyDialog,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color bgColor, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Text(
                Localization.text('favorit'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              Text(
                category,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: trailing ?? Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 20,
      endIndent: 20,
      color: Theme.of(context).colorScheme.surfaceVariant,
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
