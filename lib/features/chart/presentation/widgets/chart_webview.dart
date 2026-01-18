import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartWebView extends StatefulWidget {
  final List<Map<String, dynamic>> candles;
  final List<Map<String, dynamic>> emaShort;
  final List<Map<String, dynamic>> emaLong;
  final List<Map<String, dynamic>> rsi;

  ChartWebView({
    required this.candles,
    required this.emaShort,
    required this.emaLong,
    required this.rsi,
  });

  @override
  _ChartWebViewState createState() => _ChartWebViewState();
}

class _ChartWebViewState extends State<ChartWebView> {
  late WebViewController _ctrl;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'about:blank',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) async {
        _ctrl = controller;
        await controller.loadFlutterAsset("assets/lightweight_charts/chart.html");
        _setInitialData();
      },
    );
  }

  void _setInitialData() {
    _runJs("setCandles(${widget.candles});");
    _runJs("setEmaShort(${widget.emaShort});");
    _runJs("setEmaLong(${widget.emaLong});");
    _runJs("setRsi(${widget.rsi});");
  }

  void updateLastCandle(Map<String, dynamic> candle) {
    _runJs("updateLastCandle($candle);");
  }

  void _runJs(String script) {
    _ctrl.runJavascript(script);
  }
}
