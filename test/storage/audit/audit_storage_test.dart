import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:your_app/core/storage/audit/audit_storage.dart';
import 'package:your_app/core/storage/audit/audit_hive.dart';

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.path);
    Hive.registerAdapter(AuditEntityAdapter());
  });

  test('log and retrieve audit event', () async {
    final storage = AuditStorage();
    final event = AuditEntity(time: DateTime.now(), type: "Test", message: "Hello");
    await storage.logEvent(event);

    final list = await storage.getEvents();
    expect(list.length, greaterThan(0));
  });
}
