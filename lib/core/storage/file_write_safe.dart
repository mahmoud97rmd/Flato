import 'dart:io';

class FileWriteSafe {
  static Future<void> save(String path, String content) async {
    final tmp = File("$path.tmp");
    await tmp.writeAsString(content);
    final original = File(path);
    if (await original.exists()) {
      await original.delete();
    }
    await tmp.rename(path);
  }
}
