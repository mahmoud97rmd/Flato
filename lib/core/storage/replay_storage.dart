import 'package:hive/hive.dart';

part 'replay_storage.g.dart';

@HiveType(typeId: 5)
class ReplayStateEntity extends HiveObject {
  @HiveField(0)
  final String symbol;
  @HiveField(1)
  final String timeframe;
  @HiveField(2)
  final int lastIndex;

  ReplayStateEntity({
    required this.symbol,
    required this.timeframe,
    required this.lastIndex,
  });
}
