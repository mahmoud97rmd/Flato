import 'package:webview_flutter/webview_flutter.dart';

class WebViewJSReadyGuard {
  static Future<void> evaluateWhenReady(
      WebViewController ctrl, String script) async {
    final ready = await ctrl
        .runJavascriptReturningResult("document.readyState === 'complete'");
    if (ready == '"complete"') {
      await ctrl.runJavascript(script);
    } else {
      ctrl.runJavascript(
          "document.addEventListener('DOMContentLoaded', function() { $script });");
    }
  }
}
