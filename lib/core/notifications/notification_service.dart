import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _flutterNotif = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _flutterNotif.initialize(settings);
  }

  Future<void> show(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      "channel_id",
      "channel_name",
      importance: Importance.max,
    );
    await _flutterNotif.show(0, title, body, NotificationDetails(android: androidDetails));
  }
}
