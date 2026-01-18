import '../../domain/entities/candle.dart';
import '../dtos/candle_dto.dart';

class CandleMapper {
  static Candle fromDto(CandleDTO dto) {
    final priceSource = dto.mid ?? dto.bid ?? dto.ask;
    if (priceSource == null) {
      throw FormatException("Invalid CandleDTO: no price fields");
    }

    final open = double.parse(priceSource["o"].toString());
    final high = double.parse(priceSource["h"].toString());
    final low = double.parse(priceSource["l"].toString());
    final close = double.parse(priceSource["c"].toString());

    return Candle(
      time: DateTime.parse(dto.time),
      open: open,
      high: high,
      low: low,
      close: close,
      volume: dto.volume,
    );
  }
}
