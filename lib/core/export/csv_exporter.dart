import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CsvExporter {
  static Future<String> exportTrades(List<List<String>> rows) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/trades_export.csv');
    final sink = file.openWrite();
    for (var r in rows) sink.writeln(r.join(','));
    await sink.close();
    return file.path;
  }
}
