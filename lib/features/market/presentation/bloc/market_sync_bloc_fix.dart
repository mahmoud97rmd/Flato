import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/market_repository.dart';

class MarketSyncBloc extends Cubit<bool> {
  final MarketRepository repo;

  MarketSyncBloc(this.repo) : super(false);

  Future<void> init(String symbol, String timeframe) async {
    await repo.getCandles(symbol, timeframe);
    emit(true); // جاهز لبث اللحظي
  }
}
