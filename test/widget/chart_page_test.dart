import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/presentation/pages/interactive_chart_page.dart';

void main() {
  testWidgets('Chart Page loads and displays chart', (tester) async {
    await tester.pumpWidget(MaterialApp(home: InteractiveChartPage(symbol: 'XAU_USD')));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Chart — XAU_USD'), findsOneWidget);
  });
}
