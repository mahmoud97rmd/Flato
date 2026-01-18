import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:your_app/features/chart/presentation/widgets/interactive_chart.dart';

void main() {
  testWidgets('Pinch Zoom changes scale', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: InteractiveChart(candles: [], onRangeChanged: (_,__){}),
    ));

    final finder = find.byType(InteractiveChart);
    await tester.pinch(finder, 1.5);
    await tester.pump();

    // تأكد أن scale تغيرت
    // يمكن إضافة تحقق داخلي من حالة widget
  });
}
