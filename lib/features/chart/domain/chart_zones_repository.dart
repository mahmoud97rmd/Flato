import 'package:hive/hive.dart';

class ChartZonesRepository {
  static Future<void> saveZone(int fromTs, int toTs, String color) async {
    final box = await Hive.openBox('chartZones');
    await box.add({'from': fromTs, 'to': toTs, 'color': color});
  }

  static Future<List<Map>> getZones() async {
    final box = await Hive.openBox('chartZones');
    return box.values.cast<Map>().toList();
  }
}
