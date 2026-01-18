import '../notifications/firebase_messaging_service.dart';

class WebhookPushBridge {
  final FirebaseMessagingService fcm;

  WebhookPushBridge(this.fcm);

  Future<void> sendPushOnWebhook(Map<String, dynamic> body) async {
    final token = await fcm.getToken();
    if (token != null) {
      // تنفيذ POST لFCM API (Server Side)
    }
  }
}
