import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/features/chart/presentation/widgets/chart_webview.dart';

void main() {
  testWidgets("ChartWebView widget builds", (tester) async {
    final mockData = [
      {"time": 1, "open": 1, "high": 1, "low": 1, "close": 1}
    ];
    await tester.pumpWidget(ChartWebView(
      candles: mockData,
      emaShort: [],
      emaLong: [],
      rsi: [],
    ));
    await tester.pumpAndSettle();
    expect(find.byType(ChartWebView), findsOneWidget);
  });
}
