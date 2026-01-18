import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SLTPStorageFix {
  static Future<void> save(String symbol, double sl, double tp) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'sl_tp_$symbol',
      jsonEncode({'sl': sl, 'tp': tp}),
    );
  }

  static Future<Map<String, double>?> load(String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString('sl_tp_$symbol');
    if (str == null) return null;
    final map = jsonDecode(str) as Map<String, dynamic>;
    return {
      'sl': (map['sl'] as num).toDouble(),
      'tp': (map['tp'] as num).toDouble(),
    };
  }
}
