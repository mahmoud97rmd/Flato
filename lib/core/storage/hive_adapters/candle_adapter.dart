import 'package:hive/hive.dart';
import '../../features/market/domain/models/candle.dart';

part 'candle_adapter.g.dart';

@HiveType(typeId: 1)
class HiveCandle {
  @HiveField(0)
  final int time;

  @HiveField(1)
  final double open;

  @HiveField(2)
  final double high;

  @HiveField(3)
  final double low;

  @HiveField(4)
  final double close;

  HiveCandle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}

// Adapter Serializer
class HiveCandleAdapter extends TypeAdapter<HiveCandle> {
  @override
  final typeId = 1;

  @override
  HiveCandle read(BinaryReader reader) {
    return HiveCandle(
      time: reader.readInt(),
      open: reader.readDouble(),
      high: reader.readDouble(),
      low: reader.readDouble(),
      close: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveCandle obj) {
    writer.writeInt(obj.time);
    writer.writeDouble(obj.open);
    writer.writeDouble(obj.high);
    writer.writeDouble(obj.low);
    writer.writeDouble(obj.close);
  }
}
