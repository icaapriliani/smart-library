import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import '../models/book.dart';
import '../models/notification_item.dart';
import '../main.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final ValueNotifier<List<NotificationItem>> notificationsListNotifier = ValueNotifier([]);

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);
    tz.initializeTimeZones();
  }

  void updateNotificationCount(List<Book> books) {
    if (!notificationsNotifier.value) {
      notificationCountNotifier.value = 0;
      return;
    }

    int count = 0;
    
    // 1. Buku progress belum selesai (Reading)
    final unfinishedBooks = books.where((b) => b.status == "Reading").length;
    count += unfinishedBooks;

    // 2. Buku baru yang belum dibaca (New)
    final newBooks = books.where((b) => b.status == "New").length;
    count += newBooks;

    // 3. Target membaca belum tercapai (misal target 10 buku)
    final doneBooks = books.where((b) => b.status == "Done").length;
    if (doneBooks < 10) {
      count += 1; // 1 notif untuk pengingat target
    }

    notificationCountNotifier.value = count;
    _generateNotificationItems(books);
  }

  void _generateNotificationItems(List<Book> books) {
    if (!notificationsNotifier.value) {
      notificationsListNotifier.value = [];
      return;
    }

    List<NotificationItem> items = [];

    // 1. Reading Progress
    final readingBooks = books.where((b) => b.status == "Reading").toList();
    if (readingBooks.isNotEmpty) {
      items.add(NotificationItem(
        title: Localization.text('reading_progress'),
        message: readingBooks.first.title,
        time: Localization.text('just_now'),
      ));
    }

    // 2. Unfinished Count
    if (readingBooks.length > 1) {
      items.add(NotificationItem(
        title: "${readingBooks.length} ${Localization.text('unfinished_msg')}",
        message: Localization.text('notif_welcome'),
        time: Localization.text('hour_ago'),
      ));
    }

    // 3. Target
    final doneBooks = books.where((b) => b.status == "Done").length;
    if (doneBooks < 10) {
      items.add(NotificationItem(
        title: Localization.text('target_msg'),
        message: "$doneBooks / 10 Buku",
        time: Localization.text('today'),
      ));
    }

    // 4. Favorite
    final favBooks = books.where((b) => b.isFavorite && b.status != "Done").toList();
    if (favBooks.isNotEmpty) {
      items.add(NotificationItem(
        title: Localization.text('fav_msg'),
        message: favBooks.first.title,
        time: Localization.text('today'),
      ));
    }

    notificationsListNotifier.value = items;
  }

  void markAllAsRead() {
    notificationCountNotifier.value = 0;
    // Optional: update items if we track per-item read status
    notificationsListNotifier.value = notificationsListNotifier.value.map((e) => NotificationItem(
      title: e.title,
      message: e.message,
      time: e.time,
      isRead: true,
    )).toList();
  }

  Future<void> scheduleDailyReminder() async {
    if (!notificationsNotifier.value) return;

    await flutterLocalNotificationsPlugin.show(
      id: 100,
      title: Localization.text('notif_title'),
      body: Localization.text('notif_body'),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminders',
          channelDescription: 'Daily reading reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
