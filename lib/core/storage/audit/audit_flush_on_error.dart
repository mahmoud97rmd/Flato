import 'event_audit_manager3.dart';

Future<void> flushAuditOnError() async {
  final events = await EventAuditManager3.getAllSorted();
  for (var e in events) {
    //  ضمان الحفظ النهائي (مثال عمليات إضافية)
  }
}
