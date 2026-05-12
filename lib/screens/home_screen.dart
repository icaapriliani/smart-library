import 'package:flutter/material.dart';
import '../main.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import 'add_book_screen.dart';
import 'detail_book_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import '../services/notification_service.dart';
import '../models/notification_item.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChange;
  final List<String> categories;
  final List<Book> books;
  final VoidCallback onBooksUpdated;

  const HomeScreen({
    required this.onTabChange,
    super.key,
    required this.books,
    required this.categories,
    required this.onBooksUpdated,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";
  String selectedStatus = "All";
  static bool _hasShownSnackbar = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowNotification();
      _updateCount();
    });
  }

  void _checkAndShowNotification() {
    if (notificationsNotifier.value && !_hasShownSnackbar) {
      _showTopNotification();
      _hasShownSnackbar = true;
    }
  }

  void _showTopNotification() {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: -100.0, end: 0.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF6A5AE0)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      Localization.text('notif_welcome'),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                    onPressed: () => overlayEntry.remove(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  void _updateCount() {
    NotificationService().updateNotificationCount(widget.books);
  }

  void _showNotificationCenter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Localization.text('notif_center'),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      NotificationService().markAllAsRead();
                    },
                    icon: const Icon(Icons.done_all, size: 18),
                    label: Text(Localization.text('mark_read')),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ValueListenableBuilder<List<NotificationItem>>(
                valueListenable: NotificationService().notificationsListNotifier,
                builder: (context, notifications, _) {
                  if (notifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none, size: 80, color: Colors.grey.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Text(
                            Localization.text('no_notif'),
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                          border: notif.isRead ? null : Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              child: Icon(Icons.notifications, color: Theme.of(context).colorScheme.primary, size: 20),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          notif.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        notif.time,
                                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notif.message,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getStatus(int progress) {
    if (progress == 100) return "Done";
    if (progress > 0) return "Reading";
    return "New";
  }

  Future<void> saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookList = widget.books
        .map(
          (book) => {
            "title": book.title,
            "author": book.author,
            "rating": book.rating,
            "progress": book.progress,
            "status": book.status,
            "image": book.image,
            "category": book.category,
            "year": book.year,
            "pages": book.pages,
            "language": book.language,
            "description": book.description,
            "isFavorite": book.isFavorite,
          },
        )
        .toList();
    prefs.setString("books", jsonEncode(bookList));
  }

  Future<void> loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("books");

    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        widget.books.clear();
        widget.books.addAll(decoded.map(
          (item) => Book(
            title: item["title"],
            author: item["author"],
            rating: item["rating"].toDouble(),
            progress: item["progress"],
            status: item["status"],
            image: item["image"],
            category: item["category"] ?? "Lainnya",
            year: item["year"] ?? 0,
            pages: item["pages"] ?? 0,
            language: item["language"] ?? "Indonesia",
            description: item["description"] ?? "",
            isFavorite: item["isFavorite"] ?? false,
          ),
        ));
      });
    }
  }

  Widget buildStatItem(IconData icon, String title, int value) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 6),
        Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String status) {
    final isSelected = selectedStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onSelected: (_) {
          setState(() {
            selectedStatus = status;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, _) {
        final books = widget.books;
        final filteredBooks = books.where((book) {
          final matchsearch = book.title.toLowerCase().contains(searchQuery.toLowerCase()) || book.author.toLowerCase().contains(searchQuery.toLowerCase());
          final matchstatus = selectedStatus == "All" || book.status == selectedStatus;

          return matchsearch && matchstatus;
        }).toList();

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder<String>(
                          valueListenable: userNameNotifier,
                          builder: (context, name, _) {
                            return Text(
                              "Halo, $name",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                        Text(
                          "Mau baca apa hari ini?",
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: notificationsNotifier,
                          builder: (context, isEnabled, _) {
                            if (!isEnabled) return const SizedBox.shrink();
                            return ValueListenableBuilder<int>(
                              valueListenable: notificationCountNotifier,
                              builder: (context, count, _) {
                                return Stack(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.notifications_outlined, size: 28),
                                      onPressed: _showNotificationCenter,
                                    ),
                                    if (count > 0)
                                      Positioned(
                                        right: 8,
                                        top: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 16,
                                            minHeight: 16,
                                          ),
                                          child: Text(
                                            count > 9 ? '9+' : '$count',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        ValueListenableBuilder<String>(
                          valueListenable: userImageNotifier,
                          builder: (context, imageUrl, _) {
                            return CircleAvatar(
                              radius: 24,
                              backgroundImage: imageUrl.isNotEmpty
                                  ? (imageUrl.startsWith('http') ? NetworkImage(imageUrl) : FileImage(File(imageUrl)) as ImageProvider)
                                  : null,
                              child: imageUrl.isEmpty ? const Icon(Icons.person) : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Search Bar
                TextField(
                  onChanged: (val) => setState(() => searchQuery = val),
                  decoration: InputDecoration(
                    hintText: Localization.text('cari'),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(Localization.text('semua'), "All"),
                      _buildFilterChip(Localization.text('baru'), "New"),
                      _buildFilterChip(Localization.text('membaca'), "Reading"),
                      _buildFilterChip(Localization.text('selesai'), "Done"),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // List Buku
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      final realIndex = books.indexOf(book);

                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailBookScreen(
                                    book: book,
                                    index: realIndex,
                                    categories: widget.categories,
                                  ),
                                ),
                              );

                              if (result != null) {
                                if (result["delete"] == true) {
                                  setState(() {
                                    books.removeAt(result["index"]);
                                  });
                                  saveBooks();
                                  widget.onBooksUpdated();
                                  _updateCount();
                                } else if (result["updatedBook"] != null) {
                                  setState(() {
                                    final updated = result["updatedBook"];
                                    books[result["index"]] = Book(
                                      title: updated["title"],
                                      author: updated["author"],
                                      rating: updated["rating"].toDouble(),
                                      progress: updated["progress"],
                                      status: updated["status"],
                                      category: updated["category"],
                                      year: updated["year"] ?? book.year,
                                      pages: updated["pages"] ?? book.pages,
                                      language: updated["language"] ?? book.language,
                                      description: updated["description"] ?? book.description,
                                      image: updated["image"] ?? book.image,
                                      isFavorite: updated["isFavorite"] ?? book.isFavorite,
                                    );
                                  });
                                  saveBooks();
                                  widget.onBooksUpdated();
                                  _updateCount();
                                }
                              }
                            },
                            child: BookCard(book: book),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: Icon(
                                book.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: book.isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  book.isFavorite = !book.isFavorite;
                                });
                                saveBooks();
                                widget.onBooksUpdated();
                                _updateCount();
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Statistic Card
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A5AE0), Color(0xFF8E7CFF)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Localization.text('statistik_membaca'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.onTabChange(2);
                            },
                            child: const Text(
                              "Lihat Detail",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildStatItem(Icons.book, Localization.text('total_buku'), books.length),
                          buildStatItem(Icons.hourglass_empty, Localization.text('membaca'), books.where((b) => b.status == "Reading").length),
                          buildStatItem(Icons.check_circle, Localization.text('selesai'), books.where((b) => b.status == "Done").length),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBookScreen(categories: widget.categories)),
              );
              if (result != null) {
                setState(() {
                  final progress = result["progress"] ?? 0;
                  books.add(
                    Book(
                      title: result["title"],
                      author: result["author"],
                      rating: result["rating"]?.toDouble() ?? 0.0,
                      progress: progress,
                      status: getStatus(progress),
                      image: result["image"] ?? "",
                      category: result["category"] ?? "Lainnya",
                      year: result["year"] ?? 0,
                      pages: result["pages"] ?? 0,
                      language: result["language"] ?? "Indonesia",
                      description: result["description"] ?? "",
                    ),
                  );
                });
                saveBooks();
                widget.onBooksUpdated();
                _updateCount();
              }
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}
