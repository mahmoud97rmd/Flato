import 'dart:io';

class TransactionalFileSaver {
  static Future<void> safeWrite(String path, String data) async {
    final temp = File(path + ".tmp");
    await temp.writeAsString(data);
    final original = File(path);
    await temp.rename(original.path);
  }
}
