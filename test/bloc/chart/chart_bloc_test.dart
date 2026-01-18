import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_event.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_state.dart';
import 'package:your_app/market/data/repositories/market_repository.dart';
import 'package:mocktail/mocktail.dart';
import '../../../mocks.dart';
import '../../../../core/models/candle_entity.dart';

class MockMarketRepo extends Mock implements MarketRepository {}

void main() {
  late MockMarketRepo mockRepo;

  setUp(() {
    mockRepo = MockMarketRepo();
  });

  blocTest<ChartBloc, ChartState>(
    'emits [ChartLoading, ChartLoaded] when candles returned',
    build: () {
      when(() => mockRepo.getHistoricalCandles(symbol: any(named: "symbol"), timeframe: any(named: "timeframe")))
          .thenAnswer((_) async => [
                CandleEntity(
                    instrument: "EUR_USD",
                    timeUtc: DateTime.utc(2025, 1, 1, 0, 0),
                    open: 1.0,
                    high: 2.0,
                    low: 0.9,
                    close: 1.5,
                    volume: 1),
              ]);
      return ChartBloc(mockRepo);
    },
    act: (bloc) => bloc.add(LoadChartData(symbol: "EUR_USD", timeframe: "M1")),
    expect: () => [
      isA<ChartLoading>(),
      isA<ChartLoaded>(),
    ],
  );
}
