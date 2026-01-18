import 'package:hive/hive.dart';

Future<void> performMigration(Box box, int fromVersion, int toVersion) async {
  if (fromVersion < 2 && toVersion >= 2) {
    // نقل بيانات أو تحديث schema
    final all = box.toMap();
    for (var k in all.keys) {
      final entry = all[k];
      if (entry is Map && !entry.containsKey('volume')) {
        entry['volume'] = '0';
        await box.put(k, entry);
      }
    }
  }
}
