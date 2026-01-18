import 'package:hive/hive.dart';

part 'indicator_hive.g.dart';

@HiveType(typeId: 13)
class IndicatorSettingsEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final Map<String, dynamic> params;

  IndicatorSettingsEntity({
    required this.id,
    required this.params,
  });
}
