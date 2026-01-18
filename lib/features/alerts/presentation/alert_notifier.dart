import '../../../core/widgets/notification_toast.dart';
import '../../../core/audio/alert_sound.dart';

class AlertNotifier {
  final _sound = AlertSound();

  void trigger(String message) {
    NotificationToast.show(message);
    _sound.playBuy(); // مثال: صوت موحد
  }
}
