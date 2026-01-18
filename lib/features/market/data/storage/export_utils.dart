import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/backtest/backtest_result.dart';

class ExportUtils {
  // حفظ كـ JSON
  static Future<String> exportBacktestJSON(BacktestResult result) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/backtest_result.json");
    await file.writeAsString(result.toJson());
    return file.path;
  }

  // حفظ كـ CSV
  static Future<String> exportBacktestCSV(BacktestResult result) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/backtest_result.csv");
    final buffer = StringBuffer();

    buffer.writeln("Time,Equity");
    for (int i = 0; i < result.timestamps.length; i++) {
      buffer.writeln(
          "${result.timestamps[i].toIso8601String()},${result.equityCurve[i]}");
    }

    await file.writeAsString(buffer.toString());
    return file.path;
  }

  static Future<void> shareFile(String path) async {
    await Share.shareFiles([path]);
  }
}
