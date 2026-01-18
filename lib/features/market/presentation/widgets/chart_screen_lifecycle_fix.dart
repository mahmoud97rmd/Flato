import 'package:flutter/material.dart';
import 'chart_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  WebViewController? _controller;

  @override
  void dispose() {
    _controller = null; // يسمح بالـGC بإنهاء WebView
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      onWebViewCreated: (ctrl) => _controller = ctrl,
      initialUrl: "about:blank",
    );
  }
}
