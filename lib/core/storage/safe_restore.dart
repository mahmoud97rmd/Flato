import 'package:hive/hive.dart';

Future<void> safeRestore(String boxName) async {
  try {
    await Hive.openBox(boxName);
  } catch (err) {
    await Hive.deleteBoxFromDisk(boxName);
    await Hive.openBox(boxName);
  }
}
