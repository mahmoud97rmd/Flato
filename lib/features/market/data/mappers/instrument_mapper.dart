import '../../domain/entities/instrument.dart';
import '../dtos/instrument_dto.dart';

class InstrumentMapper {
  static Instrument fromDto(InstrumentDTO dto) {
    return Instrument(
      name: dto.name,
      display: dto.name.replaceAll("_", ""),
      displayPrecision: dto.displayPrecision,
      tradeUnitsPrecision: dto.tradeUnitsPrecision,
    );
  }
}
