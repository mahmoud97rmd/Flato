import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonSettingsExporter {
  static Future<String> save(Map<String, dynamic> settings) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/settings_export.json');
    await file.writeAsString(settings.toString());
    return file.path;
  }

  static Future<Map<String, dynamic>> load(File file) async {
    final content = await file.readAsString();
    return Map<String, dynamic>.from(jsonDecode(content));
  }
}
