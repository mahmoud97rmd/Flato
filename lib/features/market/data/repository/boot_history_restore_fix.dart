import '../../../../core/models/candle_entity.dart';
import '../local/candle_dao.dart';

class BootHistoryRestoreFix {
  final CandleDao dao;
  BootHistoryRestoreFix(this.dao);

  Future<List<CandleEntity>> restoreOnBoot(String symbol, String tf) async {
    final cached = await dao.getAll(symbol, tf);
    return cached.isEmpty ? [] : cached;
  }
}
