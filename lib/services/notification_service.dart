import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import '../models/book.dart';
import '../main.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
