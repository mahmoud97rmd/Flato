import 'package:hive/hive.dart';

part 'replay_hive.g.dart';

@HiveType(typeId: 14)
class ReplayStateEntity extends HiveObject {
  @HiveField(0)
  final String symbol;

  @HiveField(1)
  final int lastIndex;

  ReplayStateEntity({required this.symbol, required this.lastIndex});
}
