import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("App Launch and Navigate", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    expect(find.text("Dashboard"), findsOneWidget);

    await tester.tap(find.text("Settings"));
    await tester.pumpAndSettle();
    expect(find.text("OANDA Settings"), findsOneWidget);
  });
}
