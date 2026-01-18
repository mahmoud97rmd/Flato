import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_event.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_state.dart';
import 'package:mocktail/mocktail.dart';

class MockChartRepository extends Mock implements ChartRepository {}

void main() {
  group('ChartBloc', () {
    late MockChartRepository mockRepo;
    late ChartBloc chartBloc;

    setUp(() {
      mockRepo = MockChartRepository();
      chartBloc = ChartBloc(mockRepo, symbol: 'TEST', timeframe: 'M1');
    });

    blocTest<ChartBloc, ChartState>(
      'emits [ChartLoading, ChartLoaded] when data is fetched',
      build: () {
        when(() => mockRepo.getHistoricalCandles(
              symbol: any(named: 'symbol'),
              timeframe: any(named: 'timeframe'),
              count: any(named: 'count'),
            )).thenAnswer((_) async => []);
        return chartBloc;
      },
      act: (bloc) => bloc.add(LoadChartHistory(symbol: 'TEST', timeframe: 'M1')),
      expect: () => [isA<ChartLoading>(), isA<ChartLoaded>()],
    );
  });
}
