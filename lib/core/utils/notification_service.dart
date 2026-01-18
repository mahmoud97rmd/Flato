import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifier = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    final androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    final initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notifier.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // handle notification tapped logic if needed
      },
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'trade_channel',
      'Trade Notifications',
      channelDescription: 'Notifications for trade signals and events',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifier.show(id, title, body, details);
  }
}
