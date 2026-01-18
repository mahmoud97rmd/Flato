import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'candle_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class CandleModel {
  @HiveField(0)
  final DateTime time;

  @HiveField(1)
  final double open;
  
  @HiveField(2)
  final double high;
  
  @HiveField(3)
  final double low;
  
  @HiveField(4)
  final double close;
  
  @HiveField(5)
  final int volume;

  CandleModel({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory CandleModel.fromJson(Map<String, dynamic> json) => _$CandleModelFromJson(json);
  Map<String, dynamic> toJson() => _$CandleModelToJson(this);
}
