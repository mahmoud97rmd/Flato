import 'package:webview_flutter/webview_flutter.dart';

class WebViewControllerCleanupFix {
  void disposeController(WebViewController? ctrl) {
    ctrl = null;
  }
}
