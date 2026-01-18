import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/market/presentation/bloc/trading/trading_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/trading/trading_event.dart';
import 'package:your_app/features/market/presentation/bloc/trading/trading_state.dart';
import 'package:your_app/market/data/repositories/trading_repository.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../market/domain/backtest/backtest_models.dart';

class MockTradingRepo extends Mock implements TradingRepository {}

void main() {
  late MockTradingRepo mockRepo;

  setUp(() {
    mockRepo = MockTradingRepo();
  });

  blocTest<TradingBloc, TradingState>(
    'emits OrderSuccess and PositionsLoaded on successful PlaceOrder',
    build: () {
      when(() => mockRepo.placeOrder(
          instrument: any(named: 'instrument'),
          side: any(named: 'side'),
          price: any(named: 'price'),
          size: any(named: 'size')))
          .thenAnswer((_) async => <Position>[]);

      return TradingBloc(mockRepo);
    },
    act: (bloc) => bloc.add(PlaceOrder(
      instrument: "EUR_USD",
      side: OrderSide.buy,
      price: 1.1,
      size: 1.0,
    )),
    expect: () => [
      isA<TradingLoading>(),
      isA<TradingOrderSuccess>(),
      isA<TradingPositionsLoaded>(),
    ],
  );
}
