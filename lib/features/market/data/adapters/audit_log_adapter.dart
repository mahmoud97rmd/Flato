import 'package:hive/hive.dart';
import '../../../domain/audit/audit_log.dart';

class AuditLogAdapter extends TypeAdapter<AuditLog> {
  @override
  final typeId = 1;

  @override
  AuditLog read(BinaryReader reader) {
    final json = reader.readString();
    return AuditLog.fromJson(Map<String, dynamic>.from(jsonDecode(json)));
  }

  @override
  void write(BinaryWriter writer, AuditLog obj) {
    writer.writeString(jsonEncode(obj.toJson()));
  }
}
