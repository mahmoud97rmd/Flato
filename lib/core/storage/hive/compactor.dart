import 'package:hive/hive.dart';

Future<void> compactIfNeeded(Box box) async {
  if (box.length > 1000) {
    await box.compact();
  }
}
