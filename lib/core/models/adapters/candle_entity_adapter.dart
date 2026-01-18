import 'package:hive/hive.dart';
import '../candle_entity.dart';

class CandleEntityAdapter extends TypeAdapter<CandleEntity> {
  @override
  final typeId = 1;

  @override
  CandleEntity read(BinaryReader reader) {
    return CandleEntity(
      timeUtc: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      open: reader.readDouble(),
      high: reader.readDouble(),
      low: reader.readDouble(),
      close: reader.readDouble(),
      volume: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, CandleEntity obj) {
    writer.writeInt(obj.timeUtc.millisecondsSinceEpoch);
    writer.writeDouble(obj.open);
    writer.writeDouble(obj.high);
    writer.writeDouble(obj.low);
    writer.writeDouble(obj.close);
    writer.writeDouble(obj.volume);
  }
}
