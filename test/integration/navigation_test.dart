import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Home -> Settings navigation", (tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text("Dashboard"), findsOneWidget);
    await tester.tap(find.text("Settings"));
    await tester.pumpAndSettle();
    expect(find.text("OANDA Settings"), findsOneWidget);
  });
}
