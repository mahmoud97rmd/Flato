import 'package:webview_flutter/webview_flutter.dart';

class WebViewErrorGuard {
  static void guard(WebViewController ctrl) {
    ctrl.setJavaScriptMode(JavaScriptMode.unrestricted);
    ctrl.addJavaScriptChannel(
      'ErrorGuard',
      onMessageReceived: (msg) {
        // ترسل أي خطأ أو تحذير
      },
    );
  }
}
