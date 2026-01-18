import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_event.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_state.dart';
import 'package:your_app/market/data/repositories/market_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockMarketRepo extends Mock implements MarketRepository {}

void main() {
  group('ChartBloc', () {
    late ChartBloc bloc;
    late MockMarketRepo repo;

    setUp(() {
      repo = MockMarketRepo();
      bloc = ChartBloc(repo);
    });

    blocTest<ChartBloc, ChartState>(
      'emits ChartLoaded on successful LoadChart',
      build: () {
        when(() => repo.getHistoricalCandles(symbol: any(named: 'symbol'),
            timeframe: any(named: 'timeframe')))
            .thenAnswer((_) async => []);
        return bloc;
      },
      act: (b) => b.add(LoadChart(symbol: 'EU', timeframe: 'M1')),
      expect: () => [isA<ChartLoading>(), isA<ChartLoaded>()],
    );
  });
}
