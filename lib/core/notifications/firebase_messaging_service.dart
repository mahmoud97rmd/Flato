import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    await _fcm.requestPermission();
    FirebaseMessaging.onMessage.listen((msg) {
      // Handle foreground
    });
  }

  Future<String?> getToken() => _fcm.getToken();
}
