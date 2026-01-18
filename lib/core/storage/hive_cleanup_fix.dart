import 'package:hive/hive.dart';

Future<void> closeAllHiveBoxes() async {
  for (var box in Hive.boxes.values) {
    if (box.isOpen) {
      await box.close();
    }
  }
}
