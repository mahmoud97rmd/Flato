import 'package:hive/hive.dart';

part 'audit_hive.g.dart';

@HiveType(typeId: 12)
class AuditEntity extends HiveObject {
  @HiveField(0)
  final DateTime time;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final String message;

  AuditEntity({
    required this.time,
    required this.type,
    required this.message,
  });
}
