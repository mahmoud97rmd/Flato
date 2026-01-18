import '../../../../core/models/candle_entity.dart';
import '../local/candle_dao.dart';

class InstantFirstCandleFix {
  final CandleDao dao;
  InstantFirstCandleFix(this.dao);

  Future<CandleEntity?> getLastKnown(String symbol, String tf) async {
    return await dao.getLastCandle(symbol, tf);
  }
}
