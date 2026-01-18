import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageUsageMonitor {
  Future<int> calculateUsedBytes() async {
    final dir = await getApplicationDocumentsDirectory();
    int total = 0;
    await for (var file in dir.list(recursive: true)) {
      if (file is File) {
        total += await file.length();
      }
    }
    return total;
  }
}
