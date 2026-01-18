import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:my_app/features/market/presentation/bloc/market/market_bloc.dart';
import 'package:my_app/features/market/presentation/bloc/market/market_state.dart';
import 'package:my_app/features/market/presentation/bloc/market/market_event.dart';
import 'package:my_app/features/market/data/market_repository.dart';
import 'package:my_app/core/network/rest/rest_client.dart';
import 'package:my_app/features/market/domain/streaming/live_stream_adapter.dart';

class FakeRepo extends MarketRepository {
  @override
  Future<List> getCandlesCached(
      String accountId, String instrument, String timeframe) async {
    return [];
  }
}

void main() {
  blocTest<MarketBloc, MarketState>(
    'MarketBloc load history',
    build: () => MarketBloc(FakeRepo(), LiveStreamAdapter()),
    act: (bloc) => bloc.add(LoadHistory("acc", "SYM", "M1")),
    expect: () => [isA<MarketLoadingHistory>(), isA<MarketHistoryReady>()],
  );
}
