import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_event.dart';
import 'package:your_app/market/data/repositories/market_repository.dart';
import 'package:your_app/core/network/rest_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ChartBloc integration test', (tester) async {
    final repo = MarketRepository(RestClient("fakeToken","https://fake.url"));
    final bloc = ChartBloc(repo);

    bloc.add(LoadChartData(symbol: "EUR_USD", timeframe: "M1"));
    await tester.pumpAndSettle();
    expect(bloc.state, isNot(isA<ChartError>()));
  });
}
