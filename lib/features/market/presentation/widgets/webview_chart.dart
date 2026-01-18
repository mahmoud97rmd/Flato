import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewChart extends StatefulWidget {
  final Function(String) onCreated;
  WebViewChart({required this.onCreated});

  @override
  _WebViewChartState createState() => _WebViewChartState();
}

class _WebViewChartState extends State<WebViewChart> {
  late WebViewController webController;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'assets/chart.html',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (ctrl) {
        webController = ctrl;
        widget.onCreated("");
      },
    );
  }
}
