import 'package:hive_flutter/hive_flutter.dart';

import '../models/adapters/candle_entity_adapter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(CandleEntityAdapter());
}
