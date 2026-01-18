import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:my_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/market/presentation/bloc/oanda/oanda_bloc.dart';

void main() {
  testWidgets("Home Page loads and shows buttons",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: HomePage()),
    );

    expect(find.text("Fetch OANDA Instruments"), findsOneWidget);
    expect(find.text("Settings"), findsOneWidget);
  });
}
