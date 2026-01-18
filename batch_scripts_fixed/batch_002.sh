#!/bin/bash
# Batch 2 of 2
# Commands: 873 (Flutter commands filtered out)
set -e  # Stop on error

echo "🚀 Batch 2/2 - 873 commands (No Flutter)"
date

# Create files (Flutter-free)
cat > pubspec.yaml << 'EOF'
name: flutter_trading_app
description: تطبيق تداول مالي احترافي مبني بــ Flutter + Dart
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ">=2.20.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.0
  equatable: ^2.0.5

  # HTTP & WebSocket
  dio: ^5.0.0
  web_socket_channel: ^2.2.0

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # JSON serialization
  json_annotation: ^4.8.0

  # Charts
  fl_chart: ^0.60.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.4
  json_serializable: ^6.6.1
EOF
cat > lib/features/market/data/models/candle_model.dart << 'EOF'
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'candle_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class CandleModel {
  @HiveField(0)
  final DateTime time;

  @HiveField(1)
  final double open;
  
  @HiveField(2)
  final double high;
  
  @HiveField(3)
  final double low;
  
  @HiveField(4)
  final double close;
  
  @HiveField(5)
  final int volume;

  CandleModel({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory CandleModel.fromJson(Map<String, dynamic> json) => _$CandleModelFromJson(json);
  Map<String, dynamic> toJson() => _$CandleModelToJson(this);
}
EOF
cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/market/data/models/candle_model.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CandleModelAdapter());

  await Hive.openBox<CandleModel>('candles');

  runApp(MyApp());
}
EOF
cat > lib/app.dart << 'EOF'
import 'package:flutter/material.dart';
import 'features/market/presentation/pages/home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trading App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
EOF
cat > lib/features/market/presentation/pages/home_page.dart << 'EOF'
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trading App")),
      body: Center(child: Text("مرحبا بك في تطبيق التداول")),
    );
  }
}
EOF
cat > lib/features/market/domain/entities/candle.dart << 'EOF'
class CandleEntity {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  CandleEntity({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
}
EOF
cat > lib/features/market/domain/entities/tick.dart << 'EOF'
class TickEntity {
  final DateTime time;
  final double bid;
  final double ask;

  TickEntity({
    required this.time,
    required this.bid,
    required this.ask,
  });
}
EOF
cat > lib/features/market/domain/repositories/market_repository.dart << 'EOF'
import '../entities/candle.dart';
import '../entities/tick.dart';

abstract class MarketRepository {
  /// REST: جلب بيانات الشموع التاريخية
  Future<List<CandleEntity>> fetchHistoricalCandles(
      String instrument, String granularity, int count);

  /// REST: جلب كل الأسواق المتاحة من الـ OANDA
  Future<List<String>> fetchAvailableInstruments();

  /// WebSocket: بث Live Ticks
  Stream<TickEntity> streamTicks(String instrument);

  /// REST: جلب معلومات حساب OANDA
  Future<Map<String, dynamic>> fetchAccountDetails();

  /// حفظ بيانات اتصال OANDA (Token + Account ID)
  Future<void> saveOandaCredentials({
    required String token,
    required String accountId,
  });

  /// قراءة بيانات OANDA المخزنة
  Future<Map<String, String>> getOandaCredentials();
}
EOF
cat > lib/features/market/domain/usecases/get_historical_candles.dart << 'EOF'
import '../entities/candle.dart';
import '../repositories/market_repository.dart';

class GetHistoricalCandles {
  final MarketRepository repository;

  GetHistoricalCandles(this.repository);

  Future<List<CandleEntity>> call({
    required String instrument,
    required String granularity,
    required int count,
  }) async {
    return await repository.fetchHistoricalCandles(
      instrument, granularity, count);
  }
}
EOF
cat > lib/features/market/domain/usecases/get_available_instruments.dart << 'EOF'
import '../repositories/market_repository.dart';

class GetAvailableInstruments {
  final MarketRepository repository;

  GetAvailableInstruments(this.repository);

  Future<List<String>> call() async {
    return await repository.fetchAvailableInstruments();
  }
}
EOF
cat > lib/features/market/domain/usecases/stream_ticks.dart << 'EOF'
import '../entities/tick.dart';
import '../repositories/market_repository.dart';

class StreamTicks {
  final MarketRepository repository;

  StreamTicks(this.repository);

  Stream<TickEntity> call(String instrument) {
    return repository.streamTicks(instrument);
  }
}
EOF
cat > lib/features/market/domain/usecases/save_oanda_credentials.dart << 'EOF'
import '../repositories/market_repository.dart';

class SaveOandaCredentials {
  final MarketRepository repository;

  SaveOandaCredentials(this.repository);

  Future<void> call({
    required String token,
    required String accountId,
  }) async {
    return repository.saveOandaCredentials(
      token: token,
      accountId: accountId,
    );
  }
}
EOF
cat > lib/features/market/domain/usecases/get_saved_credentials.dart << 'EOF'
import '../repositories/market_repository.dart';

class GetSavedCredentials {
  final MarketRepository repository;

  GetSavedCredentials(this.repository);

  Future<Map<String, String>> call() async {
    return await repository.getOandaCredentials();
  }
}
EOF
cat > lib/features/market/data/datasources/oanda_rest_client.dart << 'EOF'
import 'package:dio/dio.dart';

class OandaRestClient {
  Dio dio;

  OandaRestClient(String token) : dio = Dio(
    BaseOptions(
      baseUrl: "https://api-fxpractice.oanda.com/v3",
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      }
    ),
  );

  Future<Response> getInstruments(String accountId) async {
    return dio.get("/accounts/$accountId/instruments");
  }

  Future<Response> getCandles({
    required String instrument,
    required String granularity,
    required int count,
  }) {
    return dio.get(
      "/instruments/$instrument/candles",
      queryParameters: {
        "granularity": granularity,
        "count": count,
        "price": "M",
      }
    );
  }
}
EOF
cat > lib/features/market/data/datasources/oanda_ws_client.dart << 'EOF'
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class OandaWebSocketClient {
  final WebSocketChannel _channel;

  OandaWebSocketClient._(this._channel);

  factory OandaWebSocketClient({
    required String token,
    required String accountId,
    required String instrument,
  }) {
    final streamEndpoint = Uri(
      scheme: "wss",
      host: "stream-fxpractice.oanda.com",
      path: "/v3/pricing/stream",
      queryParameters: {
        "instruments": instrument,
      },
    );

    final ws = WebSocketChannel.connect(
      streamEndpoint,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return OandaWebSocketClient._(ws);
  }

  Stream<Map<String, dynamic>> get stream =>
      _channel.stream.map((event) => jsonDecode(event));

  void close() => _channel.sink.close();
}
EOF
cat > lib/features/market/data/models/candle_entity_mapper.dart << 'EOF'
import '../../domain/entities/candle.dart';
import 'candle_model.dart';

extension ToEntity on CandleModel {
  CandleEntity toEntity() {
    return CandleEntity(
      time: time,
      open: open,
      high: high,
      low: low,
      close: close,
      volume: volume,
    );
  }
}
EOF
cat > lib/features/market/data/models/tick_model.dart << 'EOF'
import '../../domain/entities/tick.dart';

class TickModel {
  final DateTime time;
  final double bid;
  final double ask;

  TickModel({
    required this.time,
    required this.bid,
    required this.ask,
  });

  factory TickModel.fromJson(Map<String, dynamic> json) {
    // OANDA stream sends "tick" messages with bid/ask
    final time = DateTime.parse(json["time"]);
    final bids = json["bids"];
    final asks = json["asks"];

    double bidPrice = double.parse(bids[0]["price"]);
    double askPrice = double.parse(asks[0]["price"]);

    return TickModel(
      time: time,
      bid: bidPrice,
      ask: askPrice,
    );
  }

  TickEntity toEntity() => TickEntity(
    time: time,
    bid: bid,
    ask: ask,
  );
}
EOF
cat > lib/features/market/data/datasources/local_storage.dart << 'EOF'
import 'package:hive/hive.dart';

class LocalStorage {
  final Box _box = Hive.box('settings');

  Future<void> saveOandaToken(String token) async {
    await _box.put('oanda_token', token);
  }

  Future<void> saveOandaAccountId(String id) async {
    await _box.put('oanda_account', id);
  }

  String? getOandaToken() => _box.get('oanda_token');

  String? getOandaAccountId() => _box.get('oanda_account');
}
EOF
cat > lib/features/market/data/repositories/market_repository_impl.dart << 'EOF'
import 'dart:async';

import '../../domain/entities/candle.dart';
import '../../domain/entities/tick.dart';
import '../../domain/repositories/market_repository.dart';

import '../datasources/oanda_rest_client.dart';
import '../datasources/oanda_ws_client.dart';
import '../datasources/local_storage.dart';
import '../models/candle_model.dart';
import '../models/candle_entity_mapper.dart';
import '../models/tick_model.dart';

class MarketRepositoryImpl implements MarketRepository {
  final LocalStorage localStorage;

  OandaRestClient? _restClient;
  OandaWebSocketClient? _wsClient;

  MarketRepositoryImpl({required this.localStorage});

  Future<void> _initClients() async {
    final token = localStorage.getOandaToken();
    final account = localStorage.getOandaAccountId();

    if (token == null || account == null) {
      throw Exception("OANDA credentials not found");
    }

    _restClient = OandaRestClient(token);
  }

  @override
  Future<void> saveOandaCredentials({required String token, required String accountId}) async {
    await localStorage.saveOandaToken(token);
    await localStorage.saveOandaAccountId(accountId);
  }

  @override
  Future<Map<String, String>> getOandaCredentials() async {
    final token = localStorage.getOandaToken();
    final account = localStorage.getOandaAccountId();
    if (token == null || account == null) throw Exception("Credentials missing");
    return {"token": token, "accountId": account};
  }

  @override
  Future<Map<String, dynamic>> fetchAccountDetails() async {
    await _initClients();
    final account = localStorage.getOandaAccountId()!;
    final response = await _restClient!.dio.get("/accounts/$account");
    return response.data;
  }

  @override
  Future<List<CandleEntity>> fetchHistoricalCandles(
      String instrument, String granularity, int count) async {
    await _initClients();
    final resp = await _restClient!.getCandles(
      instrument: instrument,
      granularity: granularity,
      count: count,
    );

    final List<CandleEntity> list = [];
    final data = resp.data["candles"] as List;

    for (var item in data) {
      if (item["complete"] == true) {
        final candle = CandleModel(
          time: DateTime.parse(item["time"]),
          open: double.parse(item["mid"]["o"]),
          high: double.parse(item["mid"]["h"]),
          low: double.parse(item["mid"]["l"]),
          close: double.parse(item["mid"]["c"]),
          volume: item["volume"],
        );
        list.add(candle.toEntity());
      }
    }
    return list;
  }

  @override
  Future<List<String>> fetchAvailableInstruments() async {
    await _initClients();
    final account = localStorage.getOandaAccountId()!;
    final resp = await _restClient!.getInstruments(account);

    final data = resp.data["instruments"] as List;
    return data.map((item) => item["name"].toString()).toList();
  }

  @override
  Stream<TickEntity> streamTicks(String instrument) {
    final token = localStorage.getOandaToken()!;
    final account = localStorage.getOandaAccountId()!;
    _wsClient = OandaWebSocketClient(
      token: token,
      accountId: account,
      instrument: instrument,
    );

    return _wsClient!.stream
      .where((json) => json.containsKey("bids") && json.containsKey("asks"))
      .map((json) {
        final model = TickModel.fromJson(json);
        return model.toEntity();
      });
  }
}
EOF
cat > lib/features/market/presentation/pages/oanda_settings_page.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../domain/usecases/save_oanda_credentials.dart';
import '../../domain/usecases/get_available_instruments.dart';
import '../../domain/usecases/get_saved_credentials.dart';
import '../../domain/repositories/market_repository.dart';
import '../widgets/instrument_list_widget.dart';

class OandaSettingsPage extends StatefulWidget {
  final MarketRepository repository;

  OandaSettingsPage({required this.repository});

  @override
  _OandaSettingsPageState createState() => _OandaSettingsPageState();
}

class _OandaSettingsPageState extends State<OandaSettingsPage> {
  final _tokenController = TextEditingController();
  final _accountIdController = TextEditingController();

  bool _isLoading = false;
  List<String> _instruments = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    try {
      final credentials = await GetSavedCredentials(widget.repository)();
      _tokenController.text = credentials['token']!;
      _accountIdController.text = credentials['accountId']!;
      _fetchInstruments(); // جلب تلقائي
    } catch (_) {}
  }

  void _saveCredentials() async {
    setState(() => _isLoading = true);
    await SaveOandaCredentials(widget.repository)(
      token: _tokenController.text.trim(),
      accountId: _accountIdController.text.trim(),
    );
    await _fetchInstruments();
    setState(() => _isLoading = false);
  }

  void _fetchInstruments() async {
    setState(() => _isLoading = true);
    final list = await GetAvailableInstruments(widget.repository)();
    setState(() => _instruments = list);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إعدادات OANDA")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(
                labelText: "API Token",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _accountIdController,
              decoration: InputDecoration(
                labelText: "Account ID",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveCredentials,
              child: Text("حفظ وجلب الأسواق"),
            ),
            SizedBox(height: 16),
            if (_isLoading) CircularProgressIndicator(),
            if (!_isLoading && _instruments.isNotEmpty)
              Expanded(child: InstrumentListWidget(instruments: _instruments)),
          ],
        ),
      ),
    );
  }
}
EOF
cat > lib/features/market/presentation/widgets/instrument_list_widget.dart << 'EOF'
import 'package:flutter/material.dart';

class InstrumentListWidget extends StatelessWidget {
  final List<String> instruments;

  InstrumentListWidget({required this.instruments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: instruments.length,
      itemBuilder: (context, index) {
        final symbol = instruments[index];
        return ListTile(
          title: Text(symbol),
          trailing: Icon(Icons.show_chart),
        );
      },
    );
  }
}
EOF
cat > lib/features/market/presentation/pages/home_page.dart << 'EOF'
import 'package:flutter/material.dart';
import '../pages/oanda_settings_page.dart';
import '../../data/repositories/market_repository_impl.dart';
import '../../data/datasources/local_storage.dart';
import '../../domain/repositories/market_repository.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final LocalStorage localStorage = LocalStorage();
    final MarketRepository repository =
        MarketRepositoryImpl(localStorage: localStorage);

    return Scaffold(
      appBar: AppBar(title: Text("Trading App")),
      body: Center(
        child: ElevatedButton(
          child: Text("إعداد OANDA"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OandaSettingsPage(repository: repository),
              ),
            );
          },
        ),
      ),
    );
  }
}
EOF
cat > lib/app.dart << 'EOF'
import 'package:flutter/material.dart';
import 'features/market/presentation/pages/home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trading App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
EOF
cat > lib/features/market/presentation/pages/market_chart_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/candle.dart';
import '../../domain/entities/tick.dart';
import '../../domain/usecases/get_historical_candles.dart';
import '../../domain/usecases/stream_ticks.dart';
import '../../domain/repositories/market_repository.dart';

class MarketChartPage extends StatefulWidget {
  final MarketRepository repository;
  final String instrument;

  MarketChartPage({
    required this.repository,
    required this.instrument,
  });

  @override
  _MarketChartPageState createState() => _MarketChartPageState();
}

class _MarketChartPageState extends State<MarketChartPage> {
  bool _isLoading = true;
  List<CandleEntity> _candles = [];
  Stream<TickEntity>? _tickStream;

  @override
  void initState() {
    super.initState();
    _fetchHistorical();
    _initLiveStream();
  }

  void _fetchHistorical() async {
    try {
      final list = await GetHistoricalCandles(widget.repository)(
        instrument: widget.instrument,
        granularity: "M1",
        count: 200,
      );
      setState(() {
        _candles = list;
        _isLoading = false;
      });
    } catch (ex) {
      print("Error fetching candles: $ex");
      setState(() => _isLoading = false);
    }
  }

  void _initLiveStream() {
    try {
      _tickStream = StreamTicks(widget.repository)(widget.instrument);
      _tickStream!.listen((tick) {
        setState(() {
          // تحديث الشمعة الأخيرة إذا لزم الأمر …
          // (سنكمل المنطق التفصيلي بعد رسم الشارت)
        });
      });
    } catch (ex) {
      print("WebSocket error: $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chart — ${widget.instrument}"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Expanded(child: _buildCandlestickChart()),
                ],
              ),
            ),
    );
  }

  Widget _buildCandlestickChart() {

    // أسلوب بسيط لتحويل بيانات CandleEntity إلى FlSpot
    List<CandleStick> _data = _candles.map((c) {
      return CandleStick(
        x: c.time.millisecondsSinceEpoch.toDouble(),
        open: c.open,
        high: c.high,
        low: c.low,
        close: c.close,
      );
    }).toList();

    return CandleStickChart(
      data: _data,
    );
  }
}
EOF
cat > lib/features/market/presentation/widgets/candlestick_chart.dart << 'EOF'
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CandleStick {
  final double x, open, high, low, close;
  CandleStick({
    required this.x,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}

class CandleStickChart extends StatelessWidget {
  final List<CandleStick> data;

  CandleStickChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: data.map((c) {
          return BarChartGroupData(x: c.x.toInt(), barRods: [
            BarChartRodData(
              toY: c.high,
              fromY: c.low,
              color: c.close >= c.open ? Colors.green : Colors.red,
              width: 5,
            ),
          ]);
        }).toList(),
      ),
    );
  }
}
EOF
cat > lib/features/market/presentation/widgets/instrument_list_widget.dart << 'EOF'
import 'package:flutter/material.dart';
import '../pages/market_chart_page.dart';
import '../../data/repositories/market_repository_impl.dart';
import '../../data/datasources/local_storage.dart';

class InstrumentListWidget extends StatelessWidget {
  final List<String> instruments;

  InstrumentListWidget({required this.instruments});

  @override
  Widget build(BuildContext context) {

    final LocalStorage localStorage = LocalStorage();
    final repository = MarketRepositoryImpl(localStorage: localStorage);

    return ListView.builder(
      itemCount: instruments.length,
      itemBuilder: (ctx, i) {
        final symbol = instruments[i];
        return ListTile(
          title: Text(symbol),
          trailing: Icon(Icons.show_chart),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MarketChartPage(
                  repository: repository,
                  instrument: symbol,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
EOF
cat > lib/features/market/domain/indicators/ema_calculator.dart << 'EOF'
import '../../domain/entities/candle.dart';

class EmaResult {
  final List<double> values;
  final int period;

  EmaResult({required this.values, required this.period});
}

class EmaCalculator {
  /// حساب الـ EMA
  /// data = قيم الإغلاق في الترتيب الزمني
  static EmaResult calculate({
    required List<CandleEntity> data,
    required int period,
  }) {
    final List<double> ema = [];

    double multiplier = 2 / (period + 1);
    double prevEma = data.first.close;

    for (int i = 0; i < data.length; i++) {
      final price = data[i].close;
      if (i == 0) {
        // أول قيمة EMA = سعر الإغلاق الأول
        prevEma = price;
      } else {
        prevEma = ((price - prevEma) * multiplier) + prevEma;
      }
      ema.add(prevEma);
    }

    return EmaResult(values: ema, period: period);
  }
}
EOF
cat > lib/features/market/domain/indicators/stochastic_calculator.dart << 'EOF'
import '../../domain/entities/candle.dart';
import 'dart:math';

class StochasticResult {
  final List<double> kValues;
  final List<double> dValues;
  final int period;
  final int smoothK;
  final int smoothD;

  StochasticResult({
    required this.kValues,
    required this.dValues,
    required this.period,
    required this.smoothK,
    required this.smoothD,
  });
}

class StochasticCalculator {
  static StochasticResult calculate({
    required List<CandleEntity> data,
    required int period,
    required int smoothK,
    required int smoothD,
  }) {
    List<double> k = [];
    List<double> d = [];

    for (int i = 0; i < data.length; i++) {
      if (i < period) {
        k.add(0);
        d.add(0);
        continue;
      }

      double highestHigh = data
          .sublist(i - period + 1, i + 1)
          .map((c) => c.high)
          .reduce(max);

      double lowestLow = data
          .sublist(i - period + 1, i + 1)
          .map((c) => c.low)
          .reduce(min);

      double currentClose = data[i].close;

      double rawK = ((currentClose - lowestLow) / (highestHigh - lowestLow)) *
          100;

      k.add(rawK);

      if (i >= period + smoothK - 1) {
        double avgK = k.sublist(i - smoothK + 1, i + 1).reduce((a, b) => a + b) /
            smoothK;
        if (d.length >= smoothD) {
          double avgD =
              d.sublist(i - smoothD + 1, i + 1).reduce((a, b) => a + b) /
                  smoothD;
          d.add(avgD);
        } else {
          d.add(avgK);
        }
      } else {
        d.add(0);
      }
    }

    return StochasticResult(
      kValues: k,
      dValues: d,
      period: period,
      smoothK: smoothK,
      smoothD: smoothD,
    );
  }
}
EOF
cat > lib/features/market/presentation/pages/market_chart_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import '../../domain/entities/candle.dart';
import '../../domain/entities/tick.dart';
import '../../domain/usecases/get_historical_candles.dart';
import '../../domain/usecases/stream_ticks.dart';
import '../../domain/repositories/market_repository.dart';
import '../../domain/indicators/ema_calculator.dart';
import '../../domain/indicators/stochastic_calculator.dart';

class MarketChartPage extends StatefulWidget {
  final MarketRepository repository;
  final String instrument;

  MarketChartPage({
    required this.repository,
    required this.instrument,
  });

  @override
  _MarketChartPageState createState() => _MarketChartPageState();
}

class _MarketChartPageState extends State<MarketChartPage> {
  bool _isLoading = true;
  List<CandleEntity> _candles = [];

  List<double> _ema50 = [];
  List<double> _ema200 = [];

  List<double> _stochK = [];
  List<double> _stochD = [];

  Stream<TickEntity>? _tickStream;

  @override
  void initState() {
    super.initState();
    _fetchHistorical();
  }

  void _fetchHistorical() async {
    try {
      final list = await GetHistoricalCandles(widget.repository)(
        instrument: widget.instrument,
        granularity: "M1",
        count: 500,
      );

      setState(() {
        _candles = list;
      });

      _calculateIndicators();

      _initLiveStream();

      setState(() => _isLoading = false);
    } catch (e) {
      print("Error fetch historical: $e");
      setState(() => _isLoading = false);
    }
  }

  void _calculateIndicators() {

    final ema50Result = EmaCalculator.calculate(
        data: _candles, period: 50);
    final ema200Result = EmaCalculator.calculate(
        data: _candles, period: 200);

    setState(() {
      _ema50 = ema50Result.values;
      _ema200 = ema200Result.values;
    });

    final stoch = StochasticCalculator.calculate(
      data: _candles,
      period: 14,
      smoothK: 3,
      smoothD: 3,
    );

    setState(() {
      _stochK = stoch.kValues;
      _stochD = stoch.dValues;
    });
  }

  void _initLiveStream() {
    _tickStream = StreamTicks(widget.repository)(widget.instrument);

    _tickStream!.listen((tick) {
      setState(() {

        final last = _candles.isNotEmpty ? _candles.last : null;
        if (last != null &&
            DateTime.now().difference(last.time).inMinutes == 0) {

          final updated = CandleEntity(
            time: last.time,
            open: last.open,
            high: max(last.high, tick.bid),
            low: min(last.low, tick.bid),
            close: tick.bid,
            volume: last.volume + 1,
          );

          _candles[_candles.length - 1] = updated;

        } else {
          _candles.add(
            CandleEntity(
              time: DateTime.now(),
              open: tick.bid,
              high: tick.bid,
              low: tick.bid,
              close: tick.bid,
              volume: 1,
            ),
          );
        }

        _calculateIndicators();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chart — ${widget.instrument}"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: _buildIndicatorChart()),
              ],
            ),
    );
  }

  Widget _buildIndicatorChart() {
    return Container(
      height: 400,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: _ema50.asMap().entries.map((e) =>
                  FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              colors: [Colors.blue],
            ),
            LineChartBarData(
              spots: _ema200.asMap().entries.map((e) =>
                  FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              colors: [Colors.orange],
            ),
          ],
        ),
      ),
    );
  }
}
EOF
cat > lib/features/market/domain/trading/trade_position.dart << 'EOF'
import '../entities/candle.dart';

enum TradeType { BUY, SELL }

class TradePosition {
  final String instrument;
  final TradeType type;
  final DateTime entryTime;
  final double entryPrice;
  final double stopLoss;
  final double takeProfit;
  double? exitPrice;
  DateTime? exitTime;

  TradePosition({
    required this.instrument,
    required this.type,
    required this.entryTime,
    required this.entryPrice,
    required this.stopLoss,
    required this.takeProfit,
  });
}
EOF
cat > lib/features/market/domain/trading/trade_result.dart << 'EOF'
class TradeResult {
  final double profit;
  final double entryPrice;
  final double exitPrice;
  final DateTime entryTime;
  final DateTime exitTime;

  TradeResult({
    required this.profit,
    required this.entryPrice,
    required this.exitPrice,
    required this.entryTime,
    required this.exitTime,
  });
}
EOF
cat > lib/features/market/domain/trading/strategy_manager.dart << 'EOF'
import '../entities/candle.dart';
import '../indicators/ema_calculator.dart';
import '../indicators/stochastic_calculator.dart';
import 'trade_position.dart';

class StrategyManager {
  final List<CandleEntity> candles;

  StrategyManager(this.candles);

  TradePosition? checkForSignal({
    required String instrument,
    required double currentPrice,
  }) {
    // EMA Cross Strategy
    final ema50 = EmaCalculator.calculate(data: candles, period: 50).values;
    final ema200 = EmaCalculator.calculate(data: candles, period: 200).values;

    final stoch = StochasticCalculator.calculate(
      data: candles,
      period: 14,
      smoothK: 3,
      smoothD: 3,
    );

    final int lastIndex = candles.length - 1;
    if (lastIndex < 200) return null;

    final crossBuy = (ema50[lastIndex] > ema200[lastIndex]) &&
        (stoch.kValues[lastIndex] > stoch.dValues[lastIndex]);

    final crossSell = (ema50[lastIndex] < ema200[lastIndex]) &&
        (stoch.kValues[lastIndex] < stoch.dValues[lastIndex]);

    if (crossBuy) {
      return TradePosition(
        instrument: instrument,
        type: TradeType.BUY,
        entryTime: candles[lastIndex].time,
        entryPrice: currentPrice,
        stopLoss: currentPrice * 0.998,
        takeProfit: currentPrice * 1.005,
      );
    }

    if (crossSell) {
      return TradePosition(
        instrument: instrument,
        type: TradeType.SELL,
        entryTime: candles[lastIndex].time,
        entryPrice: currentPrice,
        stopLoss: currentPrice * 1.002,
        takeProfit: currentPrice * 0.995,
      );
    }
    return null;
  }
}
EOF
cat > lib/features/market/data/trading/virtual_exchange.dart << 'EOF'
import '../../domain/trading/trade_position.dart';
import '../../domain/entities/candle.dart';
import '../../domain/trading/trade_result.dart';

class VirtualExchange {
  final List<TradePosition> openPositions = [];
  final List<TradeResult> tradeHistory = [];

  void openPosition(TradePosition position) {
    openPositions.add(position);
  }

  void updateWithNewCandle(CandleEntity candle) {
    for (var position in List.of(openPositions)) {
      final currentPrice = candle.close;

      if (position.type == TradeType.BUY) {
        if (currentPrice >= position.takeProfit ||
            currentPrice <= position.stopLoss) {
          _closePosition(position, currentPrice, candle.time);
        }
      }
      if (position.type == TradeType.SELL) {
        if (currentPrice <= position.takeProfit ||
            currentPrice >= position.stopLoss) {
          _closePosition(position, currentPrice, candle.time);
        }
      }
    }
  }

  void _closePosition(
    TradePosition position,
    double exitPrice,
    DateTime exitTime,
  ) {
    double profit = (position.type == TradeType.BUY)
        ? exitPrice - position.entryPrice
        : position.entryPrice - exitPrice;

    final result = TradeResult(
      profit: profit,
      entryPrice: position.entryPrice,
      exitPrice: exitPrice,
      entryTime: position.entryTime,
      exitTime: exitTime,
    );

    openPositions.remove(position);
    tradeHistory.add(result);
  }
}
EOF
cat > lib/features/market/presentation/pages/market_chart_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import '../../domain/entities/candle.dart';
import '../../domain/entities/tick.dart';
import '../../domain/usecases/get_historical_candles.dart';
import '../../domain/usecases/stream_ticks.dart';
import '../../domain/repositories/market_repository.dart';
import '../../domain/trading/strategy_manager.dart';
import '../../data/trading/virtual_exchange.dart';
import '../../domain/trading/trade_position.dart';

class MarketChartPage extends StatefulWidget {
  final MarketRepository repository;
  final String instrument;

  MarketChartPage({
    required this.repository,
    required this.instrument,
  });

  @override
  _MarketChartPageState createState() => _MarketChartPageState();
}

class _MarketChartPageState extends State<MarketChartPage> {
  bool _isLoading = true;
  List<CandleEntity> _candles = [];

  final VirtualExchange _virtualExchange = VirtualExchange();

  Stream<TickEntity>? _tickStream;

  @override
  void initState() {
    super.initState();
    _fetchHistorical();
  }

  void _fetchHistorical() async {
    setState(() => _isLoading = true);

    final list = await GetHistoricalCandles(widget.repository)(
      instrument: widget.instrument,
      granularity: "M1",
      count: 500,
    );

    setState(() => _candles = list);

    _initLiveStream();
    setState(() => _isLoading = false);
  }

  void _initLiveStream() {
    _tickStream = StreamTicks(widget.repository)(widget.instrument);
    _tickStream!.listen((tick) {
      setState(() {
        final last = _candles.isNotEmpty ? _candles.last : null;
        if (last != null &&
            DateTime.now().difference(last.time).inMinutes == 0) {
          final updated = CandleEntity(
            time: last.time,
            open: last.open,
            high: max(last.high, tick.bid),
            low: min(last.low, tick.bid),
            close: tick.bid,
            volume: last.volume + 1,
          );
          _candles[_candles.length - 1] = updated;
          _virtualExchange.updateWithNewCandle(updated);
        } else {
          final newCandle = CandleEntity(
            time: DateTime.now(),
            open: tick.bid,
            high: tick.bid,
            low: tick.bid,
            close: tick.bid,
            volume: 1,
          );
          _candles.add(newCandle);
        }

        final strategyManager = StrategyManager(_candles);
        final signal = strategyManager.checkForSignal(
          instrument: widget.instrument,
          currentPrice: _candles.last.close,
        );

        if (signal != null) {
          _virtualExchange.openPosition(signal);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chart — ${widget.instrument}"),
      ),
      body: Column(
        children: [
          if (_isLoading) CircularProgressIndicator(),
          if (!_isLoading) Expanded(child: Container()),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Open Trades: ${_virtualExchange.openPositions.length}, "
              "Closed: ${_virtualExchange.tradeHistory.length}",
            ),
          ),
        ],
      ),
    );
  }
}
EOF
cat > lib/features/market/presentation/widgets/signal_marker.dart << 'EOF'
import 'package:flutter/material.dart';

class SignalMarker extends StatelessWidget {
  final bool isBuy;
  final double x;
  final double y;

  SignalMarker({
    required this.isBuy,
    required this.x,
    required this.y,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Icon(
        isBuy ? Icons.arrow_circle_up : Icons.arrow_circle_down,
        color: isBuy ? Colors.green : Colors.red,
        size: 24,
      ),
    );
  }
}
EOF
cat > lib/features/market/domain/backtest/backtest_result.dart << 'EOF'
class BacktestResult {
  final List<DateTime> timestamps;
  final List<double> equityCurve;
  final double netProfit;
  final double maxDrawdown;
  final double winRate;

  BacktestResult({
    required this.timestamps,
    required this.equityCurve,
    required this.netProfit,
    required this.maxDrawdown,
    required this.winRate,
  });
}
EOF
cat > lib/features/market/domain/backtest/backtest_engine.dart << 'EOF'
import '../trading/trade_position.dart';
import '../trading/trade_result.dart';
import '../trading/strategy_manager.dart';
import '../entities/candle.dart';
import 'backtest_result.dart';

class BacktestEngine {
  final List<CandleEntity> historicalData;

  BacktestEngine(this.historicalData);

  BacktestResult run() {
    List<double> equityCurve = [];
    List<DateTime> timestamps = [];

    double balance = 10000;
    double peak = balance;
    double maxDrawdown = 0;
    int wins = 0;
    int tradesCount = 0;

    final List<TradePosition> openPositions = [];

    for (var candle in historicalData) {
      final strategy = StrategyManager(historicalData);
      final signal = strategy.checkForSignal(
        instrument: "",
        currentPrice: candle.close,
      );

      if (signal != null) {
        openPositions.add(signal);
        tradesCount++;
      }

      for (var pos in List.of(openPositions)) {
        if (pos.type == TradeType.BUY) {
          if (candle.close >= pos.takeProfit ||
              candle.close <= pos.stopLoss) {
            final profit =
                (candle.close - pos.entryPrice) * 10000; // Scale
            balance += profit;
            if (profit > 0) wins++;
            openPositions.remove(pos);
          }
        } else {
          if (candle.close <= pos.takeProfit ||
              candle.close >= pos.stopLoss) {
            final profit =
                (pos.entryPrice - candle.close) * 10000; // Scale
            balance += profit;
            if (profit > 0) wins++;
            openPositions.remove(pos);
          }
        }
      }

      timestamps.add(candle.time);
      equityCurve.add(balance);

      if (balance > peak) peak = balance;
      final drawdown = (peak - balance) / peak * 100;
      if (drawdown > maxDrawdown) maxDrawdown = drawdown;
    }

    final winRate = tradesCount > 0 ? wins / tradesCount * 100 : 0;

    final netProfit = balance - 10000;

    return BacktestResult(
      timestamps: timestamps,
      equityCurve: equityCurve,
      netProfit: netProfit,
      maxDrawdown: maxDrawdown,
      winRate: winRate,
    );
  }
}
EOF
cat > lib/features/market/domain/usecases/run_backtest.dart << 'EOF'
import '../backtest/backtest_engine.dart';
import '../backtest/backtest_result.dart';
import '../entities/candle.dart';

class RunBacktest {
  Future<BacktestResult> call(List<CandleEntity> history) async {
    final engine = BacktestEngine(history);
    return engine.run();
  }
}
EOF
cat > lib/features/market/presentation/pages/backtest/backtest_page.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../domain/usecases/run_backtest.dart';
import '../../widgets/backtest_report_widget.dart';
import '../../widgets/equity_curve_widget.dart';
import '../../../domain/entities/candle.dart';
import '../../../domain/repositories/market_repository.dart';
import '../../../domain/usecases/get_historical_candles.dart';

class BacktestPage extends StatefulWidget {
  final MarketRepository repository;
  final String instrument;

  BacktestPage({
    required this.repository,
    required this.instrument,
  });

  @override
  _BacktestPageState createState() => _BacktestPageState();
}

class _BacktestPageState extends State<BacktestPage> {
  bool _isRunning = false;
  dynamic _result;

  void _startBacktest() async {
    setState(() => _isRunning = true);

    final data = await GetHistoricalCandles(widget.repository)(
      instrument: widget.instrument,
      granularity: "M1",
      count: 1000,
    );

    final result = await RunBacktest().call(data);
    setState(() => _result = result);
    setState(() => _isRunning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backtest — ${widget.instrument}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isRunning
            ? Center(child: CircularProgressIndicator())
            : (_result == null
                ? ElevatedButton(
                    onPressed: _startBacktest,
                    child: Text("تشغيل الباك‑تست"),
                  )
                : Column(
                    children: [
                      BacktestReportWidget(result: _result),
                      SizedBox(height: 16),
                      Expanded(child: EquityCurveWidget(result: _result)),
                    ],
                  )),
      ),
    );
  }
}
EOF
cat > lib/features/market/presentation/widgets/backtest/backtest_report_widget.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../domain/backtest/backtest_result.dart';

class BacktestReportWidget extends StatelessWidget {
  final BacktestResult result;

  BacktestReportWidget({required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Net Profit: ${result.netProfit.toStringAsFixed(2)}"),
        Text("Win Rate: ${result.winRate.toStringAsFixed(2)}%"),
        Text("Max Drawdown: ${result.maxDrawdown.toStringAsFixed(2)}%"),
      ],
    );
  }
}
EOF
cat > lib/features/market/presentation/widgets/backtest/equity_curve_widget.dart << 'EOF'
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../domain/backtest/backtest_result.dart';

class EquityCurveWidget extends StatelessWidget {
  final BacktestResult result;

  EquityCurveWidget({required this.result});

  @override
  Widget build(BuildContext context) {
    final spots = result.equityCurve.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(spots: spots, isCurved: true, colors: [Colors.blue]),
        ],
      ),
    );
  }
}
EOF
cat > lib/features/market/presentation/widgets/instrument_list_widget.dart << 'EOF'
import 'package:flutter/material.dart';
import '../pages/market_chart_page.dart';
import '../pages/backtest/backtest_page.dart';
import '../../data/repositories/market_repository_impl.dart';
import '../../data/datasources/local_storage.dart';

class InstrumentListWidget extends StatelessWidget {
  final List<String> instruments;

  InstrumentListWidget({required this.instruments});

  @override
  Widget build(BuildContext context) {
    final localStorage = LocalStorage();
    final repo = MarketRepositoryImpl(localStorage: localStorage);

    return ListView.builder(
      itemCount: instruments.length,
      itemBuilder: (ctx, i) {
        final symbol = instruments[i];
        return ListTile(
          title: Text(symbol),
          subtitle: Row(
            children: [
              ElevatedButton(
                child: Text("Chart"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MarketChartPage(
                        repository: repo,
                        instrument: symbol,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 8),
              ElevatedButton(
                child: Text("Backtest"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BacktestPage(
                        repository: repo,
                        instrument: symbol,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
EOF
cat > lib/features/market/data/storage/strategy_settings.dart << 'EOF'
class StrategySettings {
  int emaShort;
  int emaLong;
  int stochKPeriod;
  int stochSmoothK;
  int stochSmoothD;
  double stopLossPercent;
  double takeProfitPercent;

  StrategySettings({
    required this.emaShort,
    required this.emaLong,
    required this.stochKPeriod,
    required this.stochSmoothK,
    required this.stochSmoothD,
    required this.stopLossPercent,
    required this.takeProfitPercent,
  });

  Map<String, dynamic> toJson() => {
        "emaShort": emaShort,
        "emaLong": emaLong,
        "stochKPeriod": stochKPeriod,
        "stochSmoothK": stochSmoothK,
        "stochSmoothD": stochSmoothD,
        "stopLossPercent": stopLossPercent,
        "takeProfitPercent": takeProfitPercent,
      };

  factory StrategySettings.fromJson(Map<String, dynamic> json) {
    return StrategySettings(
      emaShort: json["emaShort"],
      emaLong: json["emaLong"],
      stochKPeriod: json["stochKPeriod"],
      stochSmoothK: json["stochSmoothK"],
      stochSmoothD: json["stochSmoothD"],
      stopLossPercent: json["stopLossPercent"],
      takeProfitPercent: json["takeProfitPercent"],
    );
  }
}
EOF
cat > lib/features/market/data/storage/settings_storage.dart << 'EOF'
import 'package:hive/hive.dart';
import 'strategy_settings.dart';

class SettingsStorage {
  final Box _box = Hive.box('settings');

  Future<void> saveStrategySettings(StrategySettings settings) async {
    await _box.put('strategy_settings', settings.toJson());
  }

  StrategySettings? getStrategySettings() {
    final json = _box.get('strategy_settings');
    if (json == null) return null;
    return StrategySettings.fromJson(Map<String, dynamic>.from(json));
  }
}
EOF
cat > lib/features/market/presentation/pages/settings/strategy_settings_page.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../data/storage/settings_storage.dart';
import '../../../data/storage/strategy_settings.dart';

class StrategySettingsPage extends StatefulWidget {
  @override
  _StrategySettingsPageState createState() => _StrategySettingsPageState();
}

class _StrategySettingsPageState extends State<StrategySettingsPage> {
  final SettingsStorage _storage = SettingsStorage();
  late StrategySettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = _storage.getStrategySettings() ??
        StrategySettings(
          emaShort: 50,
          emaLong: 200,
          stochKPeriod: 14,
          stochSmoothK: 3,
          stochSmoothD: 3,
          stopLossPercent: 0.2,
          takeProfitPercent: 0.5,
        );
  }

  _save() {
    _storage.saveStrategySettings(_settings);
    Navigator.pop(context);
  }

  Widget _numberInput(String label, int value, Function(int) onChanged) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(border: OutlineInputBorder()),
            controller: TextEditingController(text: value.toString()),
            onChanged: (v) => onChanged(int.parse(v)),
          ),
        ),
      ],
    );
  }

  Widget _doubleInput(String label, double value, Function(double) onChanged) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(border: OutlineInputBorder()),
            controller: TextEditingController(text: value.toString()),
            onChanged: (v) => onChanged(double.parse(v)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إعدادات الاستراتيجية")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _numberInput("EMA Short", _settings.emaShort,
                (v) => _settings.emaShort = v),
            SizedBox(height: 8),
            _numberInput("EMA Long", _settings.emaLong,
                (v) => _settings.emaLong = v),
            SizedBox(height: 8),
            _numberInput("Stoch K Period", _settings.stochKPeriod,
                (v) => _settings.stochKPeriod = v),
            SizedBox(height: 8),
            _numberInput(
                "Stoch Smooth K", _settings.stochSmoothK,
                (v) => _settings.stochSmoothK = v),
            SizedBox(height: 8),
            _numberInput(
                "Stoch Smooth D", _settings.stochSmoothD,
                (v) => _settings.stochSmoothD = v),
            SizedBox(height: 8),
            _doubleInput("Stop Loss %", _settings.stopLossPercent,
                (v) => _settings.stopLossPercent = v),
            SizedBox(height: 8),
            _doubleInput("Take Profit %", _settings.takeProfitPercent,
                (v) => _settings.takeProfitPercent = v),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _save, child: Text("حفظ الإعدادات")),
          ],
        ),
      ),
    );
  }
}
EOF
cat >> lib/features/market/presentation/pages/home_page.dart << 'EOF'

ElevatedButton(
  child: Text("إعدادات الاستراتيجية"),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StrategySettingsPage()),
    );
  },
),
EOF
cat > lib/features/market/data/storage/export_utils.dart << 'EOF'
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
EOF
cat > lib/features/market/presentation/pages/backtest/backtest_page.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../data/storage/export_utils.dart';
import '../../../domain/backtest/backtest_result.dart';
import '../widgets/backtest_report_widget.dart';
import '../widgets/equity_curve_widget.dart';
import '../../../domain/entities/candle.dart';
import '../../../domain/repositories/market_repository.dart';
import '../../../domain/usecases/get_historical_candles.dart';
import '../../../domain/usecases/run_backtest.dart';

class BacktestPage extends StatefulWidget {
  final MarketRepository repository;
  final String instrument;

  BacktestPage({
    required this.repository,
    required this.instrument,
  });

  @override
  _BacktestPageState createState() => _BacktestPageState();
}

class _BacktestPageState extends State<BacktestPage> {
  bool _isRunning = false;
  BacktestResult? _result;

  void _startBacktest() async {
    setState(() => _isRunning = true);

    final data = await GetHistoricalCandles(widget.repository)(
      instrument: widget.instrument,
      granularity: "M1",
      count: 1000,
    );

    final result = await RunBacktest().call(data);
    setState(() => _result = result);
    setState(() => _isRunning = false);
  }

  void _exportJSON() async {
    final path = await ExportUtils.exportBacktestJSON(_result!);
    await ExportUtils.shareFile(path);
  }

  void _exportCSV() async {
    final path = await ExportUtils.exportBacktestCSV(_result!);
    await ExportUtils.shareFile(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backtest — ${widget.instrument}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isRunning
            ? Center(child: CircularProgressIndicator())
            : (_result == null
                ? ElevatedButton(
                    onPressed: _startBacktest,
                    child: Text("تشغيل Backtest"),
                  )
                : Column(
                    children: [
                      BacktestReportWidget(result: _result!),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: _exportJSON,
                              child: Text("Export JSON")),
                          ElevatedButton(
                              onPressed: _exportCSV,
                              child: Text("Export CSV")),
                        ],
                      ),
                      SizedBox(height: 16),
                      Expanded(child: EquityCurveWidget(result: _result!)),
                    ],
                  )),
      ),
    );
  }
}
EOF
cat > lib/app.dart << 'EOF'
import 'package:flutter/material.dart';
import 'features/market/presentation/pages/home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trading App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.dark(
          primary: Colors.teal,
          secondary: Colors.tealAccent,
        ),
      ),
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}
EOF
cat > lib/core/errors/failures.dart << 'EOF'
abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message): super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message): super(message);
}

class UnknownFailure extends Failure {
  UnknownFailure(): super("Unknown Error");
}
EOF
cat >> lib/features/market/data/datasources/candles_cache.dart << 'EOF'
import 'package:hive/hive.dart';
import '../models/candle_model.dart';

class CandlesCache {
  final Box<CandleModel> _box = Hive.box<CandleModel>('candles');

  Future<void> cacheCandles(String key, List<CandleModel> candles) async {
    await _box.put(key, candles.map((c) => c.toJson()).toList());
  }

  List<CandleModel>? getCachedCandles(String key) {
    final list = _box.get(key);
    if (list == null) return null;
    return (list as List)
        .map((json) => CandleModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }
}
EOF
cat > test/features/market/domain/indicators/ema_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/indicators/ema_calculator.dart';
import '../../../mock/candles_mock.dart';

void main() {
  test('EMA calculation basic', () {
    final candles = generateMockCandles(100);
    final result = EmaCalculator.calculate(data: candles, period: 10);
    expect(result.values.length, candles.length);
    expect(result.values.first, candles.first.close);
  });
}
EOF
cat > test/features/market/presentation/widgets/backtest_report_widget_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:your_app/features/market/presentation/widgets/backtest/backtest_report_widget.dart';
import 'package:your_app/features/market/domain/backtest/backtest_result.dart';

void main() {
  testWidgets('Backtest report displays numbers', (tester) async {
    final result = BacktestResult(
      timestamps: [DateTime.now()],
      equityCurve: [10000],
      netProfit: 100,
      maxDrawdown: 5,
      winRate: 50,
    );
    await tester.pumpWidget(MaterialApp(
      home: BacktestReportWidget(result: result),
    ));
    expect(find.textContaining("Net Profit"), findsOneWidget);
  });
}
EOF
cat > lib/core/utils/logger.dart << 'EOF'
import 'package:logger/logger.dart';

var appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
  ),
);
EOF
cat > .github/workflows/flutter.yml << 'EOF'
name: Flutter CI

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: 'stable'
EOF
cat > lib/core/utils/notification_service.dart << 'EOF'
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifier = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );

    await _notifier.initialize(initSettings);
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'trade_channel',
      'Trade Notifications',
      channelDescription: 'Notifications for trading signals',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notifDetails = NotificationDetails(android: androidDetails);

    await _notifier.show(id, title, body, notifDetails);
  }
}
EOF
cat > lib/core/utils/notification_service.dart << 'EOF'
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifier = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    final androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    final initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notifier.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // handle notification tapped logic if needed
      },
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'trade_channel',
      'Trade Notifications',
      channelDescription: 'Notifications for trade signals and events',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifier.show(id, title, body, details);
  }
}
EOF
cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/utils/notification_service.dart';
import 'features/market/data/models/candle_model.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();  // 🔔 تهيئة الإشعارات

  await Hive.initFlutter();
  Hive.registerAdapter(CandleModelAdapter());
  await Hive.openBox('settings');
  await Hive.openBox<CandleModel>('candles');

  runApp(MyApp());
}
EOF
cat > lib/features/market/presentation/widgets/candlestick_chart_real.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import '../../domain/entities/candle.dart';

class RealCandleStickChart extends StatelessWidget {
  final List<CandleEntity> candles;

  RealCandleStickChart({required this.candles});

  @override
  Widget build(BuildContext context) {
    final items = candles.map((c) => Candle(
      date: c.time,
      open: c.open,
      high: c.high,
      low: c.low,
      close: c.close,
      volume: c.volume.toDouble(),
    )).toList();

    return Candlesticks(
      candles: items,
    );
  }
}
EOF
cat > lib/core/widgets/error_view.dart << 'EOF'
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(message),
          SizedBox(height: 8),
          ElevatedButton(onPressed: onRetry, child: Text("Retry")),
        ],
      ),
    );
  }
}
EOF
cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'features/market/data/models/candle_model.dart';
import 'core/utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔔 تهيئة الإشعارات
  await NotificationService.init();

  // 📦 تهيئة Hive
  await Hive.initFlutter();
  Hive.registerAdapter(CandleModelAdapter());
  await Hive.openBox('settings');
  await Hive.openBox<CandleModel>('candles');

  // 🧠 تهيئة HydratedBloc
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  HydratedBloc.storage = storage;

  runApp(MyApp());
}
EOF
cat > lib/features/market/presentation/bloc/oanda/oanda_setup_event.dart << 'EOF'
abstract class OandaSetupEvent {}

class SaveCredentials extends OandaSetupEvent {
  final String apiToken;
  final String accountId;

  SaveCredentials({
    required this.apiToken,
    required this.accountId,
  });
}

class LoadCredentials extends OandaSetupEvent {}

class ValidateCredentials extends OandaSetupEvent {}

class ClearCredentials extends OandaSetupEvent {}
EOF
cat > lib/features/market/presentation/bloc/oanda/oanda_setup_state.dart << 'EOF'
abstract class OandaSetupState {}

class OandaIdle extends OandaSetupState {}

class OandaLoading extends OandaSetupState {}

class OandaCredentialsSaved extends OandaSetupState {
  final String apiToken;
  final String accountId;

  OandaCredentialsSaved(this.apiToken, this.accountId);
}

class OandaCredentialsLoaded extends OandaSetupState {
  final String apiToken;
  final String accountId;

  OandaCredentialsLoaded(this.apiToken, this.accountId);
}

class OandaValidationSuccess extends OandaSetupState {}

class OandaValidationError extends OandaSetupState {
  final String message;
  OandaValidationError(this.message);
}

class OandaCredentialsCleared extends OandaSetupState {}
EOF
cat > lib/features/market/presentation/bloc/oanda/oanda_setup_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'oanda_setup_event.dart';
import 'oanda_setup_state.dart';
import '../../../data/repositories/market_repository_impl.dart';
import '../../../data/datasources/local_storage.dart';

class OandaSetupBloc extends HydratedBloc<OandaSetupEvent, OandaSetupState> {
  final MarketRepositoryImpl repository;
  final LocalStorage storage;

  OandaSetupBloc({
    required this.repository,
    required this.storage,
  }) : super(OandaIdle()) {
    on<SaveCredentials>(_onSaveCredentials);
    on<LoadCredentials>(_onLoadCredentials);
    on<ValidateCredentials>(_onValidateCredentials);
    on<ClearCredentials>(_onClearCredentials);
  }

  Future<void> _onSaveCredentials(
    SaveCredentials event,
    Emitter<OandaSetupState> emit,
  ) async {
    emit(OandaLoading());

    try {
      await storage.saveOandaCredentials(
        apiToken: event.apiToken,
        accountId: event.accountId,
      );

      emit(OandaCredentialsSaved(event.apiToken, event.accountId));
    } catch (e) {
      emit(OandaValidationError("Failed to save credentials"));
    }
  }

  Future<void> _onLoadCredentials(
    LoadCredentials event,
    Emitter<OandaSetupState> emit,
  ) async {
    emit(OandaLoading());

    final creds = storage.getOandaCredentials();

    if (creds == null) {
      emit(OandaIdle());
    } else {
      emit(OandaCredentialsLoaded(creds['apiToken']!, creds['accountId']!));
    }
  }

  Future<void> _onValidateCredentials(
    ValidateCredentials event,
    Emitter<OandaSetupState> emit,
  ) async {
    emit(OandaLoading());

    final creds = storage.getOandaCredentials();

    if (creds == null) {
      emit(OandaValidationError("No credentials found"));
      return;
    }

    try {
      final isValid = await repository.validateOandaCredentials(
        apiToken: creds['apiToken']!,
        accountId: creds['accountId']!,
      );

      if (isValid) {
        emit(OandaValidationSuccess());
      } else {
        emit(OandaValidationError("Invalid API Token or Account ID"));
      }
    } catch (e) {
      emit(OandaValidationError("Network error while validating credentials"));
    }
  }

  Future<void> _onClearCredentials(
    ClearCredentials event,
    Emitter<OandaSetupState> emit,
  ) async {
    await storage.clearOandaCredentials();
    emit(OandaCredentialsCleared());
  }

  @override
  OandaSetupState? fromJson(Map<String, dynamic> json) {
    final api = json['apiToken'] as String?;
    final acc = json['accountId'] as String?;

    if (api != null && acc != null) {
      return OandaCredentialsLoaded(api, acc);
    }
    return OandaIdle();
  }

  @override
  Map<String, dynamic>? toJson(OandaSetupState state) {
    if (state is OandaCredentialsSaved) {
      return {
        "apiToken": state.apiToken,
        "accountId": state.accountId,
      };
    }
    return null;
  }
}
EOF
cat > lib/features/market/data/datasources/local_storage.dart << 'EOF'
import 'package:hive/hive.dart';

class LocalStorage {
  final Box _settings = Hive.box('settings');

  Future<void> saveOandaCredentials({
    required String apiToken,
    required String accountId,
  }) async {
    await _settings.put('oanda_api_token', apiToken);
    await _settings.put('oanda_account_id', accountId);
  }

  Map<String, String>? getOandaCredentials() {
    final api = _settings.get('oanda_api_token');
    final acc = _settings.get('oanda_account_id');

    if (api == null || acc == null) return null;

    return {
      "apiToken": api,
      "accountId": acc,
    };
  }

  Future<void> clearOandaCredentials() async {
    await _settings.delete('oanda_api_token');
    await _settings.delete('oanda_account_id');
  }
}
EOF
cat > lib/features/market/presentation/bloc/markets/markets_event.dart << 'EOF'
abstract class MarketsEvent {}

/// Trigger loading markets from OANDA
class LoadMarkets extends MarketsEvent {}

EOF
cat > lib/features/market/presentation/bloc/markets/markets_state.dart << 'EOF'
abstract class MarketsState {}

class MarketsIdle extends MarketsState {}

class MarketsLoading extends MarketsState {}

class MarketsLoaded extends MarketsState {
  final List<String> instruments;
  MarketsLoaded(this.instruments);
}

class MarketsEmpty extends MarketsState {}

class MarketsError extends MarketsState {
  final String message;
  MarketsError(this.message);
}
EOF
cat > lib/features/market/presentation/bloc/markets/markets_bloc.dart << 'EOF'
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'markets_event.dart';
import 'markets_state.dart';
import '../../../data/repositories/market_repository_impl.dart';
import '../../../data/datasources/local_storage.dart';

class MarketsBloc extends HydratedBloc<MarketsEvent, MarketsState> {
  final MarketRepositoryImpl repository;
  final LocalStorage storage;

  MarketsBloc({
    required this.repository,
    required this.storage,
  }) : super(MarketsIdle()) {
    on<LoadMarkets>(_onLoadMarkets);
  }

  Future<void> _onLoadMarkets(
    LoadMarkets event,
    Emitter<MarketsState> emit,
  ) async {
    emit(MarketsLoading());

    try {
      final list = await repository.fetchAvailableInstruments();

      // Auto‑filter to FX + Metals
      final filtered = list.where((symbol) {
        final s = symbol.toLowerCase();
        return s.contains("usd") || s.contains("xau") || s.contains("xag");
      }).toList();

      if (filtered.isEmpty) {
        emit(MarketsEmpty());
      } else {
        emit(MarketsLoaded(filtered));
      }
    } catch (e) {
      emit(MarketsError("Failed to load markets"));
    }
  }

  @override
  MarketsState? fromJson(Map<String, dynamic> json) {
    final list = (json['instruments'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList();
    if (list != null && list.isNotEmpty) {
      return MarketsLoaded(list);
    }
    return MarketsIdle();
  }

  @override
  Map<String, dynamic>? toJson(MarketsState state) {
    if (state is MarketsLoaded) {
      return {
        "instruments": state.instruments,
      };
    }
    return null;
  }
}
EOF
cat > lib/features/market/presentation/pages/home_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/bloc/oanda/oanda_setup_bloc.dart';
import '../../presentation/bloc/oanda/oanda_setup_state.dart';
import '../../presentation/bloc/markets/markets_bloc.dart';
import '../../presentation/bloc/markets/markets_event.dart';
import '../../presentation/bloc/markets/markets_state.dart';
import '../../data/repositories/market_repository_impl.dart';
import '../../data/datasources/local_storage.dart';
import '../widgets/market_list_widget.dart';
import '../pages/oanda_settings_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final localStorage = LocalStorage();
    final repository = MarketRepositoryImpl(localStorage: localStorage);

    return Scaffold(
      appBar: AppBar(title: Text("Trading App")),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => MarketsBloc(
              repository: repository,
              storage: localStorage,
            )..add(LoadMarkets()),
          ),
        ],
        child: SafeArea(
          child: BlocBuilder<MarketsBloc, MarketsState>(
            builder: (context, state) {
              if (state is MarketsLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is MarketsLoaded) {
                return MarketListWidget(instruments: state.instruments);
              }
              if (state is MarketsEmpty) {
                return Center(child: Text("No markets available"));
              }
              if (state is MarketsError) {
                return Center(child: Text("Error: ${state.message}"));
              }
              return Center(child: Text("Welcome"));
            },
          ),
        ),
      ),
    );
  }
}
EOF
cat > lib/features/market/presentation/widgets/market_list_widget.dart << 'EOF'
import 'package:flutter/material.dart';

class MarketListWidget extends StatelessWidget {
  final List<String> instruments;

  MarketListWidget({required this.instruments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: instruments.length,
      itemBuilder: (ctx, i) {
        final symbol = instruments[i];
        return ListTile(
          title: Text(symbol),
          trailing: Icon(Icons.arrow_forward_ios),
        );
      },
    );
  }
}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_event.dart << 'EOF'
abstract class ChartEvent {}

/// تحميل أولي للبيانات
class LoadChartHistory extends ChartEvent {
  final String symbol;
  final String timeframe;
  LoadChartHistory({required this.symbol, required this.timeframe});
}

/// تحميل المزيد عند التمرير
class LoadMoreCandles extends ChartEvent {}

/// إضافة Tick لحظي جديد من WebSocket
class UpdateLiveTick extends ChartEvent {
  final double price;
  final DateTime time;
  UpdateLiveTick({required this.price, required this.time});
}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_state.dart << 'EOF'
import '../../../data/models/candle_model.dart';

abstract class ChartState {}

class ChartIdle extends ChartState {}

class ChartLoading extends ChartState {}

class ChartLoaded extends ChartState {
  final List<CandleModel> candles;
  final bool canLoadMore;
  ChartLoaded({required this.candles, this.canLoadMore = true});
}

class ChartError extends ChartState {
  final String message;
  ChartError(this.message);
}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chart_event.dart';
import 'chart_state.dart';
import '../../../data/models/candle_model.dart';
import '../../../data/repositories/market_repository_impl.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final MarketRepositoryImpl repository;
  final String symbol;
  final String timeframe;

  List<CandleModel> _candles = [];
  bool _isLoadingMore = false;
  int _loadCount = 100;

  ChartBloc({
    required this.repository,
    required this.symbol,
    required this.timeframe,
  }) : super(ChartIdle()) {
    on<LoadChartHistory>(_onInitialLoad);
    on<LoadMoreCandles>(_onLoadMore);
    on<UpdateLiveTick>(_onLiveTick);
  }

  Future<void> _onInitialLoad(
    LoadChartHistory event,
    Emitter<ChartState> emit,
  ) async {
    emit(ChartLoading());
    try {
      _candles = await repository.getHistoricalCandles(
        symbol: event.symbol,
        timeframe: event.timeframe,
        count: _loadCount,
      );
      emit(ChartLoaded(candles: _candles));
    } catch (e) {
      emit(ChartError("Failed to load chart data"));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreCandles event,
    Emitter<ChartState> emit,
  ) async {
    if (_isLoadingMore || _candles.isEmpty) return;
    _isLoadingMore = true;

    try {
      final oldest = _candles.first.time;

      final more = await repository.getHistoricalCandles(
        symbol: symbol,
        timeframe: timeframe,
        count: _loadCount,
        to: oldest.subtract(Duration(seconds: 1)),
      );

      if (more.isNotEmpty) {
        _candles = [...more, ..._candles];
        emit(ChartLoaded(candles: _candles));
      } else {
        emit(ChartLoaded(candles: _candles, canLoadMore: false));
      }
    } catch (_) {
      emit(ChartError("Failed to load more candles"));
    }

    _isLoadingMore = false;
  }

  void _onLiveTick(
    UpdateLiveTick event,
    Emitter<ChartState> emit,
  ) {
    if (_candles.isEmpty) return;

    final last = _candles.last;
    final now = event.time;

    if (_isSameCandle(now, last.time)) {
      last.updateClose(event.price);
      emit(ChartLoaded(candles: [..._candles]));
    } else {
      final newCandle = CandleModel.fromTick(event.price, now);
      _candles.add(newCandle);
      emit(ChartLoaded(candles: [..._candles]));
    }
  }

  bool _isSameCandle(DateTime a, DateTime b) {
    return a.difference(b).inMinutes == 0;
  }
}
EOF
cat > lib/features/market/data/datasources/oanda_ws_manager.dart << 'EOF'
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class OandaWebSocketManager {
  final String token;
  final String accountId;
  final String instrument;

  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>> _controller =
      StreamController.broadcast();

  Timer? _heartbeat;

  OandaWebSocketManager({
    required this.token,
    required this.accountId,
    required this.instrument,
  });

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void connect() {
    final uri = Uri(
      scheme: "wss",
      host: "stream-fxpractice.oanda.com",
      path: "/v3/pricing/stream",
      queryParameters: {"instruments": instrument},
    );

    _channel = WebSocketChannel.connect(uri, headers: {
      "Authorization": "Bearer $token",
    });

    _channel?.stream.listen(
      (msg) {
        try {
          final json = msg is String ? jsonDecode(msg) : {};
          _controller.add(json);
        } catch (_) {}
      },
      onError: _onError,
      onDone: _onDone,
    );

    _startHeartbeat();
  }

  void _startHeartbeat() {
    _heartbeat?.cancel();
    _heartbeat = Timer.periodic(Duration(seconds: 15), (_) {
      _channel?.sink.add("ping");
    });
  }

  void _onError(error) {
    disconnect();
    Future.delayed(Duration(seconds: 5), connect);
  }

  void _onDone() {
    disconnect();
    Future.delayed(Duration(seconds: 5), connect);
  }

  void disconnect() {
    _heartbeat?.cancel();
    _channel?.sink.close();
    _channel = null;
  }
}
EOF
cat > assets/chart.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>Chart</title>
  <script src="lightweight-charts.standalone.production.js"></script>
  <style>
    html, body { margin: 0; padding: 0; }
    #chart { height: 100%; width: 100%; }
  </style>
</head>
<body>
  <div id="chart"></div>
  <script>
    const chart = LightweightCharts.createChart(document.body, {
      layout: { textColor: '#d1d4dc', backgroundColor: '#000' },
      grid: { vertLines: { color: 'rgba(197, 203, 206, 0.5)' }},
    });
    const candleSeries = chart.addCandlestickSeries();

    function setHistory(data) {
      candleSeries.setData(data);
    }
    function updateCandle(candle) {
      candleSeries.update(candle);
    }
  </script>
</body>
</html>
EOF
cat > lib/features/market/presentation/widgets/webview_chart.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewChart extends StatefulWidget {
  final Function(String) onCreated;
  WebViewChart({required this.onCreated});

  @override
  _WebViewChartState createState() => _WebViewChartState();
}

class _WebViewChartState extends State<WebViewChart> {
  late WebViewController webController;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'assets/chart.html',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (ctrl) {
        webController = ctrl;
        widget.onCreated("");
      },
    );
  }
}
EOF
cat > lib/features/market/presentation/pages/market_chart_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chart/chart_bloc.dart';
import '../bloc/chart/chart_event.dart';
import '../bloc/chart/chart_state.dart';
import '../widgets/candlestick_chart_real.dart';

class MarketChartPage extends StatelessWidget {
  final String symbol;

  MarketChartPage({required this.symbol});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChartBloc(
        repository: RepositoryProvider.of(context),
        symbol: symbol,
        timeframe: "M1",
      )..add(LoadChartHistory(symbol: symbol, timeframe: "M1")),
      child: Scaffold(
        appBar: AppBar(title: Text("Chart — $symbol")),
        body: BlocBuilder<ChartBloc, ChartState>(
          builder: (context, state) {
            if (state is ChartLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is ChartLoaded) {
              return ListView(
                children: [
                  RealCandleStickChart(candles: state.candles),
                ],
              );
            }
            if (state is ChartError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
EOF
cat > lib/features/market/presentation/bloc/trading/trading_event.dart << 'EOF'
abstract class TradingEvent {}

/// Signals from Strategy to open a position
class NewSignal extends TradingEvent {
  final String instrument;
  final double price;
  NewSignal({required this.instrument, required this.price});
}

/// Called each time candle updates (History or Live)
class UpdateWithCandle extends TradingEvent {
  final candle;
  UpdateWithCandle(this.candle);
}

/// Manually close a position
class ClosePosition extends TradingEvent {
  final int index;
  ClosePosition(this.index);
}

/// Clear all positions/trade history
class ResetTrading extends TradingEvent {}
EOF
cat > lib/features/market/presentation/bloc/trading/trading_state.dart << 'EOF'
import '../../../domain/trading/trade_position.dart';
import '../../../domain/trading/trade_result.dart';

abstract class TradingState {}

class TradingIdle extends TradingState {}

class TradingUpdated extends TradingState {
  final List<TradePosition> openPositions;
  final List<TradeResult> tradeHistory;

  TradingUpdated({
    required this.openPositions,
    required this.tradeHistory,
  });
}

class TradingError extends TradingState {
  final String message;
  TradingError(this.message);
}
EOF
cat > lib/features/market/presentation/bloc/trading/trading_bloc.dart << 'EOF'
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../data/trading/virtual_exchange.dart';
import 'trading_event.dart';
import 'trading_state.dart';

class TradingBloc extends HydratedBloc<TradingEvent, TradingState> {
  final VirtualExchange _exchange = VirtualExchange();

  TradingBloc() : super(TradingIdle()) {
    on<NewSignal>(_onSignal);
    on<UpdateWithCandle>(_onUpdateCandle);
    on<ClosePosition>(_onClose);
    on<ResetTrading>(_onReset);
  }

  void _onSignal(NewSignal event, Emitter<TradingState> emit) {
    try {
      final pos = _exchange.createPosition(
        instrument: event.instrument,
        entryPrice: event.price,
      );

      if (pos != null) {
        emit(TradingUpdated(
          openPositions: _exchange.openPositions,
          tradeHistory: _exchange.tradeHistory,
        ));
      }
    } catch (e) {
      emit(TradingError("Error creating trade"));
    }
  }

  void _onUpdateCandle(UpdateWithCandle event, Emitter<TradingState> emit) {
    try {
      _exchange.updateWithNewCandle(event.candle);
      emit(TradingUpdated(
        openPositions: _exchange.openPositions,
        tradeHistory: _exchange.tradeHistory,
      ));
    } catch (e) {
      emit(TradingError("Error updating trades"));
    }
  }

  void _onClose(ClosePosition event, Emitter<TradingState> emit) {
    try {
      _exchange.manualClose(event.index);
      emit(TradingUpdated(
        openPositions: _exchange.openPositions,
        tradeHistory: _exchange.tradeHistory,
      ));
    } catch (e) {
      emit(TradingError("Close position failed"));
    }
  }

  void _onReset(ResetTrading event, Emitter<TradingState> emit) {
    _exchange.clearAll();
    emit(TradingUpdated(
      openPositions: _exchange.openPositions,
      tradeHistory: _exchange.tradeHistory,
    ));
  }

  @override
  TradingState? fromJson(Map<String, dynamic> json) {
    try {
      final openJson = json['open'] as List<dynamic>?;
      final histJson = json['history'] as List<dynamic>?;

      if (openJson != null && histJson != null) {
        _exchange.openPositions = openJson
            .map((e) => TradePosition.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        _exchange.tradeHistory = histJson
            .map((e) => TradeResult.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        return TradingUpdated(
          openPositions: _exchange.openPositions,
          tradeHistory: _exchange.tradeHistory,
        );
      }
    } catch (_) {}
    return TradingIdle();
  }

  @override
  Map<String, dynamic>? toJson(TradingState state) {
    if (state is TradingUpdated) {
      return {
        'open': state.openPositions
            .map((p) => p.toJson())
            .toList(),
        'history': state.tradeHistory
            .map((r) => r.toJson())
            .toList(),
      };
    }
    return null;
  }
}
EOF
cat > lib/features/market/presentation/widgets/trading_positions_widget.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/trading/trading_bloc.dart';
import '../bloc/trading/trading_state.dart';

class TradingPositionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradingBloc, TradingState>(
      builder: (context, state) {
        if (state is TradingUpdated) {
          return ListView(
            children: [
              ...state.openPositions.map((p) => ListTile(
                title: Text("${p.instrument}: ${p.type}"),
                subtitle: Text("Entry: ${p.entryPrice}"),
              )),
              Divider(),
              ...state.tradeHistory.map((h) => ListTile(
                title: Text("Closed: ${h.profit.toStringAsFixed(2)}"),
              )),
            ],
          );
        }
        return Text("No trades yet");
      },
    );
  }
}
EOF
cat > lib/core/widgets/error_view.dart << 'EOF'
import 'package:flutter/material.dart';

/// A reusable error widget.
/// Displays a message and a retry button.
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red),
            SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }
}
EOF
cat > lib/core/errors/app_error.dart << 'EOF'
abstract class AppError {
  String get message;
}

class NetworkError implements AppError {
  @override
  String get message => "No internet connection";
}

class ServerError implements AppError {
  final String details;
  ServerError(this.details);

  @override
  String get message => "Server error: $details";
}

class TimeoutError implements AppError {
  @override
  String get message => "Request timed out. Please try again.";
}

class InvalidCredentialsError implements AppError {
  @override
  String get message => "Invalid credentials. Please check your API Token and Account ID.";
}

class UnknownError implements AppError {
  @override
  String get message => "Something went wrong. Please retry.";
}
EOF
cat > lib/core/utils/network_checker.dart << 'EOF'
import 'dart:io';

class NetworkChecker {
  static Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
EOF
cat > lib/features/market/domain/strategy/strategy_config.dart << 'EOF'
class StrategyConfig {
  final int emaShort;
  final int emaLong;
  final int stochPeriod;
  final int stochSmoothK;
  final int stochSmoothD;
  final double stopLossPct;
  final double takeProfitPct;
  final double minSignalIntervalSeconds;

  StrategyConfig({
    required this.emaShort,
    required this.emaLong,
    required this.stochPeriod,
    required this.stochSmoothK,
    required this.stochSmoothD,
    required this.stopLossPct,
    required this.takeProfitPct,
    required this.minSignalIntervalSeconds,
  });
}
EOF
cat > lib/features/market/domain/strategy/strategy_manager.dart << 'EOF'
import '../entities/candle.dart';
import '../indicators/ema_calculator.dart';
import '../indicators/stochastic_calculator.dart';
import 'strategy_config.dart';

enum TradeSignal { BUY, SELL, NONE }

class StrategyManager {
  final List<CandleEntity> data;
  final StrategyConfig config;

  DateTime? _lastSignalTime;
  TradeSignal _lastSignal = TradeSignal.NONE;

  StrategyManager(this.data, this.config);

  TradeSignal evaluate() {
    if (data.length < config.emaLong) return TradeSignal.NONE;

    final emaShortVals = EmaCalculator.calculate(
      data: data,
      period: config.emaShort,
    ).values;

    final emaLongVals = EmaCalculator.calculate(
      data: data,
      period: config.emaLong,
    ).values;

    final stoch = StochasticCalculator.calculate(
      data: data,
      period: config.stochPeriod,
      smoothK: config.stochSmoothK,
      smoothD: config.stochSmoothD,
    );

    final int idx = data.length - 1;

    final bool bullCond = emaShortVals[idx] > emaLongVals[idx] &&
        stoch.kValues[idx] > stoch.dValues[idx] &&
        stoch.kValues[idx] < 80;

    final bool bearCond = emaShortVals[idx] < emaLongVals[idx] &&
        stoch.kValues[idx] < stoch.dValues[idx] &&
        stoch.kValues[idx] > 20;

    final now = data[idx].time;

    if (bullCond && _canSignal(now, TradeSignal.BUY)) {
      _updateLastSignal(now, TradeSignal.BUY);
      return TradeSignal.BUY;
    }

    if (bearCond && _canSignal(now, TradeSignal.SELL)) {
      _updateLastSignal(now, TradeSignal.SELL);
      return TradeSignal.SELL;
    }

    return TradeSignal.NONE;
  }

  bool _canSignal(DateTime now, TradeSignal signal) {
    if (_lastSignal == signal && _lastSignalTime != null) {
      final diff = now.difference(_lastSignalTime!).inSeconds;
      if (diff < config.minSignalIntervalSeconds) {
        return false;
      }
    }
    return true;
  }

  void _updateLastSignal(DateTime now, TradeSignal signal) {
    _lastSignalTime = now;
    _lastSignal = signal;
  }
}
EOF
cat > lib/features/market/domain/usecases/evaluate_strategy.dart << 'EOF'
import '../strategy/strategy_config.dart';
import '../strategy/strategy_manager.dart';
import '../entities/candle.dart';

class EvaluateStrategy {
  TradeSignal call({
    required List<CandleEntity> candles,
    required StrategyConfig config,
  }) {
    final mgr = StrategyManager(candles, config);
    return mgr.evaluate();
  }
}
EOF
cat > tmp_strategy_integration.patch << 'EOF'
--- a/lib/features/market/presentation/bloc/chart/chart_bloc.dart
+++ b/lib/features/market/presentation/bloc/chart/chart_bloc.dart
@@ -1,6 +1,7 @@
 import 'package:flutter_bloc/flutter_bloc.dart';
 import 'chart_event.dart';
 import 'chart_state.dart';
+import '../../../domain/usecases/evaluate_strategy.dart';
+import '../../../domain/strategy/strategy_config.dart';
 import '../../../data/models/candle_model.dart';
 import '../../../data/repositories/market_repository_impl.dart';

@@ -50,10 +51,20 @@ class ChartBloc extends Bloc<ChartEvent, ChartState> {
       add(UpdateLiveTick(price: price, time: DateTime.parse(json["time"])));
     });
 
-    on<UpdateLiveTick>(_onLiveTick);
+    on<UpdateLiveTick>((event, emit) {
+      _onLiveTick(event, emit);
+
+      // SIGNAL LOGIC
+      final config = StrategyConfig(
+        emaShort: 50,
+        emaLong: 200,
+        stochPeriod: 14,
+        stochSmoothK: 3,
+        stochSmoothD: 3,
+        stopLossPct: 0.002,
+        takeProfitPct: 0.005,
+        minSignalIntervalSeconds: 60,
+      );
+      final signal = EvaluateStrategy().call(
+        candles: _candles.map((c) => c.toEntity()).toList(),
+        config: config,
+      );
+      if (signal != TradeSignal.NONE) {
+        tradingBloc.add(NewSignal(
+          instrument: symbol,
+          price: event.price,
+          signalType: signal,
+        ));
+      }
+    });
EOF
cat > lib/features/market/presentation/widgets/signal_marker.dart << 'EOF'
import 'package:flutter/material.dart';

class SignalMarker extends StatelessWidget {
  final bool isBuy;
  final Offset position;
  final String label;

  SignalMarker({
    required this.isBuy,
    required this.position,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Column(
        children: [
          Icon(
            isBuy ? Icons.arrow_circle_up : Icons.arrow_circle_down,
            color: isBuy ? Colors.green : Colors.red,
            size: 28,
          ),
          Text(label),
        ],
      ),
    );
  }
}
EOF
cat > lib/core/utils/secure_storage.dart << 'EOF'
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Singleton
  static final _storage = FlutterSecureStorage();

  static const _keyApiToken = "secure_oanda_api_token";
  static const _keyAccountId = "secure_oanda_account_id";

  /// Save credentials securely
  static Future<void> saveCredentials({
    required String apiToken,
    required String accountId,
  }) async {
    await _storage.write(key: _keyApiToken, value: apiToken);
    await _storage.write(key: _keyAccountId, value: accountId);
  }

  /// Read secure keys
  static Future<Map<String, String>?> readCredentials() async {
    final token = await _storage.read(key: _keyApiToken);
    final accId = await _storage.read(key: _keyAccountId);

    if (token == null || accId == null) return null;

    return {
      "apiToken": token,
      "accountId": accId,
    };
  }

  /// Delete secure keys
  static Future<void> clearCredentials() async {
    await _storage.delete(key: _keyApiToken);
    await _storage.delete(key: _keyAccountId);
  }
}
EOF
cat > lib/features/market/data/datasources/local_storage.dart << 'EOF'
import '../../../core/utils/secure_storage.dart';

class LocalStorage {
  Future<void> saveOandaCredentials({
    required String apiToken,
    required String accountId,
  }) async {
    await SecureStorage.saveCredentials(
      apiToken: apiToken,
      accountId: accountId,
    );
  }

  Future<Map<String, String>?> getOandaCredentials() async {
    return await SecureStorage.readCredentials();
  }

  Future<void> clearOandaCredentials() async {
    await SecureStorage.clearCredentials();
  }
}
EOF
cat > build.yaml << 'EOF'
targets:
  $default:
    builders:
      dart2js:
        options:
          dart2js_args:
            - --minify
            - --trust-primitives
EOF
cat > .github/workflows/flutter_ci_cd.yml << 'EOF'
name: Flutter CI/CD Pipeline

on:
  push:
    branches: [ "main", "master" ]
  pull_request:
    branches: [ "main", "master" ]

jobs:
  test_build:
    name: Test & Build
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'

      - name: Install dependencies

      - name: Run Flutter format check
        run: flutter format --set-exit-if-changed .

      - name: Run unit & widget tests

      - name: Build APK (debug)

      - name: Upload coverage reports
        uses: actions/upload-artifact@v3
        with:
          name: coverage-report
          path: coverage

  release_build:
    name: Build Release Artifacts
    runs-on: ubuntu-latest
    needs: test_build

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'

      - name: Install dependencies

      - name: Build Release APK (with obfuscation)

      - name: Upload release artifact
        uses: actions/upload-artifact@v3
        with:
          name: Android-Release-APK
          path: build/app/outputs/flutter-apk/app-release.apk
EOF
cat > lib/features/market/presentation/pages/interactive_chart_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:candlesticks/candlesticks.dart';

import '../bloc/chart/chart_bloc.dart';
import '../bloc/chart/chart_event.dart';
import '../bloc/chart/chart_state.dart';

class InteractiveChartPage extends StatelessWidget {
  final String symbol;

  InteractiveChartPage({required this.symbol});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChartBloc(
        repository: RepositoryProvider.of(context),
        symbol: symbol,
        timeframe: "M1",
      )..add(LoadChartHistory(symbol: symbol, timeframe: "M1")),
      child: _InteractiveChartView(symbol: symbol),
    );
  }
}

class _InteractiveChartView extends StatefulWidget {
  final String symbol;
  _InteractiveChartView({required this.symbol});

  @override
  __InteractiveChartViewState createState() => __InteractiveChartViewState();
}

class __InteractiveChartViewState extends State<_InteractiveChartView> {
  List<Candle> _candleItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chart — ${widget.symbol}")),
      body: BlocBuilder<ChartBloc, ChartState>(
        builder: (context, state) {
          if (state is ChartLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ChartLoaded) {
            _candleItems = state.candles.map((c) => Candle(
              date: c.time,
              open: c.open,
              high: c.high,
              low: c.low,
              close: c.close,
              volume: c.volume.toDouble(),
            )).toList();

            return Column(
              children: [
                Expanded(
                  child: Candlesticks(
                    candles: _candleItems,
                    showVolume: true,
                    onIndicatorChange: (i) {},
                  ),
                ),
              ],
            );
          }
          if (state is ChartError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return Container();
        },
      ),
    );
  }
}
EOF
cat > lib/features/market/presentation/widgets/crosshair_overlay.dart << 'EOF'
import 'package:flutter/material.dart';

class CrosshairOverlay extends StatelessWidget {
  final Offset position;
  CrosshairOverlay({required this.position});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: 0,
          bottom: 0,
          child: Container(width: 1, color: Colors.grey),
        ),
        Positioned(
          top: position.dy,
          left: 0,
          right: 0,
          child: Container(height: 1, color: Colors.grey),
        ),
      ],
    );
  }
}
EOF
cat > lib/features/market/data/datasources/timeframe_storage.dart << 'EOF'
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TimeframeStorage {
  static final _storage = FlutterSecureStorage();
  static const _key = "last_selected_timeframe";

  static Future<void> save(String tf) async {
    await _storage.write(key: _key, value: tf);
  }

  static Future<String> load() async {
    final v = await _storage.read(key: _key);
    return v ?? "M1";
  }
}
EOF
cat >> lib/features/market/presentation/bloc/chart/chart_bloc.dart << 'EOF'

  Future<void> _onChangeTimeframe(
    ChangeTimeframe event,
    Emitter<ChartState> emit,
  ) async {
    emit(ChartLoading());

    // حفظ الاختيار
    await TimeframeStorage.save(event.timeframe);

    // تحديث الفريم الداخلي
    this.timeframe = event.timeframe;

    try {
      _candles = await repository.getHistoricalCandles(
        symbol: symbol,
        timeframe: event.timeframe,
        count: _loadCount,
      );

      // إعادة تهيئة WebSocket بنفس الفريم
      await wsManager.disconnect();
      await wsManager.connectWithTimeframe(event.timeframe);

      emit(ChartLoaded(candles: _candles));
    } catch (e) {
      emit(ChartError("Failed to change timeframe"));
    }
  }
EOF
cat >> lib/features/market/data/datasources/oanda_ws_manager.dart << 'EOF'

  Future<void> connectWithTimeframe(String tf) async {
    currentTimeframe = tf;
    disconnect();
    connect();
  }
EOF
cat > lib/features/market/presentation/widgets/timeframe_selector.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chart/chart_bloc.dart';
import '../bloc/chart/chart_event.dart';

class TimeframeSelector extends StatefulWidget {
  final List<String> frames;

  const TimeframeSelector({required this.frames});

  @override
  _TimeframeSelectorState createState() => _TimeframeSelectorState();
}

class _TimeframeSelectorState extends State<TimeframeSelector> {
  String selected = "M1";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.frames.map((f) {
          final isSelected = f == selected;
          return GestureDetector(
            onTap: () {
              setState(() => selected = f);
              context.read<ChartBloc>().add(ChangeTimeframe(f));
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  f,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
EOF
cat > lib/features/market/presentation/bloc/drawing_tools/drawing_event.dart << 'EOF'
abstract class DrawingEvent {}

class StartTrendline extends DrawingEvent {}

class AddPointToTrendline extends DrawingEvent {
  final double x;
  final double y;
  AddPointToTrendline({required this.x, required this.y});
}

class CompleteTrendline extends DrawingEvent {}

class ClearAllDrawings extends DrawingEvent {}

class AddHorizontalLine extends DrawingEvent {
  final double priceY;
  AddHorizontalLine({required this.priceY});
}
EOF
cat > lib/features/market/presentation/bloc/drawing_tools/drawing_state.dart << 'EOF'
import 'package:flutter/material.dart';

abstract class DrawingState {}

class NoDrawing extends DrawingState {}

class DrawingTrendline extends DrawingState {
  final List<Offset> points;
  DrawingTrendline({required this.points});
}

class DrawingComplete extends DrawingState {
  final List<List<Offset>> trendlines;
  final List<double> horizontalLines;
  DrawingComplete({
    required this.trendlines,
    required this.horizontalLines,
  });
}
EOF
cat > lib/features/market/presentation/bloc/drawing_tools/drawing_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'drawing_event.dart';
import 'drawing_state.dart';

class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  List<List<Offset>> _trendlines = [];
  List<double> _horizontalLines = [];

  List<Offset> _currentPoints = [];

  DrawingBloc() : super(NoDrawing()) {
    on<StartTrendline>((event, emit) {
      _currentPoints = [];
      emit(DrawingTrendline(points: _currentPoints));
    });

    on<AddPointToTrendline>((event, emit) {
      _currentPoints.add(Offset(event.x, event.y));
      emit(DrawingTrendline(points: _currentPoints));
    });

    on<CompleteTrendline>((event, emit) {
      if (_currentPoints.length >= 2) {
        _trendlines.add(List<Offset>.from(_currentPoints));
      }
      _currentPoints = [];
      emit(DrawingComplete(
        trendlines: _trendlines,
        horizontalLines: _horizontalLines,
      ));
    });

    on<AddHorizontalLine>((event, emit) {
      _horizontalLines.add(event.priceY);
      emit(DrawingComplete(
        trendlines: _trendlines,
        horizontalLines: _horizontalLines,
      ));
    });

    on<ClearAllDrawings>((event, emit) {
      _trendlines.clear();
      _horizontalLines.clear();
      emit(DrawingComplete(
        trendlines: _trendlines,
        horizontalLines: _horizontalLines,
      ));
    });
  }
}
EOF
cat > lib/features/market/presentation/widgets/drawing_tools/drawing_overlay.dart << 'EOF'
import 'package:flutter/material.dart';

class DrawingOverlay extends StatelessWidget {
  final List<List<Offset>> trendlines;
  final List<double> horizontalLines;

  DrawingOverlay({
    required this.trendlines,
    required this.horizontalLines,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OverlayPainter(
        trendlines: trendlines,
        horizontalLines: horizontalLines,
      ),
      child: Container(),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final List<List<Offset>> trendlines;
  final List<double> horizontalLines;

  _OverlayPainter({
    required this.trendlines,
    required this.horizontalLines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2;

    final paintHLine = Paint()
      ..color = Colors.orange
      ..strokeWidth = 1;

    // Trendlines
    for (var line in trendlines) {
      if (line.length >= 2) {
        canvas.drawLine(line[0], line[1], paintLine);
      }
    }

    // Horizontal lines
    for (var y in horizontalLines) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paintHLine,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter old) {
    return old.trendlines != trendlines ||
        old.horizontalLines != horizontalLines;
  }
}
EOF
cat >> lib/features/market/presentation/pages/interactive_chart_page.dart << 'EOF'

// داخل الـ AppBar:
actions: [
  IconButton(
    icon: Icon(Icons.show_chart),
    onPressed: () => context.read<DrawingBloc>().add(StartTrendline()),
  ),
  IconButton(
    icon: Icon(Icons.horizontal_rule),
    onPressed: () => context.read<DrawingBloc>().add(AddHorizontalLine(priceY: 0)),
  ),
],
EOF
cat > lib/features/market/domain/indicators/indicator_series.dart << 'EOF'
class IndicatorSeries {
  final List<double> values;
  final String label;
  final Color color;

  IndicatorSeries({
    required this.values,
    required this.label,
    required this.color,
  });
}
EOF
cat > lib/features/market/presentation/widgets/indicator_overlay.dart << 'EOF'
import 'package:flutter/material.dart';

class IndicatorOverlay extends StatelessWidget {
  final List<List<Offset>> indicatorLines;

  IndicatorOverlay({required this.indicatorLines});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _IndicatorPainter(indicatorLines),
      child: Container(),
    );
  }
}

class _IndicatorPainter extends CustomPainter {
  final List<List<Offset>> indicatorLines;

  _IndicatorPainter(this.indicatorLines);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (var series in indicatorLines) {
      paint.color = Colors.green;
      canvas.drawPoints(PointMode.polygon, series, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _IndicatorPainter old) =>
      old.indicatorLines != indicatorLines;
}
EOF
cat > lib/core/notifications/notification_service.dart << 'EOF'
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings =
        InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'trading_alerts',
        'Trading Alerts',
        channelDescription: 'Smart alerts for trading signals and prices',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
    );

    await _plugin.show(id, title, body, details);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'trading_alerts',
        'Trading Alerts',
        channelDescription: 'Smart alerts for trading signals and prices',
      ),
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
EOF
cat > lib/features/market/domain/alerts/price_alert.dart << 'EOF'
class PriceAlert {
  final double price;
  final bool triggerAbove;
  final String symbol;

  PriceAlert({
    required this.price,
    required this.triggerAbove,
    required this.symbol,
  });
}
EOF
cat > lib/features/market/presentation/bloc/alerts/alert_event.dart << 'EOF'
import '../../../domain/alerts/price_alert.dart';

abstract class AlertEvent {}

class AddPriceAlert extends AlertEvent {
  final PriceAlert alert;
  AddPriceAlert(this.alert);
}

class RemovePriceAlert extends AlertEvent {
  final int index;
  RemovePriceAlert(this.index);
}

class CheckPriceAlerts extends AlertEvent {
  final double currentPrice;
  CheckPriceAlerts(this.currentPrice);
}
EOF
cat > lib/features/market/presentation/bloc/alerts/alert_state.dart << 'EOF'
import '../../../domain/alerts/price_alert.dart';

abstract class AlertState {}

class AlertIdle extends AlertState {}

class AlertUpdated extends AlertState {
  final List<PriceAlert> alerts;
  AlertUpdated(this.alerts);
}
EOF
cat > lib/features/market/presentation/bloc/alerts/alert_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/alerts/price_alert.dart';
import 'alert_event.dart';
import 'alert_state.dart';
import '../../../../core/notifications/notification_service.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final List<PriceAlert> _alerts = [];

  AlertBloc() : super(AlertIdle()) {
    on<AddPriceAlert>((event, emit) {
      _alerts.add(event.alert);
      emit(AlertUpdated(List.from(_alerts)));
    });

    on<RemovePriceAlert>((event, emit) {
      if (event.index >= 0 && event.index < _alerts.length) {
        _alerts.removeAt(event.index);
      }
      emit(AlertUpdated(List.from(_alerts)));
    });

    on<CheckPriceAlerts>((event, emit) {
      final price = event.currentPrice;

      for (var alert in List.from(_alerts)) {
        bool shouldTrigger =
            (alert.triggerAbove && price >= alert.price) ||
            (!alert.triggerAbove && price <= alert.price);

        if (shouldTrigger) {
          NotificationService().showInstantNotification(
            id: DateTime.now().millisecond,
            title: "Price Alert: ${alert.symbol}",
            body:
                "Price reached ${alert.price} (current: ${price.toStringAsFixed(4)})",
          );

          _alerts.remove(alert);
        }
      }

      emit(AlertUpdated(List.from(_alerts)));
    });
  }
}
EOF
cat > lib/features/market/presentation/widgets/price_alert_dialog.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/alerts/alert_bloc.dart';
import '../bloc/alerts/alert_event.dart';
import '../../domain/alerts/price_alert.dart';

class PriceAlertDialog extends StatefulWidget {
  final String symbol;
  PriceAlertDialog({required this.symbol});

  @override
  _PriceAlertDialogState createState() => _PriceAlertDialogState();
}

class _PriceAlertDialogState extends State<PriceAlertDialog> {
  final TextEditingController _priceCtrl = TextEditingController();
  bool triggerAbove = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Price Alert"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _priceCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Target Price"),
          ),
          Row(
            children: [
              Text("Trigger when:"),
              Switch(
                value: triggerAbove,
                onChanged: (v) => setState(() => triggerAbove = v),
              ),
              Text(triggerAbove ? "Above" : "Below"),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final price = double.tryParse(_priceCtrl.text);
            if (price != null) {
              context.read<AlertBloc>().add(
                    AddPriceAlert(
                      PriceAlert(
                        price: price,
                        triggerAbove: triggerAbove,
                        symbol: widget.symbol,
                      ),
                    ),
                  );
              Navigator.pop(context);
            }
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
EOF
cat > lib/features/market/presentation/pages/alerts/alerts_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/alerts/alert_bloc.dart';
import '../../bloc/alerts/alert_state.dart';
import '../../bloc/alerts/alert_event.dart';
import '../../../domain/alerts/price_alert.dart';

class AlertsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Alerts"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              context.read<AlertBloc>().add(RemovePriceAlert(-1));
            },
          ),
        ],
      ),
      body: BlocBuilder<AlertBloc, AlertState>(
        builder: (context, state) {
          if (state is AlertUpdated) {
            final alerts = state.alerts;
            if (alerts.isEmpty) {
              return Center(child: Text("No alerts set"));
            }
            return ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (ctx, i) {
                final PriceAlert a = alerts[i];
                return ListTile(
                  title: Text("${a.symbol} @ ${a.price.toStringAsFixed(4)}"),
                  subtitle: Text(a.triggerAbove ? "Above" : "Below"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(context, a, i);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          context.read<AlertBloc>().add(RemovePriceAlert(i));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(child: Text("Loading alerts..."));
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, PriceAlert alert, int index) {
    final TextEditingController _priceCtrl =
        TextEditingController(text: alert.price.toString());
    bool triggerAbove = alert.triggerAbove;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Alert"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Target Price"),
            ),
            Row(
              children: [
                Text("Trigger when:"),
                Switch(
                  value: triggerAbove,
                  onChanged: (v) => triggerAbove = v,
                ),
                Text(triggerAbove ? "Above" : "Below"),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final double? newPrice = double.tryParse(_priceCtrl.text);
              if (newPrice != null) {
                // حذف القديم واضافة الجديد
                context.read<AlertBloc>().add(RemovePriceAlert(index));
                context.read<AlertBloc>().add(AddPriceAlert(
                      PriceAlert(
                        price: newPrice,
                        triggerAbove: triggerAbove,
                        symbol: alert.symbol,
                      ),
                    ));
              }
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
EOF
cat > lib/features/market/presentation/bloc/backtest/backtest_event.dart << 'EOF'
abstract class BacktestEvent {}

/// Run a backtest with specific start/end dates (optional)
class RunBacktestEvent extends BacktestEvent {
  final String symbol;
  final String timeframe;
  final DateTime? start;
  final DateTime? end;

  RunBacktestEvent({
    required this.symbol,
    required this.timeframe,
    this.start,
    this.end,
  });
}

/// Clear last results
class ClearBacktestEvent extends BacktestEvent {}
EOF
cat > lib/features/market/presentation/bloc/backtest/backtest_state.dart << 'EOF'
import '../../../domain/backtest/backtest_result.dart';

abstract class BacktestState {}

class BacktestIdle extends BacktestState {}

class BacktestRunning extends BacktestState {}

class BacktestSuccess extends BacktestState {
  final BacktestResult result;
  BacktestSuccess(this.result);
}

class BacktestError extends BacktestState {
  final String message;
  BacktestError(this.message);
}
EOF
cat > lib/features/market/presentation/bloc/backtest/backtest_bloc.dart << 'EOF'
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../domain/usecases/run_backtest.dart';
import 'backtest_event.dart';
import 'backtest_state.dart';

class BacktestBloc extends HydratedBloc<BacktestEvent, BacktestState> {
  final RunBacktest _runBacktest;

  BacktestBloc(this._runBacktest) : super(BacktestIdle()) {
    on<RunBacktestEvent>(_onRunBacktest);
    on<ClearBacktestEvent>(_onClear);
  }

  Future<void> _onRunBacktest(
    RunBacktestEvent event,
    Emitter<BacktestState> emit,
  ) async {
    emit(BacktestRunning());
    try {
      final result = await _runBacktest.call(
        event.symbol,
        event.timeframe,
        event.start,
        event.end,
      );

      emit(BacktestSuccess(result));
    } catch (e) {
      emit(BacktestError("Backtest failed: ${e.toString()}"));
    }
  }

  void _onClear(
    ClearBacktestEvent event,
    Emitter<BacktestState> emit,
  ) {
    emit(BacktestIdle());
  }

  @override
  BacktestState? fromJson(Map<String, dynamic> json) {
    try {
      // Deserialize BacktestResult if present
      if (json.containsKey('result')) {
        final result = BacktestResult.fromJson(
          Map<String, dynamic>.from(json['result']),
        );
        return BacktestSuccess(result);
      }
    } catch (_) {}
    return BacktestIdle();
  }

  @override
  Map<String, dynamic>? toJson(BacktestState state) {
    if (state is BacktestSuccess) {
      return {'result': state.result.toJson()};
    }
    return null;
  }
}
EOF
cat > lib/features/market/domain/usecases/run_backtest.dart << 'EOF'
import '../backtest/backtest_engine.dart';
import '../backtest/backtest_result.dart';
import '../entities/candle.dart';

class RunBacktest {
  Future<BacktestResult> call(
    String symbol,
    String timeframe,
    DateTime? start,
    DateTime? end,
  ) async {
    // جلب التاريخ (مثلاً من Repo)
    final history = await repository.getHistoricalCandles(
      symbol: symbol,
      timeframe: timeframe,
      start: start,
      end: end,
    );

    final engine = BacktestEngine(history);
    return engine.run();
  }
}
EOF
cat > lib/features/market/presentation/pages/backtest/backtest_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/backtest/backtest_bloc.dart';
import '../../bloc/backtest/backtest_event.dart';
import '../../bloc/backtest/backtest_state.dart';

class BacktestPage extends StatelessWidget {
  final String symbol;

  BacktestPage({required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Backtest — $symbol")),
      body: Column(
        children: [
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              context.read<BacktestBloc>().add(
                    RunBacktestEvent(
                      symbol: symbol,
                      timeframe: "M1",
                      start: null,
                      end: null,
                    ),
                  );
            },
            child: Text("Start Backtest"),
          ),
          SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<BacktestBloc, BacktestState>(
              builder: (context, state) {
                if (state is BacktestRunning) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is BacktestSuccess) {
                  final result = state.result;
                  return Column(
                    children: [
                      Text("Net Profit: ${result.netProfit.toStringAsFixed(2)}"),
                      Text("Win Rate: ${result.winRate.toStringAsFixed(2)}%"),
                      Text("Max Drawdown: ${result.maxDrawdown.toStringAsFixed(2)}"),
                      Expanded(
                        child: ListView.builder(
                          itemCount: result.equityCurve.length,
                          itemBuilder: (ctx, i) {
                            return ListTile(
                              title: Text(result.timestamps[i].toIso8601String()),
                              trailing: Text(result.equityCurve[i].toStringAsFixed(2)),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                if (state is BacktestError) {
                  return Center(
                    child: Text("Error: ${state.message}"),
                  );
                }
                return Center(child: Text("Press Start to Run Backtest"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
EOF
cat > lib/features/market/presentation/bloc/settings/settings_event.dart << 'EOF'
abstract class SettingsEvent {}

/// تحميل الإعدادات الحالية
class LoadSettingsEvent extends SettingsEvent {}

/// تحديث إعدادات الاستراتيجية
class UpdateStrategySettings extends SettingsEvent {
  final int emaShort;
  final int emaLong;
  final int stochPeriod;
  final int stochSmoothK;
  final int stochSmoothD;
  final double stopLossPct;
  final double takeProfitPct;

  UpdateStrategySettings({
    required this.emaShort,
    required this.emaLong,
    required this.stochPeriod,
    required this.stochSmoothK,
    required this.stochSmoothD,
    required this.stopLossPct,
    required this.takeProfitPct,
  });
}
EOF
cat > lib/features/market/presentation/bloc/settings/settings_state.dart << 'EOF'
import '../../../domain/strategy/strategy_config.dart';

abstract class SettingsState {}

class SettingsIdle extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final StrategyConfig config;
  SettingsLoaded(this.config);
}

class SettingsError extends SettingsState {
  final String message;
  SettingsError(this.message);
}
EOF
cat > lib/features/market/presentation/bloc/settings/settings_bloc.dart << 'EOF'
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../domain/strategy/strategy_config.dart';
import '../../data/storage/settings_storage.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  final SettingsStorage _storage = SettingsStorage();

  SettingsBloc() : super(SettingsIdle()) {
    on<LoadSettingsEvent>(_onLoad);
    on<UpdateStrategySettings>(_onUpdate);
  }

  Future<void> _onLoad(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final settings = _storage.getStrategySettings() ??
          StrategyConfig(
            emaShort: 50,
            emaLong: 200,
            stochPeriod: 14,
            stochSmoothK: 3,
            stochSmoothD: 3,
            stopLossPct: 0.002,
            takeProfitPct: 0.005,
            minSignalIntervalSeconds: 60,
          );

      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError("Failed to load settings"));
    }
  }

  Future<void> _onUpdate(
    UpdateStrategySettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final config = StrategyConfig(
        emaShort: event.emaShort,
        emaLong: event.emaLong,
        stochPeriod: event.stochPeriod,
        stochSmoothK: event.stochSmoothK,
        stochSmoothD: event.stochSmoothD,
        stopLossPct: event.stopLossPct,
        takeProfitPct: event.takeProfitPct,
        minSignalIntervalSeconds: 60,
      );

      await _storage.saveStrategySettings(config);
      emit(SettingsLoaded(config));
    } catch (e) {
      emit(SettingsError("Failed to update settings"));
    }
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    try {
      final config = StrategyConfig.fromJson(
        Map<String, dynamic>.from(json['config']),
      );
      return SettingsLoaded(config);
    } catch (_) {}
    return SettingsIdle();
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    if (state is SettingsLoaded) {
      return {'config': state.config.toJson()};
    }
    return null;
  }
}
EOF
cat > lib/features/market/presentation/pages/settings/strategy_settings_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/settings/settings_event.dart';
import '../../bloc/settings/settings_state.dart';

class StrategySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Strategy Settings")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is SettingsLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is SettingsLoaded) {
              final config = state.config;
              final emaShortCtrl =
                  TextEditingController(text: config.emaShort.toString());
              final emaLongCtrl =
                  TextEditingController(text: config.emaLong.toString());
              final stochPeriodCtrl =
                  TextEditingController(text: config.stochPeriod.toString());
              final stochSmoothKCtrl =
                  TextEditingController(text: config.stochSmoothK.toString());
              final stochSmoothDCtrl =
                  TextEditingController(text: config.stochSmoothD.toString());
              final slCtrl =
                  TextEditingController(text: config.stopLossPct.toString());
              final tpCtrl =
                  TextEditingController(text: config.takeProfitPct.toString());

              return ListView(
                children: [
                  TextField(
                    controller: emaShortCtrl,
                    decoration: InputDecoration(labelText: "EMA Short"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: emaLongCtrl,
                    decoration: InputDecoration(labelText: "EMA Long"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: stochPeriodCtrl,
                    decoration: InputDecoration(labelText: "Stoch Period"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: stochSmoothKCtrl,
                    decoration: InputDecoration(labelText: "Stoch Smooth K"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: stochSmoothDCtrl,
                    decoration: InputDecoration(labelText: "Stoch Smooth D"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: slCtrl,
                    decoration: InputDecoration(labelText: "Stop Loss %"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  TextField(
                    controller: tpCtrl,
                    decoration: InputDecoration(labelText: "Take Profit %"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SettingsBloc>().add(
                            UpdateStrategySettings(
                              emaShort: int.parse(emaShortCtrl.text),
                              emaLong: int.parse(emaLongCtrl.text),
                              stochPeriod: int.parse(stochPeriodCtrl.text),
                              stochSmoothK: int.parse(stochSmoothKCtrl.text),
                              stochSmoothD: int.parse(stochSmoothDCtrl.text),
                              stopLossPct: double.parse(slCtrl.text),
                              takeProfitPct: double.parse(tpCtrl.text),
                            ),
                          );
                    },
                    child: Text("Save Settings"),
                  ),
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
EOF
cat >> lib/features/market/presentation/bloc/chart/chart_bloc.dart << 'EOF'

    // Listen to settings changes
    settingsBloc.stream.listen((state) {
      if (state is SettingsLoaded) {
        _applyNewSettings(state.config);
      }
    });
EOF
cat >> lib/features/market/presentation/bloc/chart/chart_bloc.dart << 'EOF'

  void _applyNewSettings(StrategyConfig config) {
    // Logic to update strategy with new params
    _strategyConfig = config;

    // Optionally re‑evaluate current chart
    add(LoadChartHistory(symbol: symbol, timeframe: timeframe));
  }
EOF
cat >> lib/features/market/presentation/bloc/trading/trading_bloc.dart << 'EOF'

    // Listen for settings updates
    settingsBloc.stream.listen((state) {
      if (state is SettingsLoaded) {
        _strategyConfig = state.config;
      }
    });
EOF
cat >> lib/features/market/presentation/bloc/backtest/backtest_bloc.dart << 'EOF'

    settingsBloc.stream.listen((state) {
      if (state is SettingsLoaded) {
        _strategyConfig = state.config;
      }
    });
EOF
cat > lib/core/isolate/isolate_helpers.dart << 'EOF'
import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../../features/market/domain/indicators/ema.dart';
import '../../features/market/domain/indicators/stochastic.dart';
import '../../features/market/domain/entities/candle.dart';

class IndicatorParams {
  final List<Candle> candles;
  final int emaShort;
  final int emaLong;
  final int stochPeriod;
  final int stochSmoothK;
  final int stochSmoothD;

  IndicatorParams({
    required this.candles,
    required this.emaShort,
    required this.emaLong,
    required this.stochPeriod,
    required this.stochSmoothK,
    required this.stochSmoothD,
  });
}

class IndicatorResult {
  final List<double> emaShort;
  final List<double> emaLong;
  final List<double> stochK;
  final List<double> stochD;

  IndicatorResult({
    required this.emaShort,
    required this.emaLong,
    required this.stochK,
    required this.stochD,
  });
}

Future<IndicatorResult> computeIndicatorsInBackground(IndicatorParams params) async {
  return await compute(_calculateIndicators, params);
}

IndicatorResult _calculateIndicators(IndicatorParams params) {
  try {
    final emaShort = calculateEMA(params.candles, params.emaShort);
    final emaLong = calculateEMA(params.candles, params.emaLong);
    final stochK = calculateStochK(params.candles, params.stochPeriod, params.stochSmoothK);
    final stochD = smoothStochD(stochK, params.stochSmoothD);

    return IndicatorResult(
      emaShort: emaShort,
      emaLong: emaLong,
      stochK: stochK,
      stochD: stochD,
    );
  } catch (e) {
    log("Indicator isolate error: $e");
    rethrow;
  }
}
EOF
cat > lib/features/market/presentation/widgets/custom_chart/candles_painter.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../domain/entities/candle.dart';

class CandlesPainter extends CustomPainter {
  final List<CandleEntity> candles;
  final double candleWidth;

  CandlesPainter({
    required this.candles,
    this.candleWidth = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final paintRise = Paint()..color = Colors.green;
    final paintFall = Paint()..color = Colors.red;
    final paintLine = Paint()..color = Colors.black;

    // احسب الأسعار العليا والدنيا ليتناسب الرسم
    final highs = candles.map((c) => c.high).toList();
    final lows = candles.map((c) => c.low).toList();

    final maxPrice = highs.reduce((a, b) => a > b ? a : b);
    final minPrice = lows.reduce((a, b) => a < b ? a : b);

    final priceRange = maxPrice - minPrice;

    final count = candles.length;
    final spacing = candleWidth + 2.0;
    final chartWidth = count * spacing;

    for (int i = 0; i < count; i++) {
      final c = candles[i];

      final x = i * spacing;
      final highY = size.height - ((c.high - minPrice) / priceRange) * size.height;
      final lowY = size.height - ((c.low - minPrice) / priceRange) * size.height;
      final openY = size.height - ((c.open - minPrice) / priceRange) * size.height;
      final closeY = size.height - ((c.close - minPrice) / priceRange) * size.height;

      final isRise = c.close >= c.open;
      final paint = isRise ? paintRise : paintFall;

      // خطوط High-Low
      canvas.drawLine(
        Offset(x + candleWidth / 2, highY),
        Offset(x + candleWidth / 2, lowY),
        paintLine,
      );

      // مستطيل Open-Close
      final rect = Rect.fromLTRB(
        x,
        openY,
        x + candleWidth,
        closeY,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CandlesPainter old) =>
      old.candles != candles;
}
EOF
cat > lib/features/market/presentation/widgets/custom_chart/indicator_painter.dart << 'EOF'
import 'package:flutter/material.dart';

class IndicatorPainter extends CustomPainter {
  final List<Offset> linePoints;
  final Color color;

  IndicatorPainter({required this.linePoints, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (linePoints.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawPoints(PointMode.polygon, linePoints, paint);
  }

  @override
  bool shouldRepaint(covariant IndicatorPainter old) =>
      old.linePoints != linePoints;
}
EOF
cat > lib/features/market/presentation/widgets/custom_chart/drawing_painter.dart << 'EOF'
import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> trendlines;
  final List<double> horizontalLines;

  DrawingPainter({
    required this.trendlines,
    required this.horizontalLines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintTrend = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2.0;

    final paintHLine = Paint()
      ..color = Colors.orange
      ..strokeWidth = 1.0;

    // Trendlines
    for (var line in trendlines) {
      if (line.length >= 2) {
        canvas.drawLine(line[0], line[1], paintTrend);
      }
    }

    // Horizontal lines
    for (var y in horizontalLines) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paintHLine,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter old) {
    return old.trendlines != trendlines ||
        old.horizontalLines != horizontalLines;
  }
}
EOF
cat > lib/features/market/presentation/widgets/custom_chart/custom_chart_widget.dart << 'EOF'
import 'package:flutter/material.dart';
import '../bloc/chart/chart_bloc.dart';
import '../bloc/chart/chart_state.dart';
import 'candles_painter.dart';
import 'indicator_painter.dart';
import 'drawing_painter.dart';

class CustomChartWidget extends StatelessWidget {
  final ChartState state;
  final List<List<Offset>> trendlines;
  final List<double> horizontalLines;

  CustomChartWidget({
    required this.state,
    required this.trendlines,
    required this.horizontalLines,
  });

  @override
  Widget build(BuildContext context) {
    if (state is ChartLoaded) {
      final candles = (state as ChartLoaded).candles;

      // بناء نقاط خطوط المؤشرات
      final ema50 = List<Offset>.generate(
        candles.length,
        (i) => Offset(i.toDouble(), (state as ChartLoaded).indicators[0].values[i]),
      );
      final ema200 = List<Offset>.generate(
        candles.length,
        (i) => Offset(i.toDouble(), (state as ChartLoaded).indicators[1].values[i]),
      );

      return LayoutBuilder(builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: CandlesPainter(candles: candles),
          foregroundPainter: DrawingPainter(
            trendlines: trendlines,
            horizontalLines: horizontalLines,
          ),
          child: Stack(
            children: [
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: IndicatorPainter(linePoints: ema50, color: Colors.blue),
              ),
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: IndicatorPainter(linePoints: ema200, color: Colors.orange),
              ),
            ],
          ),
        );
      });
    }
    return Container();
  }
}
EOF
cat >> lib/features/market/data/repositories/market_repository_impl.dart << 'EOF'

  @override
  Future<List<CandleModel>> getHistoricalCandlesPage({
    required String symbol,
    required String timeframe,
    required int count,
    DateTime? to,
  }) async {
    final params = {
      "instrument": symbol,
      "granularity": timeframe,
      "count": count.toString(),
      if (to != null) "to": to.toUtc().toIso8601String(),
    };

    final response = await _restClient!.getCandles(params);

    return response;
  }
EOF
cat > tmp_pagination.patch << 'EOF'
--- a/lib/features/market/presentation/bloc/chart/chart_bloc.dart
+++ b/lib/features/market/presentation/bloc/chart/chart_bloc.dart
@@
   Future<void> _onLoadMore(
     LoadMoreCandles event,
     Emitter<ChartState> emit,
   ) async {
     if (_isLoadingMore || _candles.isEmpty) return;
     _isLoadingMore = true;
 
     try {
-      final oldest = _candles.first.time;
-
-      final more = await repository.getHistoricalCandles(
-        symbol: symbol,
-        timeframe: timeframe,
-        count: _loadCount,
-        to: oldest.subtract(Duration(seconds: 1)),
-      );
+      final oldest = _candles.first.time;
+      final more = await repository.getHistoricalCandlesPage(
+        symbol: symbol,
+        timeframe: timeframe,
+        count: _loadCount,
+        to: oldest.subtract(Duration(seconds: 1)),
+      );
 
       if (more.isNotEmpty) {
         _candles = [...more, ..._candles];
         emit(ChartLoaded(candles: _candles));
       } else {
         emit(ChartLoaded(candles: _candles, canLoadMore: false));
       }
@@
     _isLoadingMore = false;
   }
EOF
cat > lib/features/market/domain/trading/orders/order_request.dart << 'EOF'
class OrderRequest {
  final String instrument;
  final int units; // >0 for buy, <0 for sell
  final String type; // MARKET / LIMIT / STOP
  final String timeInForce; // GTC / FOK / IOC
  final double? price; // Only for LIMIT/STOP

  OrderRequest({
    required this.instrument,
    required this.units,
    required this.type,
    this.timeInForce = "FOK",
    this.price,
  });

  Map<String, dynamic> toJson() {
    final order = {
      "instrument": instrument,
      "units": units.toString(),
      "type": type,
      "timeInForce": timeInForce,
      "positionFill": "DEFAULT",
    };
    if (price != null) order["price"] = price.toString();
    return {"order": order};
  }
}
EOF
cat >> lib/features/market/data/repositories/market_repository_impl.dart << 'EOF'

  @override
  Future<Map<String, dynamic>> executeOrder(OrderRequest request) async {
    final body = request.toJson();
    final res = await _restClient!.placeOrder(body);
    return res;
  }
EOF
cat > lib/features/market/presentation/bloc/trading_real/trading_real_event.dart << 'EOF'
import '../../../domain/trading/orders/order_request.dart';

abstract class TradingRealEvent {}

class SubmitRealOrder extends TradingRealEvent {
  final OrderRequest order;
  SubmitRealOrder(this.order);
}
EOF
cat > lib/features/market/presentation/bloc/trading_real/trading_real_state.dart << 'EOF'
abstract class TradingRealState {}

class RealTradingIdle extends TradingRealState {}

class RealTradingInProgress extends TradingRealState {}

class RealTradingSuccess extends TradingRealState {
  final Map<String, dynamic> result;
  RealTradingSuccess(this.result);
}

class RealTradingError extends TradingRealState {
  final String message;
  RealTradingError(this.message);
}
EOF
cat > lib/features/market/presentation/bloc/trading_real/trading_real_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/market_repository.dart';
import '../../../domain/trading/orders/order_request.dart';
import 'trading_real_event.dart';
import 'trading_real_state.dart';

class TradingRealBloc extends Bloc<TradingRealEvent, TradingRealState> {
  final MarketRepository repository;

  TradingRealBloc(this.repository) : super(RealTradingIdle()) {
    on<SubmitRealOrder>(_onSubmitOrder);
  }

  Future<void> _onSubmitOrder(
    SubmitRealOrder event,
    Emitter<TradingRealState> emit,
  ) async {
    emit(RealTradingInProgress());
    try {
      final res = await repository.executeOrder(event.order);
      emit(RealTradingSuccess(res));
    } catch (e) {
      emit(RealTradingError("Failed to execute real order: \$e"));
    }
  }
}
EOF
cat > lib/features/market/presentation/widgets/real_trade_dialog.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/trading_real/trading_real_bloc.dart';
import '../../bloc/trading_real/trading_real_event.dart';
import '../../../domain/trading/orders/order_request.dart';

class RealTradeDialog extends StatefulWidget {
  final String symbol;
  RealTradeDialog({required this.symbol});

  @override
  _RealTradeDialogState createState() => _RealTradeDialogState();
}

class _RealTradeDialogState extends State<RealTradeDialog> {
  final TextEditingController _unitsCtrl = TextEditingController();
  String _type = "MARKET";
  final priceCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Place Real Order"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _unitsCtrl,
            decoration: InputDecoration(labelText: "Units (+ buy, - sell)"),
            keyboardType: TextInputType.number,
          ),
          DropdownButton<String>(
            value: _type,
            items: ["MARKET", "LIMIT", "STOP"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _type = v!),
          ),
          if (_type != "MARKET")
            TextField(
              controller: priceCtrl,
              decoration: InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final units = int.tryParse(_unitsCtrl.text) ?? 0;
            final price = _type == "MARKET"
                ? null
                : double.tryParse(priceCtrl.text);
            final request = OrderRequest(
              instrument: widget.symbol,
              units: units,
              type: _type,
              price: price,
            );
            context.read<TradingRealBloc>().add(SubmitRealOrder(request));
            Navigator.pop(context);
          },
          child: Text("Submit"),
        ),
      ],
    );
  }
}
EOF
cat > lib/core/network/oanda_rest_config.dart << 'EOF'
class OandaConfig {
  static const bool useLive = false; // false = practice, true = live
  static String get baseUrl => useLive
      ? "https://api-fxtrade.oanda.com/v3"
      : "https://api-fxpractice.oanda.com/v3";
}
EOF
cat >> lib/core/network/oanda_rest_client.dart << 'EOF'

  Future<Map<String, dynamic>> fetchOpenPositions() async {
    final endpoint = "/accounts/\$accountId/openPositions";
    final response = await _dio.get(endpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> closePosition(String instrument) async {
    final endpoint = "/accounts/\$accountId/positions/\$instrument/close";
    final response = await _dio.put(endpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> modifyPosition(String instrument, Map<String, dynamic> body) async {
    final endpoint = "/accounts/\$accountId/positions/\$instrument";
    final response = await _dio.put(endpoint, data: body);
    return response.data;
  }
EOF
cat >> lib/features/market/data/repositories/market_repository_impl.dart << 'EOF'

  @override
  Future<Map<String, dynamic>> getOpenPositions() async {
    return await _restClient!.fetchOpenPositions();
  }

  @override
  Future<Map<String, dynamic>> closePosition(String instrument) async {
    return await _restClient!.closePosition(instrument);
  }

  @override
  Future<Map<String, dynamic>> modifyPosition(String instrument, Map<String, dynamic> body) async {
    return await _restClient!.modifyPosition(instrument, body);
  }
EOF
cat > lib/features/market/data/models/position/position_model.dart << 'EOF'
class PositionModel {
  final String instrument;
  final double units;
  final double unrealizedPL;
  final double averagePrice;
  final double? stopLoss;
  final double? takeProfit;

  PositionModel({
    required this.instrument,
    required this.units,
    required this.unrealizedPL,
    required this.averagePrice,
    this.stopLoss,
    this.takeProfit,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      instrument: json["instrument"],
      units: double.parse(json["units"].toString()),
      unrealizedPL: double.parse(json["unrealizedPL"].toString()),
      averagePrice: double.parse(json["averagePrice"].toString()),
      stopLoss: json["stopLoss"] != null ? double.parse(json["stopLoss"].toString()) : null,
      takeProfit: json["takeProfit"] != null ? double.parse(json["takeProfit"].toString()) : null,
    );
  }
}
EOF
cat > lib/features/market/presentation/bloc/positions/positions_event.dart << 'EOF'
abstract class PositionsEvent {}

class LoadPositions extends PositionsEvent {}

class ClosePositionEvent extends PositionsEvent {
  final String instrument;
  ClosePositionEvent(this.instrument);
}

class ModifyPositionEvent extends PositionsEvent {
  final String instrument;
  final double stopLoss;
  final double takeProfit;
  ModifyPositionEvent({
    required this.instrument,
    required this.stopLoss,
    required this.takeProfit,
  });
}
EOF
cat > lib/features/market/presentation/bloc/positions/positions_state.dart << 'EOF'
abstract class PositionsState {}

class PositionsIdle extends PositionsState {}

class PositionsLoading extends PositionsState {}

class PositionsLoaded extends PositionsState {
  final List positionList;
  PositionsLoaded(this.positionList);
}

class PositionsError extends PositionsState {
  final String message;
  PositionsError(this.message);
}
EOF
cat > lib/features/market/presentation/bloc/positions/positions_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/market_repository.dart';
import '../../../data/models/position/position_model.dart';
import 'positions_event.dart';
import 'positions_state.dart';

class PositionsBloc extends Bloc<PositionsEvent, PositionsState> {
  final MarketRepository repository;

  PositionsBloc(this.repository) : super(PositionsIdle()) {
    on<LoadPositions>(_onLoad);
    on<ClosePositionEvent>(_onClose);
    on<ModifyPositionEvent>(_onModify);
  }

  Future<void> _onLoad(LoadPositions event, Emitter<PositionsState> emit) async {
    emit(PositionsLoading());
    try {
      final res = await repository.getOpenPositions();
      final positionsJson = res["positions"] as List<dynamic>;
      final list = positionsJson
          .map((e) => PositionModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      emit(PositionsLoaded(list));
    } catch (e) {
      emit(PositionsError("Failed to load positions"));
    }
  }

  Future<void> _onClose(ClosePositionEvent event, Emitter<PositionsState> emit) async {
    emit(PositionsLoading());
    try {
      await repository.closePosition(event.instrument);
      add(LoadPositions());
    } catch (e) {
      emit(PositionsError("Failed to close position"));
    }
  }

  Future<void> _onModify(ModifyPositionEvent event, Emitter<PositionsState> emit) async {
    emit(PositionsLoading());
    try {
      final body = {
        "stopLoss": {"price": event.stopLoss.toString()},
        "takeProfit": {"price": event.takeProfit.toString()},
      };
      await repository.modifyPosition(event.instrument, body);
      add(LoadPositions());
    } catch (e) {
      emit(PositionsError("Failed to modify position"));
    }
  }
}
EOF
cat > lib/features/market/presentation/pages/positions/positions_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/positions/positions_bloc.dart';
import '../../bloc/positions/positions_event.dart';
import '../../bloc/positions/positions_state.dart';
import '../../../data/models/position/position_model.dart';

class PositionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Open Positions")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.read<PositionsBloc>().add(LoadPositions()),
            child: Text("Refresh"),
          ),
          Expanded(
            child: BlocBuilder<PositionsBloc, PositionsState>(
              builder: (context, state) {
                if (state is PositionsLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is PositionsLoaded) {
                  final positions = state.positionList;
                  if (positions.isEmpty) {
                    return Center(child: Text("No open positions"));
                  }
                  return ListView.builder(
                    itemCount: positions.length,
                    itemBuilder: (ctx, i) {
                      final PositionModel p = positions[i];
                      return ListTile(
                        title: Text("${p.instrument} - Units: ${p.units.toString()}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Avg Price: ${p.averagePrice.toStringAsFixed(4)}"),
                            Text("Unrealized P/L: ${p.unrealizedPL.toStringAsFixed(2)}"),
                            Text("SL: ${p.stopLoss?.toStringAsFixed(4) ?? '-'}"),
                            Text("TP: ${p.takeProfit?.toStringAsFixed(4) ?? '-'}"),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _showModifyDialog(context, p),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => context.read<PositionsBloc>().add(ClosePositionEvent(p.instrument)),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                if (state is PositionsError) {
                  return Center(child: Text("Error: ${state.message}"));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showModifyDialog(BuildContext context, PositionModel p) {
    final stopCtrl = TextEditingController(text: p.stopLoss?.toStringAsFixed(4) ?? '');
    final tpCtrl = TextEditingController(text: p.takeProfit?.toStringAsFixed(4) ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Modify Position"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: stopCtrl,
              decoration: InputDecoration(labelText: "Stop Loss"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: tpCtrl,
              decoration: InputDecoration(labelText: "Take Profit"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final sl = double.tryParse(stopCtrl.text) ?? 0.0;
              final tp = double.tryParse(tpCtrl.text) ?? 0.0;
              context.read<PositionsBloc>().add(ModifyPositionEvent(
                instrument: p.instrument,
                stopLoss: sl,
                takeProfit: tp,
              ));
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
EOF
cat >> lib/core/network/retry_interceptor.dart << 'EOF'
import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:dio_retry/strategies/exponential_retry_strategy.dart';

class RestRetryInterceptor {
  static void apply(Dio dio) {
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: print,
        retryDelays: ExponentialRetryStrategy().delays,
      ),
    );
  }
}
EOF
cat > lib/features/market/domain/audit/audit_log.dart << 'EOF'
enum AuditType {
  tradeExecuted,
  tradeClosed,
  apiError,
  strategyChanged,
  settingsChanged,
  websocketConnected,
  websocketDisconnected,
  general,
}

class AuditLog {
  final DateTime timestamp;
  final AuditType type;
  final String message;
  final Map<String, dynamic>? data;

  AuditLog({
    required this.timestamp,
    required this.type,
    required this.message,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      "timestamp": timestamp.toIso8601String(),
      "type": type.toString(),
      "message": message,
      "data": data,
    };
  }

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      timestamp: DateTime.parse(json["timestamp"]),
      type: AuditType.values.firstWhere(
        (e) => e.toString() == json["type"],
        orElse: () => AuditType.general,
      ),
      message: json["message"],
      data: json["data"] != null
          ? Map<String, dynamic>.from(json["data"])
          : null,
    );
  }
}
EOF
cat > lib/features/market/data/adapters/audit_log_adapter.dart << 'EOF'
import 'package:hive/hive.dart';
import '../../../domain/audit/audit_log.dart';

class AuditLogAdapter extends TypeAdapter<AuditLog> {
  @override
  final typeId = 1;

  @override
  AuditLog read(BinaryReader reader) {
    final json = reader.readString();
    return AuditLog.fromJson(Map<String, dynamic>.from(jsonDecode(json)));
  }

  @override
  void write(BinaryWriter writer, AuditLog obj) {
    writer.writeString(jsonEncode(obj.toJson()));
  }
}
EOF
cat > lib/features/market/data/repositories/audit/audit_repository.dart << 'EOF'
import 'package:hive/hive.dart';
import '../../../domain/audit/audit_log.dart';

class AuditRepository {
  static const String _boxName = "audit_logs";

  Future<void> init() async {
    await Hive.openBox<AuditLog>(_boxName);
  }

  Future<void> addLog(AuditLog log) async {
    final box = Hive.box<AuditLog>(_boxName);
    await box.add(log);
  }

  List<AuditLog> getAllLogs() {
    final box = Hive.box<AuditLog>(_boxName);
    return box.values.toList();
  }

  Future<void> clearLogs() async {
    final box = Hive.box<AuditLog>(_boxName);
    await box.clear();
  }
}
EOF
cat > lib/features/market/presentation/bloc/audit/audit_event.dart << 'EOF'
abstract class AuditEvent {}

class LoadAuditLogs extends AuditEvent {}

class ClearAuditLogs extends AuditEvent {}
EOF
cat > lib/features/market/presentation/bloc/audit/audit_state.dart << 'EOF'
abstract class AuditState {}

class AuditIdle extends AuditState {}

class AuditLoading extends AuditState {}

class AuditLoaded extends AuditState {
  final List logs;
  AuditLoaded(this.logs);
}

class AuditError extends AuditState {
  final String message;
  AuditError(this.message);
}
EOF
cat > lib/features/market/presentation/bloc/audit/audit_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/audit/audit_repository.dart';
import 'audit_event.dart';
import 'audit_state.dart';

class AuditBloc extends Bloc<AuditEvent, AuditState> {
  final AuditRepository auditRepository;

  AuditBloc(this.auditRepository) : super(AuditIdle()) {
    on<LoadAuditLogs>(_onLoad);
    on<ClearAuditLogs>(_onClear);
  }

  Future<void> _onLoad(LoadAuditLogs event, Emitter<AuditState> emit) async {
    emit(AuditLoading());
    try {
      final logs = auditRepository.getAllLogs();
      emit(AuditLoaded(logs));
    } catch (e) {
      emit(AuditError("Failed to load logs"));
    }
  }

  Future<void> _onClear(ClearAuditLogs event, Emitter<AuditState> emit) async {
    await auditRepository.clearLogs();
    emit(AuditLoaded([]));
  }
}
EOF
cat > lib/features/market/presentation/pages/audit/audit_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/audit/audit_bloc.dart';
import '../../bloc/audit/audit_event.dart';
import '../../bloc/audit/audit_state.dart';

class AuditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Audit Trail")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.read<AuditBloc>().add(LoadAuditLogs()),
            child: Text("Refresh Logs"),
          ),
          Expanded(
            child: BlocBuilder<AuditBloc, AuditState>(
              builder: (context, state) {
                if (state is AuditLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is AuditLoaded) {
                  if (state.logs.isEmpty) return Center(child: Text("No logs"));
                  return ListView.builder(
                    itemCount: state.logs.length,
                    itemBuilder: (ctx, i) {
                      final log = state.logs[i];
                      return ListTile(
                        title: Text(log.message),
                        subtitle: Text(log.timestamp.toString()),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
EOF
cat > lib/features/market/domain/indicators/advanced/rsi_calculator.dart << 'EOF'
import '../entities/candle.dart';

class RsiResult {
  final List<double> values;
  RsiResult(this.values);
}

class RsiCalculator {
  static RsiResult calculate(List<CandleEntity> data, {int period = 14}) {
    final List<double> deltas = [];
    for (int i = 1; i < data.length; i++) {
      deltas.add(data[i].close - data[i - 1].close);
    }

    List<double> gains = [];
    List<double> losses = [];

    for (var d in deltas) {
      gains.add(d > 0 ? d : 0);
      losses.add(d < 0 ? -d : 0);
    }

    List<double> avgGain = [];
    List<double> avgLoss = [];

    double sumGain = gains.take(period).reduce((a, b) => a + b);
    double sumLoss = losses.take(period).reduce((a, b) => a + b);

    avgGain.add(sumGain / period);
    avgLoss.add(sumLoss / period);

    for (int i = period; i < gains.length; i++) {
      double gain = gains[i];
      double loss = losses[i];

      avgGain.add((avgGain.last * (period - 1) + gain) / period);
      avgLoss.add((avgLoss.last * (period - 1) + loss) / period);
    }

    List<double> rsi = List.filled(data.length, 0.0);
    for (int i = period; i < avgGain.length + period; i++) {
      double rs = avgGain[i - period] / (avgLoss[i - period] == 0 ? 1 : avgLoss[i - period]);
      rsi[i] = 100 - (100 / (1 + rs));
    }

    return RsiResult(rsi);
  }
}
EOF
cat > lib/features/market/domain/indicators/advanced/macd_calculator.dart << 'EOF'
import '../entities/candle.dart';
import 'package:collection/collection.dart';

class MacdResult {
  final List<double> macdLine;
  final List<double> signalLine;
  final List<double> histogram;

  MacdResult({
    required this.macdLine,
    required this.signalLine,
    required this.histogram,
  });
}

class MacdCalculator {
  static MacdResult calculate(
    List<CandleEntity> data, {
    int fastPeriod = 12,
    int slowPeriod = 26,
    int signalPeriod = 9,
  }) {
    List<double> closePrices = data.map((c) => c.close).toList();

    List<double> emaFast = _ema(closePrices, fastPeriod);
    List<double> emaSlow = _ema(closePrices, slowPeriod);

    List<double> macdLine = List.generate(closePrices.length, (i) {
      return emaFast[i] - emaSlow[i];
    });

    List<double> signalLine = _ema(macdLine, signalPeriod);

    List<double> histogram = List.generate(closePrices.length, (i) {
      return macdLine[i] - signalLine[i];
    });

    return MacdResult(
      macdLine: macdLine,
      signalLine: signalLine,
      histogram: histogram,
    );
  }

  static List<double> _ema(List<double> data, int period) {
    List<double> kList = [];
    double multiplier = 2 / (period + 1);

    List<double> ema = [];
    ema.add(data.take(period).reduce((a, b) => a + b) / period);

    for (int i = period; i < data.length; i++) {
      ema.add((data[i] - ema.last) * multiplier + ema.last);
    }

    return ema;
  }
}
EOF
cat > lib/features/market/domain/indicators/advanced/bollinger_calculator.dart << 'EOF'
import '../entities/candle.dart';
import 'dart:math';

class BollingerResult {
  final List<double> middleBand;
  final List<double> upperBand;
  final List<double> lowerBand;

  BollingerResult({
    required this.middleBand,
    required this.upperBand,
    required this.lowerBand,
  });
}

class BollingerCalculator {
  static BollingerResult calculate(
    List<CandleEntity> data, {
    int period = 20,
    double stdDevMultiplier = 2.0,
  }) {
    List<double> closes = data.map((c) => c.close).toList();

    List<double> middle = [];
    List<double> upper = [];
    List<double> lower = [];

    for (int i = 0; i < closes.length; i++) {
      if (i + 1 >= period) {
        List<double> window = closes.sublist(i + 1 - period, i + 1);
        double mean = window.reduce((a, b) => a + b) / period;
        double sumSq = window.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b);
        double stdDev = sqrt(sumSq / period);

        middle.add(mean);
        upper.add(mean + stdDevMultiplier * stdDev);
        lower.add(mean - stdDevMultiplier * stdDev);
      } else {
        middle.add(0);
        upper.add(0);
        lower.add(0);
      }
    }
    return BollingerResult(
      middleBand: middle,
      upperBand: upper,
      lowerBand: lower,
    );
  }
}
EOF
cat > lib/features/market/domain/alerts/smart/smart_alert.dart << 'EOF'
enum SmartAlertType {
  rsiBelow,
  macdCrossUp,
  bollingerBreakoutUpper,
}

class SmartAlertCondition {
  final SmartAlertType type;
  final int durationSeconds;
  final double threshold;

  SmartAlertCondition({
    required this.type,
    required this.durationSeconds,
    required this.threshold,
  });
}

class SmartAlert {
  final SmartAlertCondition condition;
  final String instrument;
  bool isTriggered = false;

  SmartAlert({required this.condition, required this.instrument});
}
EOF
cat > lib/features/market/domain/alerts/smart/engine/smart_alert_engine.dart << 'EOF'
import 'dart:collection';
import '../../entities/candle.dart';
import '../smart/smart_alert.dart';
import '../../../indicators/advanced/rsi_calculator.dart';
import '../../../indicators/advanced/macd_calculator.dart';
import '../../../indicators/advanced/bollinger_calculator.dart';

class SmartAlertEngine {
  final List<CandleEntity> history;
  final List<SmartAlert> activeAlerts;
  final int checkIntervalSeconds;

  SmartAlertEngine({
    required this.history,
    required this.activeAlerts,
    this.checkIntervalSeconds = 60,
  });

  void processNewCandle(CandleEntity candle) {
    history.add(candle);

    for (var alert in activeAlerts) {
      if (alert.isTriggered) continue;

      switch (alert.condition.type) {
        case SmartAlertType.rsiBelow:
          _checkRsiBelow(alert);
          break;
        case SmartAlertType.macdCrossUp:
          _checkMacdCross(alert);
          break;
        case SmartAlertType.bollingerBreakoutUpper:
          _checkBollingerUpper(alert);
          break;
      }
    }
  }

  void _checkRsiBelow(SmartAlert alert) {
    final rsi = RsiCalculator.calculate(history, period: alert.condition.threshold.toInt()).values;
    int countBelow = 0;
    for (int i = rsi.length - alert.condition.durationSeconds; i < rsi.length; i++) {
      if (rsi[i] < alert.condition.threshold) countBelow++;
    }
    if (countBelow >= alert.condition.durationSeconds) {
      alert.isTriggered = true;
    }
  }

  void _checkMacdCross(SmartAlert alert) {
    final macd = MacdCalculator.calculate(history).macdLine;
    final signal = MacdCalculator.calculate(history).signalLine;
    if (macd.isNotEmpty && signal.isNotEmpty) {
      int n = macd.length;
      if (n > 1 && macd[n - 2] < signal[n - 2] && macd[n - 1] > signal[n - 1]) {
        alert.isTriggered = true;
      }
    }
  }

  void _checkBollingerUpper(SmartAlert alert) {
    final bb = BollingerCalculator.calculate(history);
    double lastPrice = history.last.close;
    if (lastPrice > bb.upperBand.last) alert.isTriggered = true;
  }
}
EOF
cat > lib/features/market/presentation/bloc/smart_alert/smart_alert_event.dart << 'EOF'
import '../../../domain/alerts/smart/smart_alert.dart';

abstract class SmartAlertEvent {}

class AddSmartAlert extends SmartAlertEvent {
  final SmartAlert alert;
  AddSmartAlert(this.alert);
}

class RemoveSmartAlert extends SmartAlertEvent {
  final int index;
  RemoveSmartAlert(this.index);
}

class CheckSmartAlerts extends SmartAlertEvent {
  final dynamic newCandle;
  CheckSmartAlerts(this.newCandle);
}
EOF
cat > lib/features/market/presentation/bloc/smart_alert/smart_alert_state.dart << 'EOF'
abstract class SmartAlertState {}

class SmartAlertIdle extends SmartAlertState {}

class SmartAlertUpdated extends SmartAlertState {
  final List alerts;
  SmartAlertUpdated(this.alerts);
}
EOF
cat > lib/features/market/presentation/bloc/smart_alert/smart_alert_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/alerts/smart/smart_alert.dart';
import '../../../domain/alerts/smart/engine/smart_alert_engine.dart';
import 'smart_alert_event.dart';
import 'smart_alert_state.dart';

class SmartAlertBloc extends Bloc<SmartAlertEvent, SmartAlertState> {
  final List<CandleEntity> _history = [];
  final List<SmartAlert> _alerts = [];

  SmartAlertBloc() : super(SmartAlertIdle()) {
    on<AddSmartAlert>((event, emit) {
      _alerts.add(event.alert);
      emit(SmartAlertUpdated(List.from(_alerts)));
    });

    on<RemoveSmartAlert>((event, emit) {
      _alerts.removeAt(event.index);
      emit(SmartAlertUpdated(List.from(_alerts)));
    });

    on<CheckSmartAlerts>((event, emit) {
      final engine = SmartAlertEngine(history: _history, activeAlerts: _alerts);
      engine.processNewCandle(event.newCandle);
      emit(SmartAlertUpdated(List.from(_alerts)));
    });
  }
}
EOF
cat > lib/features/market/presentation/widgets/smart_alert_dialog.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../domain/alerts/smart/smart_alert.dart';

class SmartAlertDialog extends StatefulWidget {
  final String symbol;
  SmartAlertDialog({required this.symbol});

  @override
  _SmartAlertDialogState createState() => _SmartAlertDialogState();
}

class _SmartAlertDialogState extends State<SmartAlertDialog> {
  SmartAlertType _selectedType = SmartAlertType.rsiBelow;
  final TextEditingController _threshold = TextEditingController();
  final TextEditingController _duration = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Smart Alert"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<SmartAlertType>(
            value: _selectedType,
            items: SmartAlertType.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.toString())))
                .toList(),
            onChanged: (v) => setState(() => _selectedType = v!),
          ),
          TextField(
            controller: _threshold,
            decoration: InputDecoration(labelText: "Threshold"),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          TextField(
            controller: _duration,
            decoration: InputDecoration(labelText: "Duration (seconds)"),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final th = double.tryParse(_threshold.text) ?? 0;
            final dur = int.tryParse(_duration.text) ?? 0;
            final condition = SmartAlertCondition(
              type: _selectedType,
              durationSeconds: dur,
              threshold: th,
            );
            final alert = SmartAlert(instrument: widget.symbol, condition: condition);
            Navigator.pop(context, alert);
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
EOF
cat > lib/features/market/domain/analytics/analytics_calculator.dart << 'EOF'
class AnalyticsResult {
  final double netProfit;
  final double winRate;
  final double sharpRatio;
  final double expectancy;
  final int totalTrades;
  final int wins;
  final int losses;

  AnalyticsResult({
    required this.netProfit,
    required this.winRate,
    required this.sharpRatio,
    required this.expectancy,
    required this.totalTrades,
    required this.wins,
    required this.losses,
  });
}

class AnalyticsCalculator {
  static AnalyticsResult calculate(List<double> profits) {
    final n = profits.length;
    if (n == 0) {
      return AnalyticsResult(
        netProfit: 0,
        winRate: 0,
        sharpRatio: 0,
        expectancy: 0,
        totalTrades: 0,
        wins: 0,
        losses: 0,
      );
    }

    double netProfit = profits.reduce((a, b) => a + b);

    int wins = profits.where((p) => p > 0).length;
    int losses = profits.where((p) => p <= 0).length;

    double winRate = wins / n * 100;

    double avgProfit = netProfit / n;

    double variance = profits
        .map((p) => (p - avgProfit) * (p - avgProfit))
        .reduce((a, b) => a + b) / n;
    double stdDev = variance.sqrt();

    double sharpRatio = stdDev == 0 ? 0 : avgProfit / stdDev;

    double expectancy = ((wins / n) * (profits.where((p) => p > 0).reduce((a, b) => a + b) / wins)) -
        ((losses / n) * (profits.where((p) => p <= 0).reduce((a, b) => a + b) / (losses == 0 ? 1 : losses)));

    return AnalyticsResult(
      netProfit: netProfit,
      winRate: winRate,
      sharpRatio: sharpRatio,
      expectancy: expectancy,
      totalTrades: n,
      wins: wins,
      losses: losses,
    );
  }
}
EOF
cat > lib/features/market/presentation/bloc/analytics/analytics_event.dart << 'EOF'
abstract class AnalyticsEvent {}

class ComputeAnalytics extends AnalyticsEvent {
  final List<double> profits;
  ComputeAnalytics(this.profits);
}
EOF
cat > lib/features/market/presentation/bloc/analytics/analytics_state.dart << 'EOF'
abstract class AnalyticsState {}

class AnalyticsIdle extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final dynamic result;
  AnalyticsLoaded(this.result);
}

class AnalyticsError extends AnalyticsState {
  final String message;
  AnalyticsError(this.message);
}
EOF
cat > lib/features/market/presentation/bloc/analytics/analytics_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/analytics/analytics_calculator.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc() : super(AnalyticsIdle()) {
    on<ComputeAnalytics>(_onCompute);
  }

  void _onCompute(ComputeAnalytics event, Emitter<AnalyticsState> emit) {
    emit(AnalyticsLoading());
    try {
      final result = AnalyticsCalculator.calculate(event.profits);
      emit(AnalyticsLoaded(result));
    } catch (e) {
      emit(AnalyticsError("Analytics compute failed"));
    }
  }
}
EOF
cat > lib/features/market/presentation/pages/analytics/analytics_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/analytics/analytics_bloc.dart';
import '../../bloc/analytics/analytics_event.dart';
import '../../bloc/analytics/analytics_state.dart';

class AnalyticsPage extends StatelessWidget {
  final List<double> profits;
  AnalyticsPage({required this.profits});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Advanced Analytics")),
      body: BlocProvider(
        create: (_) => AnalyticsBloc()..add(ComputeAnalytics(profits)),
        child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is AnalyticsLoaded) {
              final r = state.result;
              return ListView(
                padding: EdgeInsets.all(12),
                children: [
                  Text("Net Profit: ${r.netProfit.toStringAsFixed(2)}"),
                  Text("Win Rate: ${r.winRate.toStringAsFixed(2)}%"),
                  Text("Sharp Ratio: ${r.sharpRatio.toStringAsFixed(2)}"),
                  Text("Expectancy: ${r.expectancy.toStringAsFixed(2)}"),
                  Text("Total Trades: ${r.totalTrades}"),
                  Text("Wins: ${r.wins}"),
                  Text("Losses: ${r.losses}"),
                ],
              );
            }
            if (state is AnalyticsError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
EOF
cat > lib/features/settings/domain/theme/app_theme.dart << 'EOF'
import 'package:flutter/material.dart';

enum AppThemeMode { light, dark, system }

class AppTheme {
  final AppThemeMode mode;
  final Color bullCandle;
  final Color bearCandle;
  final Color emaColor;
  final Color rsiColor;
  final Color macdColor;
  final Color bollingerColor;

  const AppTheme({
    required this.mode,
    required this.bullCandle,
    required this.bearCandle,
    required this.emaColor,
    required this.rsiColor,
    required this.macdColor,
    required this.bollingerColor,
  });

  Map<String, dynamic> toJson() => {
        "mode": mode.name,
        "bullCandle": bullCandle.value,
        "bearCandle": bearCandle.value,
        "emaColor": emaColor.value,
        "rsiColor": rsiColor.value,
        "macdColor": macdColor.value,
        "bollingerColor": bollingerColor.value,
      };

  factory AppTheme.fromJson(Map<String, dynamic> json) {
    return AppTheme(
      mode: AppThemeMode.values.firstWhere(
        (e) => e.name == json["mode"],
        orElse: () => AppThemeMode.system,
      ),
      bullCandle: Color(json["bullCandle"]),
      bearCandle: Color(json["bearCandle"]),
      emaColor: Color(json["emaColor"]),
      rsiColor: Color(json["rsiColor"]),
      macdColor: Color(json["macdColor"]),
      bollingerColor: Color(json["bollingerColor"]),
    );
  }

  static AppTheme defaultLight() => AppTheme(
        mode: AppThemeMode.system,
        bullCandle: Colors.green,
        bearCandle: Colors.red,
        emaColor: Colors.blue,
        rsiColor: Colors.purple,
        macdColor: Colors.cyan,
        bollingerColor: Colors.teal,
      );
}
EOF
cat > lib/features/settings/data/theme/theme_repository.dart << 'EOF'
import 'package:hive/hive.dart';
import '../../domain/theme/app_theme.dart';

class ThemeRepository {
  static const String _boxName = "app_theme";

  Future<void> init() async {
    await Hive.openBox<Map>(_boxName);
  }

  Future<void> saveTheme(AppTheme theme) async {
    final box = Hive.box<Map>(_boxName);
    await box.put("current", theme.toJson());
  }

  AppTheme loadTheme() {
    final box = Hive.box<Map>(_boxName);
    final data = box.get("current");
    if (data == null) return AppTheme.defaultLight();
    return AppTheme.fromJson(Map<String, dynamic>.from(data));
  }
}
EOF
cat > lib/features/settings/presentation/bloc/theme/theme_event.dart << 'EOF'
import '../../../domain/theme/app_theme.dart';

abstract class ThemeEvent {}

class ChangeThemeMode extends ThemeEvent {
  final AppThemeMode mode;
  ChangeThemeMode(this.mode);
}

class UpdateThemeColors extends ThemeEvent {
  final AppTheme theme;
  UpdateThemeColors(this.theme);
}
EOF
cat > lib/features/settings/presentation/bloc/theme/theme_state.dart << 'EOF'
import '../../../domain/theme/app_theme.dart';

class ThemeState {
  final AppTheme theme;
  const ThemeState(this.theme);

  Map<String, dynamic> toJson() => theme.toJson();

  factory ThemeState.fromJson(Map<String, dynamic> json) {
    return ThemeState(AppTheme.fromJson(json));
  }
}
EOF
cat > lib/features/settings/presentation/bloc/theme/theme_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../data/theme/theme_repository.dart';
import '../../../domain/theme/app_theme.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  final ThemeRepository repo;

  ThemeBloc(this.repo)
      : super(ThemeState(repo.loadTheme())) {
    on<ChangeThemeMode>((event, emit) {
      final updated = AppTheme(
        mode: event.mode,
        bullCandle: state.theme.bullCandle,
        bearCandle: state.theme.bearCandle,
        emaColor: state.theme.emaColor,
        rsiColor: state.theme.rsiColor,
        macdColor: state.theme.macdColor,
        bollingerColor: state.theme.bollingerColor,
      );
      repo.saveTheme(updated);
      emit(ThemeState(updated));
    });

    on<UpdateThemeColors>((event, emit) {
      repo.saveTheme(event.theme);
      emit(ThemeState(event.theme));
    });
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) =>
      ThemeState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ThemeState state) => state.toJson();
}
EOF
cat > lib/features/settings/presentation/pages/theme/theme_settings_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/theme/theme_bloc.dart';
import '../../bloc/theme/theme_event.dart';
import '../../../domain/theme/app_theme.dart';

class ThemeSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeBloc>().state.theme;

    return Scaffold(
      appBar: AppBar(title: Text("Theme Settings")),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          Text("Theme Mode"),
          DropdownButton<AppThemeMode>(
            value: theme.mode,
            items: AppThemeMode.values
                .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
                .toList(),
            onChanged: (m) {
              context.read<ThemeBloc>().add(ChangeThemeMode(m!));
            },
          ),
          Divider(),
          Text("Candle Colors"),
          ListTile(
            title: Text("Bull Candle"),
            trailing: CircleAvatar(backgroundColor: theme.bullCandle),
            onTap: () {},
          ),
          ListTile(
            title: Text("Bear Candle"),
            trailing: CircleAvatar(backgroundColor: theme.bearCandle),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
EOF
cat > test/unit/analytics_calculator_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/analytics/analytics_calculator.dart';

void main() {
  group('AnalyticsCalculator', () {
    test('calculates correct metrics', () {
      final profits = [100.0, -50.0, 25.0];

      final result = AnalyticsCalculator.calculate(profits);

      expect(result.netProfit, 75.0);
      expect(result.totalTrades, 3);
      expect(result.wins, 2);
      expect(result.losses, 1);
      expect(result.winRate, closeTo(66.67, 0.1));
    });
  });
}
EOF
cat > test/unit/chart_bloc_test.dart << 'EOF'
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_event.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_state.dart';
import 'package:mocktail/mocktail.dart';

class MockChartRepository extends Mock implements ChartRepository {}

void main() {
  group('ChartBloc', () {
    late MockChartRepository mockRepo;
    late ChartBloc chartBloc;

    setUp(() {
      mockRepo = MockChartRepository();
      chartBloc = ChartBloc(mockRepo, symbol: 'TEST', timeframe: 'M1');
    });

    blocTest<ChartBloc, ChartState>(
      'emits [ChartLoading, ChartLoaded] when data is fetched',
      build: () {
        when(() => mockRepo.getHistoricalCandles(
              symbol: any(named: 'symbol'),
              timeframe: any(named: 'timeframe'),
              count: any(named: 'count'),
            )).thenAnswer((_) async => []);
        return chartBloc;
      },
      act: (bloc) => bloc.add(LoadChartHistory(symbol: 'TEST', timeframe: 'M1')),
      expect: () => [isA<ChartLoading>(), isA<ChartLoaded>()],
    );
  });
}
EOF
cat > test/integration/backtest_analytics_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/analytics/analytics_calculator.dart';
import 'package:your_app/features/market/domain/backtest/backtest_engine.dart';

void main() {
  test('Backtest integration yields expected analytics', () {
    final history = [
      // صيغة بيانات تجريبية
      CandleEntity(open: 100, high: 105, low: 95, close: 102, volume: 1000),
      CandleEntity(open: 102, high: 108, low: 99, close: 105, volume: 1200),
      CandleEntity(open: 105, high: 110, low: 102, close: 108, volume: 1100),
    ];

    final backtestEngine = BacktestEngine(history);
    final results = backtestEngine.run();

    final analytics = AnalyticsCalculator.calculate(results.tradeProfits);

    expect(analytics.totalTrades, greaterThan(0));
    expect(analytics.winRate, isA<double>());
  });
}
EOF
cat > test/widget/chart_page_test.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/presentation/pages/interactive_chart_page.dart';

void main() {
  testWidgets('Chart Page loads and displays chart', (tester) async {
    await tester.pumpWidget(MaterialApp(home: InteractiveChartPage(symbol: 'XAU_USD')));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Chart — XAU_USD'), findsOneWidget);
  });
}
EOF
cat > android/app/src/dev/res/values/strings.xml << 'EOF'
<resources>
    <string name="app_name">TradingApp Dev</string>
</resources>
EOF
cat > android/app/src/staging/res/values/strings.xml << 'EOF'
<resources>
    <string name="app_name">TradingApp Staging</string>
</resources>
EOF
cat >> android/app/proguard-rules.pro << 'EOF'
# Flutter/Dart
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# OANDA Models
-keep class com.yourapp.** { *; }
EOF
cat > android/key.properties << 'EOF'
storePassword=YOUR_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=tradingappkey
storeFile=/full/path/to/keystore.jks
EOF
cat > .env.dev << 'EOF'
OANDA_API_URL=https://api-fxpractice.oanda.com/v3
FIREBASE_ENV=dev
EOF
cat > lib/core/widgets/loading/shimmer_loader.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  final double height;
  final double width;
  const ShimmerLoader({this.height = 80, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        color: Colors.white,
      ),
    );
  }
}
EOF
cat > lib/core/widgets/error_display.dart << 'EOF'
import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorDisplay({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
          SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: 12),
          if (onRetry != null)
            ElevatedButton.icon(
              icon: Icon(Icons.refresh),
              label: Text("Retry"),
              onPressed: onRetry,
            ),
        ],
      ),
    );
  }
}
EOF
cat > lib/features/market/domain/strategy/multi/strategy_set.dart << 'EOF'
import '../../strategy/strategy_config.dart';

class StrategyInstance {
  final String id;
  final StrategyConfig config;

  StrategyInstance({required this.id, required this.config});
}

class StrategySet {
  final List<StrategyInstance> strategies;

  StrategySet({required this.strategies});
}
EOF
cat > lib/features/market/domain/strategy/multi/multi_strategy_runner.dart << 'EOF'
import '../strategy_config.dart';
import '../../backtest/backtest_engine.dart';
import 'strategy_set.dart';

class MultiStrategyResult {
  final Map<String, dynamic> results;
  MultiStrategyResult({required this.results});
}

class MultiStrategyRunner {
  final StrategySet strategySet;

  MultiStrategyRunner(this.strategySet);

  Future<MultiStrategyResult> runBacktestAll(List<dynamic> history) async {
    final Map<String, dynamic> out = {};

    for (var inst in strategySet.strategies) {
      final engine = BacktestEngine(history, config: inst.config);
      final res = engine.run();
      out[inst.id] = res;
    }

    return MultiStrategyResult(results: out);
  }
}
EOF
cat > lib/features/market/presentation/bloc/strategy_comparison/strategy_comparison_event.dart << 'EOF'
import '../../../domain/strategy/multi/strategy_set.dart';

abstract class ComparisonEvent {}

class RunComparison extends ComparisonEvent {
  final StrategySet set;
  final List history;
  RunComparison({required this.set, required this.history});
}
EOF
cat > lib/features/market/presentation/bloc/strategy_comparison/strategy_comparison_state.dart << 'EOF'
abstract class ComparisonState {}

class ComparisonIdle extends ComparisonState {}

class ComparisonRunning extends ComparisonState {}

class ComparisonSuccess extends ComparisonState {
  final Map<String, dynamic> results;
  ComparisonSuccess(this.results);
}

class ComparisonError extends ComparisonState {
  final String message;
  ComparisonError(this.message);
}
EOF
cat > lib/features/market/presentation/bloc/strategy_comparison/strategy_comparison_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/strategy/multi/multi_strategy_runner.dart';
import 'strategy_comparison_event.dart';
import 'strategy_comparison_state.dart';

class StrategyComparisonBloc extends Bloc<ComparisonEvent, ComparisonState> {
  StrategyComparisonBloc() : super(ComparisonIdle()) {
    on<RunComparison>(_onRun);
  }

  void _onRun(RunComparison event, Emitter<ComparisonState> emit) async {
    emit(ComparisonRunning());
    try {
      final runner = MultiStrategyRunner(event.set);
      final results = await runner.runBacktestAll(event.history);
      emit(ComparisonSuccess(results.results));
    } catch (e) {
      emit(ComparisonError("Comparison failed: \$e"));
    }
  }
}
EOF
cat > lib/features/market/presentation/pages/strategy_comparison/strategy_comparison_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/strategy_comparison/strategy_comparison_bloc.dart';
import '../../bloc/strategy_comparison/strategy_comparison_event.dart';
import '../../bloc/strategy_comparison/strategy_comparison_state.dart';

class StrategyComparisonPage extends StatelessWidget {
  final List history;
  final List configs;

  StrategyComparisonPage({
    required this.history,
    required this.configs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Strategy Comparison")),
      body: BlocProvider(
        create: (_) => StrategyComparisonBloc(),
        child: BlocBuilder<StrategyComparisonBloc, ComparisonState>(
          builder: (context, state) {
            if (state is ComparisonRunning)
              return Center(child: CircularProgressIndicator());

            if (state is ComparisonSuccess) {
              final results = state.results;
              return ListView(
                children: results.entries.map((e) {
                  final key = e.key;
                  final res = e.value;
                  return ListTile(
                    title: Text("Strategy: \$key"),
                    subtitle: Text("Net: \${res.netProfit} | WinRate: \${res.winRate}"),
                  );
                }).toList(),
              );
            }

            if (state is ComparisonError)
              return Center(child: Text(state.message));

            return Center(
              child: ElevatedButton(
                child: Text("Start Comparison"),
                onPressed: () {
                  final set = StrategySet(
                    strategies: configs.map((c) => StrategyInstance(id: c.id, config: c)).toList(),
                  );
                  context.read<StrategyComparisonBloc>().add(
                        RunComparison(set: set, history: history),
                      );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
EOF
cat > lib/features/market/domain/indicators/types/indicator_type.dart << 'EOF'
enum IndicatorDisplayMode {
  overlay,     // رسم فوق الشارت
  subChart,    // رسم أسفل الشارت في نافذة مستقلة
}

class IndicatorType {
  final String id;
  final String label;
  final IndicatorDisplayMode mode;

  const IndicatorType({
    required this.id,
    required this.label,
    required this.mode,
  });
}

const IndicatorType EMA = IndicatorType(id: "ema", label: "EMA", mode: IndicatorDisplayMode.overlay);
const IndicatorType BOLLINGER = IndicatorType(id: "bollinger", label: "Bollinger Bands", mode: IndicatorDisplayMode.overlay);
const IndicatorType STOCH = IndicatorType(id: "stoch", label: "Stochastic", mode: IndicatorDisplayMode.subChart);
const IndicatorType RSI = IndicatorType(id: "rsi", label: "RSI", mode: IndicatorDisplayMode.subChart);
EOF
cat >> lib/features/market/domain/indicators/types/indicator_series.dart << 'EOF'
import 'indicator_type.dart';

class IndicatorSeries {
  final List<double> values;
  final String label;
  final IndicatorDisplayMode displayMode;

  IndicatorSeries({
    required this.values,
    required this.label,
    required this.displayMode,
  });
}
EOF
cat > lib/features/market/presentation/widgets/custom_chart/multi_indicator_chart.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../domain/indicators/types/indicator_series.dart';

class MultiIndicatorChart extends StatelessWidget {
  final List<double> prices;
  final List<IndicatorSeries> indicators;

  MultiIndicatorChart({
    required this.prices,
    required this.indicators,
  });

  @override
  Widget build(BuildContext context) {
    final overlaySeries =
        indicators.where((i) => i.displayMode == IndicatorDisplayMode.overlay);
    final subCharts =
        indicators.where((i) => i.displayMode == IndicatorDisplayMode.subChart);

    return Column(
      children: [
        // Main Chart with overlay
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              CandlesPainter(candles: prices), // افترضنا أنه يحوّل الأسعار لـ OHLC خطوط
              ...overlaySeries.map((ind) => IndicatorPainter(values: ind.values)),
            ],
          ),
        ),

        // Sub‑chart indicators
        Expanded(
          flex: 1,
          child: ListView(
            children: subCharts.map((ind) {
              return SizedBox(
                height: 120,
                child: IndicatorSubChartPainter(values: ind.values, label: ind.label),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
EOF
cat >> lib/features/settings/presentation/pages/theme/theme_settings_page.dart << 'EOF'

void _pickColor(BuildContext context, Color currentColor, Function(Color) onColorChanged) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Pick a Color"),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: currentColor,
          onColorChanged: onColorChanged,
        ),
      ),
      actions: [
        ElevatedButton(
          child: Text("Done"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    ),
  );
}

void _updateIndicatorColor(BuildContext context, String id, Color color) {
  final theme = context.read<ThemeBloc>().state.theme;
  final updatedTheme = AppTheme(
    mode: theme.mode,
    bullCandle: theme.bullCandle,
    bearCandle: theme.bearCandle,
    emaColor: id == "ema" ? color : theme.emaColor,
    stochColor: id == "stoch" ? color : theme.stochColor,
    rsiColor: id == "rsi" ? color : theme.rsiColor,
    bollingerColor: id == "bollinger" ? color : theme.bollingerColor,
  );
  context.read<ThemeBloc>().add(UpdateThemeColors(updatedTheme));
}
EOF
cat > lib/features/market/domain/chart/x_axis_range.dart << 'EOF'
class XAxisRange {
  final DateTime min;
  final DateTime max;

  const XAxisRange({required this.min, required this.max});

  bool contains(DateTime t) => t.isAfter(min) && t.isBefore(max);
}
EOF
cat >> lib/features/market/presentation/bloc/chart/chart_event.dart << 'EOF'
class VisibleRangeChanged extends ChartEvent {
  final DateTime min;
  final DateTime max;
  VisibleRangeChanged({required this.min, required this.max});
}
EOF
cat >> lib/features/market/presentation/bloc/chart/chart_bloc.dart << 'EOF'

    on<VisibleRangeChanged>((event, emit) {
      if (state is ChartLoaded) {
        final current = state as ChartLoaded;
        emit(ChartLoaded(candles: current.candles, visibleRange: XAxisRange(min: event.min, max: event.max)));
      }
    });
EOF
cat > lib/features/market/presentation/widgets/custom_chart/utils/chart_mapping.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../domain/chart/x_axis_range.dart';
import '../../../domain/entities/candle.dart';

double mapTimeToX(DateTime time, XAxisRange range, double width) {
  final total = range.max.millisecondsSinceEpoch - range.min.millisecondsSinceEpoch;
  final delta = time.millisecondsSinceEpoch - range.min.millisecondsSinceEpoch;
  return (delta / total) * width;
}

double mapPriceToY(double price, double minPrice, double maxPrice, double height) {
  return height * (1 - ((price - minPrice) / (maxPrice - minPrice)));
}
EOF
cat > lib/features/market/presentation/widgets/custom_chart/subchart_rsi_painter.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../domain/chart/x_axis_range.dart';
import '../utils/chart_mapping.dart';

class RSIChartPainter extends CustomPainter {
  final List<DateTime> times;
  final List<double> values;
  final XAxisRange visibleRange;

  RSIChartPainter({required this.times, required this.values, required this.visibleRange});

  @override
  void paint(Canvas canvas, Size size) {
    final paintRsi = Paint()..color = Colors.purple..strokeWidth = 1.5;

    double maxVal = values.reduce((a, b) => a > b ? a : b);
    double minVal = values.reduce((a, b) => a < b ? a : b);

    for (int i = 0; i < times.length; i++) {
      if (!visibleRange.contains(times[i])) continue;
      final x = mapTimeToX(times[i], visibleRange, size.width);
      final y = mapPriceToY(values[i], minVal, maxVal, size.height);
      if (i > 0 && visibleRange.contains(times[i-1])) {
        final prevX = mapTimeToX(times[i-1], visibleRange, size.width);
        final prevY = mapPriceToY(values[i-1], minVal, maxVal, size.height);
        canvas.drawLine(Offset(prevX, prevY), Offset(x, y), paintRsi);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RSIChartPainter old) => old.times != times || old.visibleRange != visibleRange;
}
EOF
cat > lib/features/replay/domain/entities/replay_event.dart << 'EOF'
import '../../../market/domain/entities/candle.dart';

/// Replicate an event in the replay (e.g., new candle)
class ReplayEvent {
  final CandleEntity candle;
  final DateTime timestamp; // time at which this should fire in replay

  ReplayEvent({required this.candle, required this.timestamp});
}
EOF
cat > lib/features/replay/domain/entities/speed.dart << 'EOF'
enum ReplaySpeed {
  x1,
  x2,
  x5,
  x10,
}

extension SpeedMultiplier on ReplaySpeed {
  double get multiplier {
    switch (this) {
      case ReplaySpeed.x2:
        return 2.0;
      case ReplaySpeed.x5:
        return 5.0;
      case ReplaySpeed.x10:
        return 10.0;
      case ReplaySpeed.x1:
      default:
        return 1.0;
    }
  }
}
EOF
cat > lib/features/replay/data/datasources/replay_data_source.dart << 'EOF'
import '../../../../market/domain/entities/candle.dart';
import '../../../../market/domain/repositories/market_repository.dart';

class ReplayDataSource {
  final MarketRepository repository;

  ReplayDataSource(this.repository);

  /// Fetch huge range for replay (مثلاً 5000 شمعة)
  Future<List<CandleEntity>> fetchForReplay({
    required String symbol,
    required String timeframe,
    int count = 5000,
  }) async {
    final models = await repository.getHistoricalCandlesPage(
      symbol: symbol,
      timeframe: timeframe,
      count: count,
    );
    return models.map((m) => m.toEntity()).toList();
  }
}
EOF
cat > lib/features/replay/domain/engine/replay_engine.dart << 'EOF'
import 'dart:async';
import '../../../market/domain/entities/candle.dart';
import '../entities/speed.dart';

typedef OnCandleCallback = void Function(CandleEntity);

class ReplayEngine {
  final List<CandleEntity> candles;
  final OnCandleCallback onCandle;
  final ReplaySpeed speed;

  Timer? _timer;
  int _index = 0;

  ReplayEngine({
    required this.candles,
    required this.onCandle,
    this.speed = ReplaySpeed.x1,
  });

  void start() {
    stop();
    _index = 0;
    if (candles.isEmpty) return;

    final baseDelay = Duration(seconds: 1);
    final intervalMs = baseDelay.inMilliseconds ~/ speed.multiplier;

    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (_index >= candles.length) {
        stop();
        return;
      }
      onCandle(candles[_index]);
      _index++;
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void pause() => stop();

  bool get isRunning => _timer != null;
}
EOF
cat > lib/features/replay/presentation/bloc/replay_event.dart << 'EOF'
import '../../../replay/domain/entities/speed.dart';

abstract class ReplayEvent {}

class LoadReplayData extends ReplayEvent {
  final String symbol;
  final String timeframe;
  LoadReplayData({required this.symbol, required this.timeframe});
}

class StartReplay extends ReplayEvent {}

class PauseReplay extends ReplayEvent {}

class StopReplay extends ReplayEvent {}

class ChangeReplaySpeed extends ReplayEvent {
  final ReplaySpeed speed;
  ChangeReplaySpeed(this.speed);
}
EOF
cat > lib/features/replay/presentation/bloc/replay_state.dart << 'EOF'
import '../../../replay/domain/entities/speed.dart';

abstract class ReplayState {}

class ReplayIdle extends ReplayState {}

class ReplayLoading extends ReplayState {}

class ReplayReady extends ReplayState {
  final int total;
  final ReplaySpeed speed;
  ReplayReady({required this.total, required this.speed});
}

class ReplayRunning extends ReplayState {
  final int index;
  final int total;
  final ReplaySpeed speed;
  ReplayRunning({required this.index, required this.total, required this.speed});
}

class ReplayPaused extends ReplayState {
  final int index;
  final int total;
  final ReplaySpeed speed;
  ReplayPaused({required this.index, required this.total, required this.speed});
}

class ReplayError extends ReplayState {
  final String message;
  ReplayError(this.message);
}
EOF
cat > lib/features/replay/presentation/bloc/replay_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../replay/domain/engine/replay_engine.dart';
import '../../../replay/domain/entities/speed.dart';
import '../../../replay/data/datasources/replay_data_source.dart';
import '../../../market/domain/entities/candle.dart';
import 'replay_event.dart';
import 'replay_state.dart';

class ReplayBloc extends Bloc<ReplayEvent, ReplayState> {
  final ReplayDataSource dataSource;
  final Function(CandleEntity) onCandle;
  
  List<CandleEntity> _data = [];
  ReplayEngine? _engine;
  ReplaySpeed _speed = ReplaySpeed.x1;

  ReplayBloc({required this.dataSource, required this.onCandle}) : super(ReplayIdle()) {
    on<LoadReplayData>(_onLoadData);
    on<StartReplay>(_onStart);
    on<PauseReplay>(_onPause);
    on<StopReplay>(_onStop);
    on<ChangeReplaySpeed>(_onChangeSpeed);
  }

  Future<void> _onLoadData(LoadReplayData event, Emitter<ReplayState> emit) async {
    emit(ReplayLoading());
    try {
      _data = await dataSource.fetchForReplay(
        symbol: event.symbol,
        timeframe: event.timeframe,
      );
      emit(ReplayReady(total: _data.length, speed: _speed));
    } catch (e) {
      emit(ReplayError("Replay load failed"));
    }
  }

  void _onStart(StartReplay event, Emitter<ReplayState> emit) {
    if (_data.isEmpty) {
      emit(ReplayError("No data for replay"));
      return;
    }
    _engine?.stop();
    _engine = ReplayEngine(
      candles: _data,
      speed: _speed,
      onCandle: onCandle,
    );
    _engine!.start();
    emit(ReplayRunning(index: 0, total: _data.length, speed: _speed));
  }

  void _onPause(PauseReplay event, Emitter<ReplayState> emit) {
    _engine?.pause();
    emit(ReplayPaused(index: 0, total: _data.length, speed: _speed));
  }

  void _onStop(StopReplay event, Emitter<ReplayState> emit) {
    _engine?.stop();
    emit(ReplayReady(total: _data.length, speed: _speed));
  }

  void _onChangeSpeed(ChangeReplaySpeed event, Emitter<ReplayState> emit) {
    _speed = event.speed;
    emit(ReplayReady(total: _data.length, speed: _speed));
  }
}
EOF
cat > lib/features/replay/presentation/pages/replay_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../market/domain/entities/candle.dart';
import '../../presentation/bloc/replay_bloc.dart';
import '../../presentation/bloc/replay_event.dart';
import '../../presentation/bloc/replay_state.dart';
import '../../../replay/domain/entities/speed.dart';

class ReplayPage extends StatelessWidget {
  final String symbol;
  final String timeframe;

  ReplayPage({required this.symbol, required this.timeframe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Market Replay (\$symbol)")),
      body: Column(
        children: [
          BlocBuilder<ReplayBloc, ReplayState>(
            builder: (context, state) {
              if (state is ReplayLoading) return CircularProgressIndicator();
              if (state is ReplayError) return Text(state.message);
              if (state is ReplayReady || state is ReplayPaused || state is ReplayRunning) {
                final total = (state as dynamic).total;
                final speed = (state as dynamic).speed;
                int index = (state is ReplayRunning) ? state.index : ((state is ReplayPaused) ? state.index : 0);

                return Column(
                  children: [
                    Text("Progress: \$index / \$total"),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(onPressed: () => context.read<ReplayBloc>().add(StartReplay()), child: Text("Start")),
                        ElevatedButton(onPressed: () => context.read<ReplayBloc>().add(PauseReplay()), child: Text("Pause")),
                        ElevatedButton(onPressed: () => context.read<ReplayBloc>().add(StopReplay()), child: Text("Stop")),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Speed:"),
                        DropdownButton<ReplaySpeed>(
                          value: speed,
                          items: ReplaySpeed.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                          onChanged: (s) => context.read<ReplayBloc>().add(ChangeReplaySpeed(s!)),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return ElevatedButton(
                onPressed: () => context.read<ReplayBloc>().add(LoadReplayData(symbol: symbol, timeframe: timeframe)),
                child: Text("Load Data"),
              );
            },
          ),
        ],
      ),
    );
  }
}
EOF
cat >> lib/features/market/presentation/bloc/chart/chart_event.dart << 'EOF'
class NewReplayCandle extends ChartEvent {
  final CandleEntity candle;
  NewReplayCandle(this.candle);
}
EOF
cat >> lib/features/market/presentation/bloc/chart/chart_bloc.dart << 'EOF'
    on<NewReplayCandle>((event, emit) {
      // نفس منطق الـ live tick
      _processTick(event.candle);
    });
EOF
cat > lib/features/strategy_builder/domain/entities/block_type.dart << 'EOF'
enum BlockType {
  // Conditions
  priceAbove,
  priceBelow,
  emaCrossUp,
  emaCrossDown,
  rsiBelow,
  rsiAbove,

  // Logical connectors
  and,
  or,

  // Actions
  buy,
  sell,
}
EOF
cat > lib/features/strategy_builder/domain/entities/block.dart << 'EOF'
import 'block_type.dart';

class Block {
  final String id; // unique
  final BlockType type;
  final Map<String, dynamic> params; // e.g., period, threshold
  Block({required this.id, required this.type, Map<String, dynamic>? params})
      : this.params = params ?? {};
}
EOF
cat > lib/features/strategy_builder/domain/entities/connection.dart << 'EOF'
class Connection {
  final String fromBlockId;
  final String toBlockId;

  Connection({required this.fromBlockId, required this.toBlockId});
}
EOF
cat > lib/features/strategy_builder/domain/models/strategy_graph.dart << 'EOF'
import '../entities/block.dart';
import '../entities/connection.dart';

class StrategyGraph {
  final List<Block> blocks;
  final List<Connection> connections;

  StrategyGraph({required this.blocks, required this.connections});

  Map<String, dynamic> toJson() {
    return {
      "blocks": blocks.map((b) => {
            "id": b.id,
            "type": b.type.toString(),
            "params": b.params,
          }).toList(),
      "connections": connections
          .map((c) => {"from": c.fromBlockId, "to": c.toBlockId})
          .toList(),
    };
  }

  factory StrategyGraph.fromJson(Map<String, dynamic> json) {
    final blocks = (json["blocks"] as List<dynamic>)
        .map((b) => Block(
              id: b["id"],
              type: BlockType.values.firstWhere(
                  (e) => e.toString() == b["type"]),
              params: Map<String, dynamic>.from(b["params"] ?? {}),
            ))
        .toList();
    final connections = (json["connections"] as List<dynamic>)
        .map((c) => Connection(
              fromBlockId: c["from"],
              toBlockId: c["to"],
            ))
        .toList();
    return StrategyGraph(blocks: blocks, connections: connections);
  }
}
EOF
cat > lib/features/strategy_builder/presentation/widgets/block_palette.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../domain/entities/block_type.dart';

class BlockPalette extends StatelessWidget {
  final Function(BlockType) onDragStart;

  const BlockPalette({required this.onDragStart});

  @override
  Widget build(BuildContext context) {
    final blocks = {
      "Price Above": BlockType.priceAbove,
      "Price Below": BlockType.priceBelow,
      "EMA Cross Up": BlockType.emaCrossUp,
      "EMA Cross Down": BlockType.emaCrossDown,
      "RSI Below": BlockType.rsiBelow,
      "RSI Above": BlockType.rsiAbove,
      "AND": BlockType.and,
      "OR": BlockType.or,
      "BUY": BlockType.buy,
      "SELL": BlockType.sell,
    };

    return Container(
      width: 180,
      color: Colors.grey.shade900,
      child: ListView(
        children: blocks.entries.map((e) {
          return Draggable<BlockType>(
            data: e.value,
            feedback: _buildBlock(e.key, Colors.blueAccent),
            child: _buildBlock(e.key, Colors.white),
            onDragStarted: () => onDragStart(e.value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBlock(String label, Color color) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text(label, style: TextStyle(color: color))),
    );
  }
}
EOF
cat > lib/features/strategy_builder/presentation/canvas/node_widget.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../domain/entities/block.dart';
import '../../domain/entities/block_type.dart';

class StrategyNode extends StatelessWidget {
  final Block block;
  final Offset position;

  const StrategyNode({required this.block, required this.position});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Container(
        width: 180,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 1)
          ],
        ),
        child: Column(
          children: [
            Text(
              block.type.toString().split('.').last,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildPorts(),
          ],
        ),
      ),
    );
  }

  Widget _buildPorts() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _port(Icons.input, Colors.green),  // input port
        _port(Icons.output, Colors.red),   // output port
      ],
    );
  }

  Widget _port(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color),
      ),
      child: Icon(icon, size: 14, color: color),
    );
  }
}
EOF
cat > lib/features/strategy_builder/presentation/canvas/strategy_canvas.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../domain/entities/block.dart';
import '../../domain/entities/block_type.dart';
import '../../domain/entities/connection.dart';
import 'node_widget.dart';

class StrategyCanvas extends StatefulWidget {
  final List<Block> blocks;
  final List<Connection> connections;
  final Function(Block, Offset) onDrop;

  const StrategyCanvas({
    required this.blocks,
    required this.connections,
    required this.onDrop,
  });

  @override
  State<StrategyCanvas> createState() => _StrategyCanvasState();
}

class _StrategyCanvasState extends State<StrategyCanvas> {
  final Map<String, Offset> nodePositions = {};

  @override
  Widget build(BuildContext context) {
    return DragTarget<BlockType>(
      onAcceptWithDetails: (details) {
        final position = details.offset;
        final newBlock = Block(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: details.data,
        );
        widget.onDrop(newBlock, position);
        nodePositions[newBlock.id] = position;
      },
      builder: (context, candidateData, rejectedData) {
        return Stack(
          children: [
            Container(color: Colors.grey.shade800),
            ...widget.blocks.map((b) {
              final pos = nodePositions[b.id] ?? Offset(100, 100);
              return StrategyNode(block: b, position: pos);
            }).toList(),
          ],
        );
      },
    );
  }
}
EOF
cat > lib/features/strategy_builder/presentation/canvas/connection_painter.dart << 'EOF'
import 'package:flutter/material.dart';

class ConnectionPainter extends CustomPainter {
  final List<Offset> points;

  ConnectionPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (points.length < 2) return;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final control = Offset((prev.dx + curr.dx) / 2, prev.dy);
      path.quadraticBezierTo(control.dx, control.dy, curr.dx, curr.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ConnectionPainter oldDelegate) => true;
}
EOF
cat > lib/features/strategy_builder/domain/interpreter/strategy_interpreter.dart << 'EOF'
import '../entities/block.dart';
import '../entities/block_type.dart';
import '../models/strategy_graph.dart';
import '../../../market/domain/entities/candle.dart';

class StrategyInterpreter {
  final StrategyGraph graph;

  StrategyInterpreter(this.graph);

  bool evaluate(List<CandleEntity> history) {
    final Map<String, bool> results = {};

    for (var block in graph.blocks) {
      results[block.id] = _evalBlock(block, history, results);
    }

    // Find final BUY/SELL blocks
    final buyBlocks =
        graph.blocks.where((b) => b.type == BlockType.buy).toList();
    for (var b in buyBlocks) {
      final incoming = graph.connections
          .where((c) => c.toBlockId == b.id)
          .map((c) => results[c.fromBlockId] ?? false)
          .toList();

      if (incoming.every((v) => v == true)) return true;
    }

    return false;
  }

  bool _evalBlock(Block b, List<CandleEntity> history, Map<String, bool> results) {
    switch (b.type) {
      case BlockType.priceAbove:
        return history.last.close >
            history[history.length - 2].close;

      case BlockType.rsiBelow:
        return b.params["value"] != null
            ? history.last.close < b.params["value"]
            : true;

      case BlockType.and:
        final inputs = graph.connections
            .where((c) => c.toBlockId == b.id)
            .map((c) => results[c.fromBlockId] ?? false)
            .toList();
        return inputs.every((v) => v);

      case BlockType.or:
        final inputs = graph.connections
            .where((c) => c.toBlockId == b.id)
            .map((c) => results[c.fromBlockId] ?? false)
            .toList();
        return inputs.any((v) => v);

      default:
        return false;
    }
  }
}
EOF
cat > lib/features/strategy_builder/data/strategy_storage.dart << 'EOF'
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/strategy_graph.dart';

class StrategyStorage {
  static const _key = "saved_strategy";

  Future<void> save(StrategyGraph graph) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(graph.toJson()));
  }

  Future<StrategyGraph?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return null;
    return StrategyGraph.fromJson(jsonDecode(data));
  }
}
EOF
cat > lib/features/portrait/presentation/pages/portrait_home_page.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../market/presentation/pages/interactive_chart_page.dart';
import '../widgets/portrait_tabs.dart';

class PortraitHomePage extends StatefulWidget {
  final String symbol;
  PortraitHomePage({required this.symbol});

  @override
  _PortraitHomePageState createState() => _PortraitHomePageState();
}

class _PortraitHomePageState extends State<PortraitHomePage> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: [
                  InteractiveChartPage(symbol: widget.symbol),
                  IndicatorsPortraitPage(), // سننشئها بعد قليل
                  OrdersPortraitPage(),     // سننشئها بعد قليل
                  AlertsPortraitPage(),     // سننشئها بعد قليل
                ],
              ),
            ),
            PortraitTabBar(
              currentIndex: _currentTab,
              onTap: (idx) => setState(() => _currentTab = idx),
            ),
          ],
        ),
      ),
    );
  }
}
EOF
cat > lib/features/portrait/presentation/pages/indicators_portrait_page.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../market/presentation/bloc/chart/chart_bloc.dart';
import '../../../market/presentation/bloc/chart/chart_state.dart';
import '../../../market/presentation/widgets/custom_chart/multi_indicator_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndicatorsPortraitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Indicators", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Expanded(
          child: BlocBuilder<ChartBloc, ChartState>(
            builder: (context, state) {
              if (state is ChartLoaded) {
                return MultiIndicatorChart(
                  prices: state.candles.map((c) => c.close).toList(),
                  indicators: state.indicators,
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
EOF
cat > lib/features/portrait/presentation/pages/orders_portrait_page.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../market/presentation/bloc/trading/trading_bloc.dart';
import '../../../market/presentation/bloc/trading/trading_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersPortraitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradingBloc, TradingState>(
      builder: (context, state) {
        if (state is TradingUpdated) {
          return ListView(
            padding: EdgeInsets.all(12),
            children: state.openPositions.map((p) {
              return ListTile(
                title: Text("${p.instrument} — ${p.units.toString()}"),
                subtitle: Text("P/L: ${p.floatingPL.toStringAsFixed(2)}"),
              );
            }).toList(),
          );
        }
        return Center(child: Text("No Positions"));
      },
    );
  }
}
EOF
cat > lib/features/portrait/presentation/pages/alerts_portrait_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../market/presentation/bloc/smart_alert/smart_alert_bloc.dart';
import '../../../market/presentation/bloc/smart_alert/smart_alert_state.dart';

class AlertsPortraitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmartAlertBloc, SmartAlertState>(
      builder: (context, state) {
        if (state is SmartAlertUpdated) {
          return ListView.builder(
            itemCount: state.alerts.length,
            itemBuilder: (ctx, i) {
              final alert = state.alerts[i];
              return ListTile(
                title: Text(alert.condition.type.toString()),
                subtitle: Text("Active"),
              );
            },
          );
        }
        return Center(child: Text("No Alerts"));
      },
    );
  }
}
EOF
cat > lib/features/portrait/presentation/widgets/portrait_floating_controls.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../replay/domain/entities/speed.dart';

class PortraitFloatingControls extends StatelessWidget {
  final Function() onZoomIn;
  final Function() onZoomOut;
  final Function(ReplaySpeed) onSpeedChange;

  const PortraitFloatingControls({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onSpeedChange,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Column(
        children: [
          FloatingActionButton(
            heroTag: "zoomIn",
            mini: true,
            child: Icon(Icons.zoom_in),
            onPressed: onZoomIn,
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "zoomOut",
            mini: true,
            child: Icon(Icons.zoom_out),
            onPressed: onZoomOut,
          ),
          SizedBox(height: 8),
          PopupMenuButton<ReplaySpeed>(
            icon: Icon(Icons.speed),
            itemBuilder: (_) => ReplaySpeed.values
                .map((s) => PopupMenuItem(value: s, child: Text(s.name)))
                .toList(),
            onSelected: (speed) => onSpeedChange(speed),
          ),
        ],
      ),
    );
  }
}
EOF
cat > lib/features/portrait/presentation/widgets/portrait_tabs.dart << 'EOF'
import 'package:flutter/material.dart';

class PortraitTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PortraitTabBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Chart"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Indicators"),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "Orders"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Alerts"),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
EOF
cat > lib/features/strategy_script/domain/token.dart << 'EOF'
enum TokenType {
  identifier,
  number,
  comparison,
  comma,
  leftParen,
  rightParen,
  keywordIf,
  keywordThen,
  semicolon,
  eof,
}

class Token {
  final TokenType type;
  final String lexeme;
  Token(this.type, this.lexeme);
}
EOF
cat > lib/features/strategy_script/domain/tokenizer.dart << 'EOF'
import 'token.dart';

class Tokenizer {
  final String _input;
  int _pos = 0;

  Tokenizer(this._input);

  List<Token> tokenize() {
    final tokens = <Token>[];

    while (_pos < _input.length) {
      final c = _input[_pos];

      if (c.trim().isEmpty) { _pos++; continue; }

      if (isLetter(c)) {
        final word = readWhile(isLetter);
        if (word.toUpperCase() == 'IF') tokens.add(Token(TokenType.keywordIf, word));
        else if (word.toUpperCase() == 'THEN') tokens.add(Token(TokenType.keywordThen, word));
        else tokens.add(Token(TokenType.identifier, word));
        continue;
      }

      if (isDigit(c)) {
        final numStr = readWhile((ch) => isDigit(ch) || ch == '.');
        tokens.add(Token(TokenType.number, numStr));
        continue;
      }

      switch (c) {
        case '>':
        case '<':
        case '=':
          tokens.add(Token(TokenType.comparison, c));
          break;
        case ',':
          tokens.add(Token(TokenType.comma, c));
          break;
        case '(':
          tokens.add(Token(TokenType.leftParen, c));
          break;
        case ')':
          tokens.add(Token(TokenType.rightParen, c));
          break;
        case ';':
          tokens.add(Token(TokenType.semicolon, c));
          break;
      }

      _pos++;
    }

    tokens.add(Token(TokenType.eof, ''));
    return tokens;
  }

  bool isLetter(String c) => RegExp(r'[A-Za-z_]').hasMatch(c);
  bool isDigit(String c) => RegExp(r'[0-9]').hasMatch(c);

  String readWhile(bool Function(String) test) {
    final start = _pos;
    while (_pos < _input.length && test(_input[_pos])) _pos++;
    return _input.substring(start, _pos);
  }
}
EOF
cat > lib/features/strategy_script/domain/ast.dart << 'EOF'
abstract class ASTNode {}

class IfStatement extends ASTNode {
  final Expression condition;
  final Action action;
  IfStatement(this.condition, this.action);
}

abstract class Expression extends ASTNode {}

class BinaryExpression extends Expression {
  final Expression left;
  final String op;
  final Expression right;
  BinaryExpression(this.left, this.op, this.right);
}

class FunctionCall extends Expression {
  final String name;
  final List<Expression> args;
  FunctionCall(this.name, this.args);
}

class NumberLiteral extends Expression {
  final double value;
  NumberLiteral(this.value);
}

class Identifier extends Expression {
  final String name;
  Identifier(this.name);
}

class Action extends ASTNode {
  final String type;
  Action(this.type);
}
EOF
cat > lib/features/strategy_script/domain/parser.dart << 'EOF'
import 'token.dart';
import 'tokenizer.dart';
import 'ast.dart';

class Parser {
  final List<Token> tokens;
  int _pos = 0;

  Parser(this.tokens);

  Token get current => tokens[_pos];

  void advance() => _pos++;

  bool accept(TokenType type) {
    if (current.type == type) { advance(); return true; }
    return false;
  }

  ASTNode? parse() {
    if (accept(TokenType.keywordIf)) {
      final cond = parseExpression();
      expect(TokenType.keywordThen);
      final act = parseAction();
      expect(TokenType.semicolon);
      return IfStatement(cond!, act);
    }
    return null;
  }

  Expression? parseExpression() {
    if (current.type == TokenType.identifier) {
      final name = current.lexeme;
      advance();
      if (accept(TokenType.leftParen)) {
        final args = <Expression>[];
        while (!accept(TokenType.rightParen)) {
          final expr = parseExpression();
          if (expr != null) args.add(expr);
          accept(TokenType.comma);
        }
        return FunctionCall(name, args);
      }
      return Identifier(name);
    }
    if (current.type == TokenType.number) {
      final val = double.parse(current.lexeme);
      advance();
      return NumberLiteral(val);
    }
    return null;
  }

  Action parseAction() {
    final name = current.lexeme;
    advance();
    return Action(name);
  }

  void expect(TokenType type) {
    if (current.type != type) throw Exception("Expected $type");
    advance();
  }
}
EOF
cat > lib/features/strategy_script/domain/interpreter.dart << 'EOF'
import 'ast.dart';
import '../../../market/domain/entities/candle.dart';
import '../../strategy_script/domain/ast.dart';

typedef IndicatorFunc = List<double> Function(List<CandleEntity>, int);

class ScriptInterpreter {
  final List<ASTNode> ast;
  final Map<String, IndicatorFunc> indicatorLibrary;

  ScriptInterpreter(this.ast, this.indicatorLibrary);

  bool evaluate(List<CandleEntity> history) {
    for (var node in ast) {
      if (node is IfStatement) {
        final cond = _evalExpression(node.condition, history);
        if (cond) {
          if (node.action.type.toUpperCase() == 'BUY') return true;
        }
      }
    }
    return false;
  }

  dynamic _evalExpression(Expression expr, List<CandleEntity> history) {
    if (expr is FunctionCall) {
      final name = expr.name.toUpperCase();
      final args = expr.args.map((e) => _evalExpression(e, history)).toList();

      if (indicatorLibrary.containsKey(name)) {
        return indicatorLibrary[name]!(history, args[1].toInt());
      }
    }
    return null;
  }
}
EOF
cat > lib/features/strategy_script/data/script_storage.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';

class ScriptStorage {
  static const _key = 'strategy_script';

  Future<void> save(String script) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, script);
  }

  Future<String?> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
EOF
cat > lib/features/strategy_script/presentation/pages/script_editor_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../strategy_script/data/script_storage.dart';

class ScriptEditorPage extends StatefulWidget {
  @override
  _ScriptEditorPageState createState() => _ScriptEditorPageState();
}

class _ScriptEditorPageState extends State<ScriptEditorPage> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    ScriptStorage().load().then((value) {
      if (value != null) setState(() => controller.text = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Strategy Script")),
      body: Column(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScriptStorage().save(controller.text);
              Navigator.pop(context);
            },
            child: Text("Save Script"),
          ),
        ],
      ),
    );
  }
}
EOF
cat > lib/features/market/domain/indicators/ema_calculator.dart << 'EOF'
import '../../../market/domain/entities/candle.dart';

class EMAResult {
  final List<double> values;
  EMAResult(this.values);
}

class EMACalculator {
  static EMAResult calculate(List<CandleEntity> data, int period) {
    final values = <double>[];
    if (data.isEmpty || period <= 0) return EMAResult(values);

    final k = 2 / (period + 1);
    double? prevEma;

    for (int i = 0; i < data.length; i++) {
      final price = data[i].close;
      if (i + 1 < period) {
        // Not enough data yet — push 0 or null
        values.add(0.0);
      } else if (i + 1 == period) {
        // First EMA = simple average
        final sum = data.sublist(0, period).fold(0.0, (p, c) => p + c.close);
        prevEma = sum / period;
        values.add(prevEma);
      } else {
        final ema = (price - prevEma!) * k + prevEma;
        prevEma = ema;
        values.add(ema);
      }
    }

    return EMAResult(values);
  }
}
EOF
cat > lib/features/market/domain/indicators/rsi_calculator.dart << 'EOF'
import '../../../market/domain/entities/candle.dart';

class RSIResult {
  final List<double> values;
  RSIResult(this.values);
}

class RSICalculator {
  static RSIResult calculate(List<CandleEntity> data, int period) {
    final values = <double>[];
    if (data.length <= period) return RSIResult(values);

    List<double> gains = [];
    List<double> losses = [];

    for (int i = 1; i < data.length; i++) {
      final change = data[i].close - data[i - 1].close;
      gains.add(change > 0 ? change : 0);
      losses.add(change < 0 ? -change : 0);
    }

    double avgGain = gains.take(period).reduce((a, b) => a + b) / period;
    double avgLoss = losses.take(period).reduce((a, b) => a + b) / period;
    values.add(100 - (100 / (1 + (avgGain / avgLoss))));

    for (int i = period; i < gains.length; i++) {
      avgGain = ((avgGain * (period - 1)) + gains[i]) / period;
      avgLoss = ((avgLoss * (period - 1)) + losses[i]) / period;

      final rs = avgGain / (avgLoss == 0 ? 1 : avgLoss);
      final rsi = 100 - (100 / (1 + rs));
      values.add(rsi);
    }

    return RSIResult(values);
  }
}
EOF
cat > lib/features/market/domain/indicators/macd_calculator.dart << 'EOF'
import '../../../market/domain/entities/candle.dart';
import 'ema_calculator.dart';

class MACDResult {
  final List<double> macd;
  final List<double> signal;
  final List<double> histogram;

  MACDResult({required this.macd, required this.signal, required this.histogram});
}

class MACDCalculator {
  static MACDResult calculate(List<CandleEntity> data, {int fast = 12, int slow = 26, int signalPeriod = 9}) {
    final close = data.map((c) => c.close).toList();
    final fastEma = EMACalculator.calculate(data, fast).values;
    final slowEma = EMACalculator.calculate(data, slow).values;

    final macdLine = List<double>.generate(close.length, (i) {
      if (i < slow - 1) return 0.0;
      return fastEma[i] - slowEma[i];
    });

    final signalLine = <double>[];
    double? prevSignal;

    for (int i = 0; i < macdLine.length; i++) {
      if (i < slow - 1 + signalPeriod - 1) {
        signalLine.add(0.0);
      } else if (i == slow - 1 + signalPeriod - 1) {
        final sum = macdLine.sublist(slow - 1, slow - 1 + signalPeriod).fold(0.0, (a, b) => a + b);
        prevSignal = sum / signalPeriod;
        signalLine.add(prevSignal);
      } else {
        final next = ((macdLine[i] - prevSignal!) * (2 / (signalPeriod + 1))) + prevSignal;
        prevSignal = next;
        signalLine.add(next);
      }
    }

    final hist = List<double>.generate(close.length, (i) => macdLine[i] - signalLine[i]);

    return MACDResult(macd: macdLine, signal: signalLine, histogram: hist);
  }
}
EOF
cat > lib/features/market/domain/indicators/bollinger_calculator.dart << 'EOF'
import '../../../market/domain/entities/candle.dart';
import 'dart:math';

class BollingerResult {
  final List<double> middle;
  final List<double> upper;
  final List<double> lower;

  BollingerResult({required this.middle, required this.upper, required this.lower});
}

class BollingerCalculator {
  static BollingerResult calculate(List<CandleEntity> data, int period, double mult) {
    final closes = data.map((c) => c.close).toList();
    final middle = <double>[];
    final upper = <double>[];
    final lower = <double>[];

    for (int i = 0; i < closes.length; i++) {
      if (i + 1 >= period) {
        final window = closes.sublist(i + 1 - period, i + 1);
        final mean = window.reduce((a, b) => a + b) / period;
        final variance = window.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) / period;
        final stdDev = sqrt(variance);

        middle.add(mean);
        upper.add(mean + (stdDev * mult));
        lower.add(mean - (stdDev * mult));
      } else {
        middle.add(0.0);
        upper.add(0.0);
        lower.add(0.0);
      }
    }

    return BollingerResult(middle: middle, upper: upper, lower: lower);
  }
}
EOF
cat > lib/features/market/presentation/widgets/chart_utils/chart_mapper.dart << 'EOF'
import 'dart:ui';
import '../../../market/domain/chart/x_axis_range.dart';

/// Convert a timestamp (DateTime) to an X pixel
double timeToPx(DateTime t, XAxisRange range, double width) {
  final total = range.max.millisecondsSinceEpoch - range.min.millisecondsSinceEpoch;
  if (total == 0) return 0.0;
  final delta = t.millisecondsSinceEpoch - range.min.millisecondsSinceEpoch;
  return (delta / total) * width;
}

/// Convert a price to a Y pixel (inverted coordinate system)
double priceToPx(double price, double minPrice, double maxPrice, double height) {
  if (maxPrice - minPrice == 0) return height / 2;
  return height * (1 - (price - minPrice) / (maxPrice - minPrice));
}
EOF
cat > lib/features/market/presentation/widgets/candles_painter.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../market/domain/entities/candle.dart';
import 'chart_utils/chart_mapper.dart';
import '../../../market/domain/chart/x_axis_range.dart';

class CandlesPainter extends CustomPainter {
  final List<CandleEntity> candles;
  final XAxisRange visibleRange;

  CandlesPainter({required this.candles, required this.visibleRange});

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    double minPrice = candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    double maxPrice = candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);

    final paintBull = Paint()..color = Colors.green;
    final paintBear = Paint()..color = Colors.red;

    for (var c in candles) {
      if (!visibleRange.contains(c.time)) continue;

      final x = timeToPx(c.time, visibleRange, size.width);
      final yHigh = priceToPx(c.high, minPrice, maxPrice, size.height);
      final yLow = priceToPx(c.low, minPrice, maxPrice, size.height);
      final yOpen = priceToPx(c.open, minPrice, maxPrice, size.height);
      final yClose = priceToPx(c.close, minPrice, maxPrice, size.height);

      final isBull = c.close >= c.open;
      final paint = isBull ? paintBull : paintBear;

      // Wick
      canvas.drawLine(Offset(x, yHigh), Offset(x, yLow), paint);

      // Body
      final bodyTop = isBull ? yClose : yOpen;
      final bodyBottom = isBull ? yOpen : yClose;
      canvas.drawRect(Rect.fromLTRB(x - 2, bodyTop, x + 2, bodyBottom), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CandlesPainter old) {
    return old.visibleRange != visibleRange || old.candles != candles;
  }
}
EOF
cat > lib/features/market/presentation/widgets/overlay_indicators_painter.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../market/domain/indicators/types/indicator_series.dart';
import 'chart_utils/chart_mapper.dart';
import '../../../market/domain/chart/x_axis_range.dart';

class OverlayIndicatorsPainter extends CustomPainter {
  final List<IndicatorSeries> seriesList;
  final List<DateTime> times;
  final XAxisRange visibleRange;
  final double minPrice;
  final double maxPrice;

  OverlayIndicatorsPainter({
    required this.seriesList,
    required this.times,
    required this.visibleRange,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var series in seriesList) {
      final paint = Paint()
        ..color = series.color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      Path path = Path();
      bool started = false;

      for (int i = 0; i < times.length; i++) {
        if (!visibleRange.contains(times[i])) continue;

        final x = timeToPx(times[i], visibleRange, size.width);
        final y = priceToPx(series.values[i], minPrice, maxPrice, size.height);

        if (!started) {
          path.moveTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant OverlayIndicatorsPainter old) => true;
}
EOF
cat > lib/features/market/presentation/widgets/subchart_rsi_painter.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../market/domain/chart/x_axis_range.dart';
import 'chart_utils/chart_mapper.dart';

class RSIChartPainter extends CustomPainter {
  final List<DateTime> times;
  final List<double> values;
  final XAxisRange visibleRange;

  RSIChartPainter({required this.times, required this.values, required this.visibleRange});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.purple..strokeWidth = 1.5;

    double maxVal = values.reduce((a, b) => a > b ? a : b);
    double minVal = values.reduce((a, b) => a < b ? a : b);

    Path path = Path();
    bool started = false;

    for (int i = 0; i < times.length; i++) {
      if (!visibleRange.contains(times[i])) continue;

      final x = timeToPx(times[i], visibleRange, size.width);
      final y = priceToPx(values[i], minVal, maxVal, size.height);

      if (!started) {
        path.moveTo(x, y);
        started = true;
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant RSIChartPainter old) => true;
}
EOF
cat > lib/core/widgets/crosshair.dart << 'EOF'
import 'package:flutter/material.dart';

class CrosshairPainter extends CustomPainter {
  final Offset position;
  final XAxisRange visibleRange;
  final double minPrice;
  final double maxPrice;

  CrosshairPainter({
    required this.position,
    required this.visibleRange,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 1;

    // Vertical line
    canvas.drawLine(Offset(position.dx, 0), Offset(position.dx, size.height), paint);

    // Horizontal line
    canvas.drawLine(Offset(0, position.dy), Offset(size.width, position.dy), paint);
  }

  @override
  bool shouldRepaint(covariant CrosshairPainter old) => old.position != position;
}
EOF
cat > lib/core/widgets/marker_painter.dart << 'EOF'
import 'package:flutter/material.dart';

class MarkerPainter extends CustomPainter {
  final List<Offset> buyPoints;
  final List<Offset> sellPoints;

  MarkerPainter({required this.buyPoints, required this.sellPoints});

  @override
  void paint(Canvas canvas, Size size) {
    final paintBuy = Paint()..color = Colors.greenAccent;
    final paintSell = Paint()..color = Colors.redAccent;

    for (var p in buyPoints) {
      canvas.drawCircle(p, 6, paintBuy);
    }
    for (var p in sellPoints) {
      canvas.drawCircle(p, 6, paintSell);
    }
  }

  @override
  bool shouldRepaint(covariant MarkerPainter old) => true;
}
EOF
cat >> lib/core/network/oanda_rest_client.dart << 'EOF'

  void setTokenExpiredCallback(Function()? callback) {
    _tokenExpiredCallback = callback;
  }

  Function()? _tokenExpiredCallback;
EOF
cat >> lib/features/market/presentation/bloc/oanda/oanda_setup_event.dart << 'EOF'
class TokenExpiredEvent extends OandaSetupEvent {}
EOF
cat >> lib/features/market/presentation/bloc/oanda/oanda_setup_state.dart << 'EOF'
class OandaTokenExpired extends OandaSetupState {}
EOF
cat >> lib/core/network/oanda_stream_client.dart << 'EOF'

bool _disposed = false;
void startStreaming() {
  _connect();
}

void _connect() async {
  final channel = IOWebSocketChannel.connect(_url);

  channel.stream.listen((msg) {
    _lastReceivedTime = DateTime.now();
    _onMessage(msg);
  }, onError: (e) {
    if (!_disposed) Future.delayed(Duration(seconds: 2), () => _connect());
  }, onDone: () {
    if (!_disposed) Future.delayed(Duration(seconds: 2), () => _connect());
  });

  _startHeartbeatMonitor();
}

void _startHeartbeatMonitor() {
  Timer.periodic(Duration(seconds: 10), (t) {
    if (DateTime.now().difference(_lastReceivedTime).inSeconds > 30) {
      // reconnect
      _connect();
    }
  });
}

void dispose() {
  _disposed = true;
}
EOF
cat > lib/features/market/data/tick_aggregator.dart << 'EOF'
import '../../../market/domain/entities/candle.dart';
import '../../../market/domain/entities/tick.dart';

class CandleAggregator {
  final Duration interval;
  final List<CandleEntity> result = [];
  DateTime? currentStart;
  CandleEntity? current;

  List<Tick> buffer = [];

  CandleAggregator(this.interval);

  void processTick(Tick tick) {
    buffer.add(tick);
    buffer.sort((a, b) => a.time.compareTo(b.time));

    final start = _alignToInterval(buffer.first.time);

    if (currentStart == null) {
      currentStart = start;
      current = CandleEntity(
        time: start,
        open: buffer.first.price,
        high: buffer.first.price,
        low: buffer.first.price,
        close: buffer.first.price,
        volume: 0,
      );
    }

    while (buffer.isNotEmpty) {
      final t = buffer.removeAt(0);

      if (t.time.isBefore(currentStart!.add(interval))) {
        current!.high = max(current!.high, t.price);
        current!.low = min(current!.low, t.price);
        current!.close = t.price;
        current!.volume += 1;
      } else {
        result.add(current!);
        currentStart = _alignToInterval(t.time);
        current = CandleEntity(
          time: currentStart!,
          open: t.price,
          high: t.price,
          low: t.price,
          close: t.price,
          volume: 1,
        );
      }
    }
  }

  DateTime _alignToInterval(DateTime t) {
    final millis = t.millisecondsSinceEpoch;
    final intInterval = interval.inMilliseconds;
    final startMillis = (millis ~/ intInterval) * intInterval;
    return DateTime.fromMillisecondsSinceEpoch(startMillis);
  }
}
EOF
cat >> lib/core/network/rate_limit_interceptor.dart << 'EOF'
import 'package:dio/dio.dart';

class RateLimitInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 429) {
      final retryAfter = int.tryParse(err.response?.headers.value('retry-after') ?? '1') ?? 1;
      Future.delayed(Duration(seconds: retryAfter), () {
        handler.next(err);
      });
      return;
    }
    handler.next(err);
  }
}
EOF
cat > lib/features/market/data/candle_normalizer.dart << 'EOF'
import '../../../market/domain/entities/candle.dart';

class CandleNormalizer {
  static List<CandleEntity> fillGaps(List<CandleEntity> input, Duration interval) {
    if (input.isEmpty) return [];
    List<CandleEntity> output = [];
    DateTime curr = input.first.time;

    final end = input.last.time;

    int idx = 0;
    while (curr.isBefore(end)) {
      if (idx < input.length && input[idx].time == curr) {
        output.add(input[idx]);
        idx++;
      } else {
        final prev = output.isNotEmpty ? output.last.close : 0;
        output.add(CandleEntity(
          time: curr,
          open: prev,
          high: prev,
          low: prev,
          close: prev,
          volume: 0,
        ));
      }
      curr = curr.add(interval);
    }
    return output;
  }
}
EOF
cat > lib/core/network/error_utils.dart << 'EOF'
import 'package:dio/dio.dart';

enum OandaErrorType { network, client, server, rateLimit, unknown }

OandaErrorType classifyError(DioError e) {
  if (e.type == DioErrorType.connectTimeout || e.type == DioErrorType.receiveTimeout) {
    return OandaErrorType.network;
  }
  final status = e.response?.statusCode ?? 0;
  if (status >= 400 && status < 500) return OandaErrorType.client;
  if (status == 429) return OandaErrorType.rateLimit;
  if (status >= 500) return OandaErrorType.server;
  return OandaErrorType.unknown;
}
EOF
cat > lib/features/market/domain/backtest/backtest_models.dart << 'EOF'
enum OrderSide { buy, sell }

class BacktestOrder {
  final OrderSide side;
  final DateTime time;
  final double price;
  final double size;

  BacktestOrder({
    required this.side,
    required this.time,
    required this.price,
    required this.size,
  });
}

class Position {
  final OrderSide side;
  final DateTime entryTime;
  final double entryPrice;
  final double size;
  double exitPrice;
  DateTime? exitTime;

  Position({
    required this.side,
    required this.entryTime,
    required this.entryPrice,
    required this.size,
    this.exitPrice = 0.0,
    this.exitTime,
  });

  double get profit => (exitPrice - entryPrice) * (side == OrderSide.buy ? 1 : -1) * size;
}
EOF
cat > lib/features/market/domain/backtest/backtest_result.dart << 'EOF'
class BacktestResult {
  final List<double> equityCurve;
  final List<Position> positions;
  final int totalTrades;
  final double netProfit;
  final double winRate;
  final double maxDrawdown;

  BacktestResult({
    required this.equityCurve,
    required this.positions,
    required this.totalTrades,
    required this.netProfit,
    required this.winRate,
    required this.maxDrawdown,
  });
}
EOF
cat > lib/features/market/domain/backtest/backtest_engine.dart << 'EOF'
import 'package:meta/meta.dart';
import '../../../market/domain/entities/candle.dart';
import '../../domain/strategy/strategy_manager.dart';
import 'backtest_models.dart';
import 'backtest_result.dart';

class BacktestEngine {
  final List<CandleEntity> history;
  final StrategyManager strategy;
  final double initialCapital;

  BacktestEngine({
    required this.history,
    required this.strategy,
    this.initialCapital = 10000,
  });

  BacktestResult run() {
    double equity = initialCapital;
    List<double> equityCurve = [];
    List<Position> openPositions = [];
    List<Position> closedPositions = [];

    for (int i = 1; i < history.length; i++) {
      final candle = history[i];

      // Update indicators incrementally
      strategy.updateWithCandle(candle, i);

      // Check signal
      final signal = strategy.checkSignal();

      // Entry logic
      if (signal == Signal.BUY) {
        openPositions.add(Position(
          side: OrderSide.buy,
          entryTime: candle.time,
          entryPrice: candle.close,
          size: 1.0,
        ));
      }

      // Exit logic (SELL)
      if (signal == Signal.SELL && openPositions.isNotEmpty) {
        Position pos = openPositions.removeLast();
        pos.exitPrice = candle.close;
        pos.exitTime = candle.time;
        closedPositions.add(pos);
        equity += pos.profit;
      }

      equityCurve.add(equity);
    }

    final totalTrades = closedPositions.length;
    final wins = closedPositions.where((p) => p.profit > 0).length;
    final winRate = totalTrades > 0 ? wins / totalTrades : 0.0;
    final netProfit = equity - initialCapital;

    double peak = equityCurve.first;
    double maxDrawdown = 0;
    for (var val in equityCurve) {
      if (val > peak) peak = val;
      final dd = (peak - val) / peak;
      if (dd > maxDrawdown) maxDrawdown = dd;
    }

    return BacktestResult(
      equityCurve: equityCurve,
      positions: closedPositions,
      totalTrades: totalTrades,
      netProfit: netProfit,
      winRate: winRate,
      maxDrawdown: maxDrawdown,
    );
  }
}
EOF
cat > lib/core/bloc/app_bloc_observer.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('[BlocEvent] ${bloc.runtimeType} $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('[BlocChange] ${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('[BlocError] ${bloc.runtimeType} $error');
  }
}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_state.dart << 'EOF'
abstract class ChartState {}

class ChartInitial extends ChartState {}

class ChartLoading extends ChartState {}

class ChartLoaded extends ChartState {
  final List candles;
  final XAxisRange visibleRange;
  final Map<String, dynamic>? indicators;

  ChartLoaded({
    required this.candles,
    required this.visibleRange,
    this.indicators,
  });
}

class ChartUpdating extends ChartState {
  final ChartLoaded previous;
  ChartUpdating(this.previous);
}

class ChartError extends ChartState {
  final String error;
  ChartError(this.error);
}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_event.dart << 'EOF'
abstract class ChartEvent {}

class LoadChart extends ChartEvent {
  final String symbol;
  final String timeframe;
  LoadChart({required this.symbol, required this.timeframe});
}

class UpdateVisibleRange extends ChartEvent {
  final DateTime min, max;
  UpdateVisibleRange({required this.min, required this.max});
}

class RefreshChart extends ChartEvent {}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chart_event.dart';
import 'chart_state.dart';
import '../../../../market/data/repositories/market_repository.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final MarketRepository repository;

  ChartBloc(this.repository) : super(ChartInitial()) {
    on<LoadChart>(_onLoad);
    on<UpdateVisibleRange>(_onUpdateRange);
    on<RefreshChart>(_onRefresh);
  }

  void _onLoad(LoadChart event, Emitter<ChartState> emit) async {
    emit(ChartLoading());
    try {
      final data = await repository.getHistoricalCandles(
          symbol: event.symbol, timeframe: event.timeframe);
      emit(ChartLoaded(
          candles: data,
          visibleRange: XAxisRange(min: data.first.time, max: data.last.time)));
    } catch (e) {
      emit(ChartError(e.toString()));
    }
  }

  void _onUpdateRange(UpdateVisibleRange event, Emitter<ChartState> emit) {
    if (state is ChartLoaded) {
      final prev = state as ChartLoaded;
      emit(ChartLoaded(
          candles: prev.candles,
          visibleRange:
              XAxisRange(min: event.min, max: event.max),
          indicators: prev.indicators));
    }
  }

  void _onRefresh(RefreshChart event, Emitter<ChartState> emit) {
    if (state is ChartLoaded) {
      final prev = state as ChartLoaded;
      add(LoadChart(
          symbol: prev.candles.first.instrument,
          timeframe: prev.visibleRange.toString()));
    }
  }
}
EOF
cat > lib/features/market/presentation/bloc/trading/trading_state.dart << 'EOF'
abstract class TradingState {}

class TradingInitial extends TradingState {}

class TradingLoading extends TradingState {}

class TradingSuccess extends TradingState {
  final List openPositions;
  TradingSuccess(this.openPositions);
}

class TradingFailure extends TradingState {
  final String message;
  TradingFailure(this.message);
}
EOF
cat > lib/features/market/presentation/bloc/trading/trading_event.dart << 'EOF'
abstract class TradingEvent {}

class PlaceOrder extends TradingEvent {
  final OrderRequest request;
  PlaceOrder(this.request);
}

class ClosePosition extends TradingEvent {
  final String instrument;
  ClosePosition(this.instrument);
}

class RefreshPositions extends TradingEvent {}
EOF
cat > lib/features/market/presentation/bloc/trading/trading_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'trading_event.dart';
import 'trading_state.dart';
import '../../../../market/data/repositories/trading_repository.dart';

class TradingBloc extends Bloc<TradingEvent, TradingState> {
  final TradingRepository repository;

  TradingBloc(this.repository) : super(TradingInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<ClosePosition>(_onClosePosition);
    on<RefreshPositions>(_onRefreshPositions);
  }

  void _onPlaceOrder(PlaceOrder event, Emitter<TradingState> emit) async {
    emit(TradingLoading());
    try {
      final result = await repository.placeOrder(event.request);
      emit(TradingSuccess(result.openPositions));
    } catch (e) {
      emit(TradingFailure(e.toString()));
    }
  }

  void _onClosePosition(ClosePosition event, Emitter<TradingState> emit) async {
    emit(TradingLoading());
    try {
      final result = await repository.closePosition(event.instrument);
      emit(TradingSuccess(result.openPositions));
    } catch (e) {
      emit(TradingFailure(e.toString()));
    }
  }

  void _onRefreshPositions(RefreshPositions event, Emitter<TradingState> emit) async {
    emit(TradingLoading());
    try {
      final result = await repository.getOpenPositions();
      emit(TradingSuccess(result.openPositions));
    } catch (e) {
      emit(TradingFailure(e.toString()));
    }
  }
}
EOF
cat > lib/features/market/presentation/bloc/backtest/backtest_state.dart << 'EOF'
abstract class BacktestState {}

class BacktestInitial extends BacktestState {}

class BacktestRunning extends BacktestState {}

class BacktestSuccess extends BacktestState {
  final BacktestResult result;
  BacktestSuccess(this.result);
}

class BacktestError extends BacktestState {
  final String message;
  BacktestError(this.message);
}
EOF
cat > lib/features/market/presentation/bloc/backtest/backtest_event.dart << 'EOF'
abstract class BacktestEvent {}

class RunBacktest extends BacktestEvent {
  final List<CandleEntity> history;
  final StrategyManager strategy;

  RunBacktest({required this.history, required this.strategy});
}
EOF
cat > lib/features/market/presentation/bloc/backtest/backtest_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'backtest_event.dart';
import 'backtest_state.dart';
import '../../../../market/domain/backtest/backtest_engine.dart';

class BacktestBloc extends Bloc<BacktestEvent, BacktestState> {
  BacktestBloc() : super(BacktestInitial()) {
    on<RunBacktest>(_onRun);
  }

  void _onRun(RunBacktest event, Emitter<BacktestState> emit) async {
    emit(BacktestRunning());
    try {
      final result = BacktestEngine(
        history: event.history,
        strategy: event.strategy,
      ).run();
      emit(BacktestSuccess(result));
    } catch (e) {
      emit(BacktestError(e.toString()));
    }
  }
}
EOF
cat > lib/core/storage/theme/theme_hive.dart << 'EOF'
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'theme_hive.g.dart';

@HiveType(typeId: 1)
class ThemeEntity extends HiveObject {
  @HiveField(0)
  final bool isDark;

  @HiveField(1)
  final int bullCandleValue;

  @HiveField(2)
  final int bearCandleValue;

  ThemeEntity({
    required this.isDark,
    required this.bullCandleValue,
    required this.bearCandleValue,
  });

  ThemeData toThemeData() {
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: Color(bullCandleValue),
      accentColor: Color(bearCandleValue),
    );
  }
}
EOF
cat > lib/core/storage/theme/theme_storage.dart << 'EOF'
import 'package:hive/hive.dart';
import 'theme_hive.dart';

class ThemeStorage {
  static const _boxName = "theme_box";

  Future<void> saveTheme(ThemeEntity theme) async {
    final box = await Hive.openBox<ThemeEntity>(_boxName);
    await box.put('current', theme);
  }

  Future<ThemeEntity?> loadTheme() async {
    final box = await Hive.openBox<ThemeEntity>(_boxName);
    return box.get('current');
  }
}
EOF
cat > lib/core/storage/script/script_hive.dart << 'EOF'
import 'package:hive/hive.dart';

part 'script_hive.g.dart';

@HiveType(typeId: 2)
class ScriptEntity extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String script;

  ScriptEntity({required this.name, required this.script});
}
EOF
cat > lib/core/storage/script/script_storage.dart << 'EOF'
import 'package:hive/hive.dart';
import 'script_hive.dart';

class ScriptStorage {
  static const _boxName = "scripts_box";

  Future<void> saveScript(ScriptEntity script) async {
    final box = await Hive.openBox<ScriptEntity>(_boxName);
    await box.put(script.name, script);
  }

  Future<ScriptEntity?> loadScript(String name) async {
    final box = await Hive.openBox<ScriptEntity>(_boxName);
    return box.get(name);
  }

  Future<List<ScriptEntity>> getAllScripts() async {
    final box = await Hive.openBox<ScriptEntity>(_boxName);
    return box.values.toList();
  }
}
EOF
cat > lib/core/storage/audit/audit_hive.dart << 'EOF'
import 'package:hive/hive.dart';

part 'audit_hive.g.dart';

@HiveType(typeId: 3)
class AuditEntity extends HiveObject {
  @HiveField(0)
  final DateTime time;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String details;

  AuditEntity({required this.time, required this.type, required this.details});
}
EOF
cat > lib/core/storage/audit/audit_storage.dart << 'EOF'
import 'package:hive/hive.dart';
import 'audit_hive.dart';

class AuditStorage {
  static const _boxName = "audit_box";

  Future<void> logEvent(AuditEntity event) async {
    final box = await Hive.openBox<AuditEntity>(_boxName);
    await box.add(event);
  }

  Future<List<AuditEntity>> getAllEvents() async {
    final box = await Hive.openBox<AuditEntity>(_boxName);
    return box.values.toList();
  }

  Future<void> clear() async {
    final box = await Hive.openBox<AuditEntity>(_boxName);
    await box.clear();
  }
}
EOF
cat > lib/core/storage/indicator/indicator_hive.dart << 'EOF'
import 'package:hive/hive.dart';

part 'indicator_hive.g.dart';

@HiveType(typeId: 4)
class IndicatorSettingsEntity extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final Map<String, dynamic> params;

  IndicatorSettingsEntity({required this.id, required this.params});
}
EOF
cat > lib/core/storage/indicator/indicator_storage.dart << 'EOF'
import 'package:hive/hive.dart';
import 'indicator_hive.dart';

class IndicatorStorage {
  static const _boxName = "indicator_box";

  Future<void> saveSettings(IndicatorSettingsEntity e) async {
    final box = await Hive.openBox<IndicatorSettingsEntity>(_boxName);
    await box.put(e.id, e);
  }

  Future<IndicatorSettingsEntity?> loadSettings(String id) async {
    final box = await Hive.openBox<IndicatorSettingsEntity>(_boxName);
    return box.get(id);
  }

  Future<List<IndicatorSettingsEntity>> getAllSettings() async {
    final box = await Hive.openBox<IndicatorSettingsEntity>(_boxName);
    return box.values.toList();
  }
}
EOF
cat > lib/core/storage/oanda/secure_storage.dart << 'EOF'
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OandaSecureStorage {
  final _storage = FlutterSecureStorage();

  static const _tokenKey = "oanda_token";
  static const _accountIdKey = "oanda_account";

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> loadToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> saveAccountId(String id) async {
    await _storage.write(key: _accountIdKey, value: id);
  }

  Future<String?> loadAccountId() async {
    return await _storage.read(key: _accountIdKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
EOF
cat > lib/core/storage/replay_storage.dart << 'EOF'
import 'package:hive/hive.dart';

part 'replay_storage.g.dart';

@HiveType(typeId: 5)
class ReplayStateEntity extends HiveObject {
  @HiveField(0)
  final String symbol;
  @HiveField(1)
  final String timeframe;
  @HiveField(2)
  final int lastIndex;

  ReplayStateEntity({
    required this.symbol,
    required this.timeframe,
    required this.lastIndex,
  });
}
EOF
cat > test/domain/indicators/ema_calculator_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/indicators/ema_calculator.dart';
import 'package:your_app/market/domain/entities/candle.dart';

void main() {
  test('EMA returns correct length and values', () {
    final data = List.generate(10, (i) => CandleEntity(
      time: DateTime.now().add(Duration(minutes: i)),
      open: i.toDouble(),
      high: i.toDouble() + 1,
      low: i.toDouble() - 1,
      close: i.toDouble(),
      volume: 1,
    ));

    final ema = EMACalculator.calculate(data, 5).values;

    expect(ema.length, 10);
    expect(ema.skip(4).first,
      greaterThan(ema.skip(3).first));
  });
}
EOF
cat > test/domain/indicators/rsi_calculator_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/indicators/rsi_calculator.dart';
import 'package:your_app/market/domain/entities/candle.dart';

void main() {
  test('RSI simple test', () {
    final data = List.generate(20, (i) => CandleEntity(
      time: DateTime.now().add(Duration(minutes: i)),
      open: i.toDouble(),
      high: i.toDouble(),
      low: i.toDouble(),
      close: i.toDouble() + 1,
      volume: 1,
    ));

    final rsi = RSICalculator.calculate(data, 14).values;
    expect(rsi.length, greaterThan(0));
    expect(rsi.first, isNonNegative);
  });
}
EOF
cat > test/domain/backtest/backtest_engine_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/backtest/backtest_engine.dart';
import 'package:your_app/market/domain/entities/candle.dart';

void main() {
  test('Backtest should return correct stats', () {
    final history = List.generate(30, (i) => CandleEntity(
      time: DateTime.now().add(Duration(minutes: i)),
      open: i.toDouble(),
      high: i.toDouble() + 1,
      low: i.toDouble() - 1,
      close: i.isEven ? i.toDouble() + 1 : i.toDouble() - 1,
      volume: 1,
    ));

    final engine = BacktestEngine(history: history, strategy: /* your test strategy */);
    final result = engine.run();

    expect(result.equityCurve.first, 10000);
    expect(result.totalTrades, isNonNegative);
  });
}
EOF
cat > test/bloc/chart_bloc_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_event.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_state.dart';
import 'package:your_app/market/data/repositories/market_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockMarketRepo extends Mock implements MarketRepository {}

void main() {
  group('ChartBloc', () {
    late ChartBloc bloc;
    late MockMarketRepo repo;

    setUp(() {
      repo = MockMarketRepo();
      bloc = ChartBloc(repo);
    });

    blocTest<ChartBloc, ChartState>(
      'emits ChartLoaded on successful LoadChart',
      build: () {
        when(() => repo.getHistoricalCandles(symbol: any(named: 'symbol'),
            timeframe: any(named: 'timeframe')))
            .thenAnswer((_) async => []);
        return bloc;
      },
      act: (b) => b.add(LoadChart(symbol: 'EU', timeframe: 'M1')),
      expect: () => [isA<ChartLoading>(), isA<ChartLoaded>()],
    );
  });
}
EOF
cat > test/widgets/strategy_builder_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/strategy_builder/presentation/pages/strategy_builder_page.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Strategy builder shows nodes list', (tester) async {
    await tester.pumpWidget(MaterialApp(home: StrategyBuilderPage()));
    expect(find.text('Price Above'), findsOneWidget);
    expect(find.text('EMA Cross Up'), findsOneWidget);
  });
}
EOF
cat > test/domain/candle_normalizer_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/data/candle_normalizer.dart';
import 'package:your_app/market/domain/entities/candle.dart';

void main() {
  test('fillGaps should produce continuous candles', () {
    final input = [
      CandleEntity(time: DateTime(2025,1,1,10,0), open:1,high:1,low:1,close:1,volume:1),
      CandleEntity(time: DateTime(2025,1,1,10,2), open:2,high:2,low:2,close:2,volume:1),
    ];
    final output = CandleNormalizer.fillGaps(input, Duration(minutes:1));
    expect(output.length, 3);
    expect(output[1].volume, 0);
  });
}
EOF
cat > lib/core/models/candle_entity.dart << 'EOF'
class CandleEntity {
  final String instrument;   // e.g. "XAU_USD"
  final DateTime timeUtc;    // UTC time
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  CandleEntity({
    required this.instrument,
    required this.timeUtc,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory CandleEntity.fromJson(String instrument, Map<String, dynamic> json) {
    return CandleEntity(
      instrument: instrument,
      // convert to UTC
      timeUtc: DateTime.parse(json['time']).toUtc(),
      open: double.parse(json['open']),
      high: double.parse(json['high']),
      low: double.parse(json['low']),
      close: double.parse(json['close']),
      volume: double.parse(json['volume']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "time": timeUtc.toIso8601String(),
      "open": open.toString(),
      "high": high.toString(),
      "low": low.toString(),
      "close": close.toString(),
      "volume": volume.toString(),
    };
  }
}
EOF
cat > lib/core/models/tick_entity.dart << 'EOF'
class TickEntity {
  final String instrument;
  final DateTime timeUtc;
  final double bid;
  final double ask;

  TickEntity({
    required this.instrument,
    required this.timeUtc,
    required this.bid,
    required this.ask,
  });

  factory TickEntity.fromJson(String instrument, Map<String, dynamic> json) {
    return TickEntity(
      instrument: instrument,
      timeUtc: DateTime.parse(json['time']).toUtc(),
      bid: double.parse(json['bid']),
      ask: double.parse(json['ask']),
    );
  }

  double get mid => (bid + ask) / 2;
}
EOF
cat > test/models/candle_entity_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  test('CandleEntity UTC conversion & fields', () {
    final json = {
      "time": "2025-01-01T10:00:00Z",
      "open": "100",
      "high": "110",
      "low": "90",
      "close": "105",
      "volume": "1000"
    };

    final candle = CandleEntity.fromJson("EUR_USD", json);

    expect(candle.instrument, "EUR_USD");
    expect(candle.timeUtc.isUtc, true);
    expect(candle.open, 100.0);
    expect(candle.high, 110.0);
    expect(candle.close, 105.0);
  });
}
EOF
cat > lib/features/strategy/domain/indicators/indicator.dart << 'EOF'
import '../../../core/models/candle_entity.dart';

abstract class Indicator<T> {
  /// تحديث المؤشر مع كل شمعة جديدة
  void addCandle(CandleEntity candle);

  /// الحصول على آخر قيمة حالية
  T get current;

  /// السلسلة التاريخية (اختياري)
  List<T> get series;
}
EOF
cat > lib/features/strategy/domain/indicators/ema.dart << 'EOF'
import '../../../core/models/candle_entity.dart';
import 'indicator.dart';
import 'dart:math';

class EMAIndicator implements Indicator<double> {
  final int period;
  double? _prevEma;
  final List<double> _series = [];

  EMAIndicator(this.period);

  double get _multiplier => 2.0 / (period + 1);

  @override
  void addCandle(CandleEntity candle) {
    final price = candle.close;

    if (_prevEma == null) {
      _prevEma = price; // أول قيمة
    } else {
      _prevEma = (price - _prevEma!) * _multiplier + _prevEma!;
    }

    _series.add(_prevEma!);
  }

  @override
  double get current => _prevEma ?? 0.0;

  @override
  List<double> get series => List.unmodifiable(_series);
}
EOF
cat > lib/features/strategy/domain/ast/expr_node.dart << 'EOF'
import '../../../core/models/candle_entity.dart';

abstract class ExprNode {
  /// تقييم العقدة عند شمعة معينة
  bool evaluate(CandleEntity candle, int index);
}
EOF
cat > lib/features/strategy/domain/ast/greater_than_node.dart << 'EOF'
import 'expr_node.dart';
import '../indicators/indicator.dart';
import '../../../core/models/candle_entity.dart';

class GreaterThanNode extends ExprNode {
  final Indicator<double> left;
  final Indicator<double> right;

  GreaterThanNode(this.left, this.right);

  @override
  bool evaluate(CandleEntity candle, int index) {
    return left.current > right.current;
  }
}
EOF
cat > lib/features/strategy/domain/ast/and_node.dart << 'EOF'
import 'expr_node.dart';
import '../../../core/models/candle_entity.dart';

class AndNode extends ExprNode {
  final ExprNode a;
  final ExprNode b;

  AndNode(this.a, this.b);

  @override
  bool evaluate(CandleEntity candle, int index) {
    return a.evaluate(candle, index) && b.evaluate(candle, index);
  }
}
EOF
cat > lib/features/strategy/domain/ast/cross_up_node.dart << 'EOF'
import 'expr_node.dart';
import '../indicators/indicator.dart';
import '../../../core/models/candle_entity.dart';

class CrossUpNode extends ExprNode {
  final Indicator<double> fast;
  final Indicator<double> slow;
  double? _prevFast;
  double? _prevSlow;

  CrossUpNode(this.fast, this.slow);

  @override
  bool evaluate(CandleEntity candle, int index) {
    final currFast = fast.current;
    final currSlow = slow.current;

    bool crossed = false;

    if (_prevFast != null && _prevSlow != null) {
      crossed = (_prevFast! <= _prevSlow!) && (currFast > currSlow);
    }

    _prevFast = currFast;
    _prevSlow = currSlow;

    return crossed;
  }
}
EOF
cat > lib/features/strategy/domain/evaluator/sequential_evaluator.dart << 'EOF'
import '../../../core/models/candle_entity.dart';
import '../ast/expr_node.dart';
import '../indicators/ema.dart';

enum Signal { BUY, SELL, NONE }

class SequentialEvaluator {
  final EMAIndicator emaFast;
  final EMAIndicator emaSlow;
  final ExprNode root;

  SequentialEvaluator({
    required this.emaFast,
    required this.emaSlow,
    required this.root,
  });

  /// تقييم الاستراتيجية عبر كل الشموع
  List<Signal> evaluateSeries(List<CandleEntity> history) {
    List<Signal> signals = [];

    for (int i = 0; i < history.length; i++) {
      final candle = history[i];

      // تحديث المؤشرات أولًا
      emaFast.addCandle(candle);
      emaSlow.addCandle(candle);

      // تقييم AST
      bool condition = root.evaluate(candle, i);

      if (condition) {
        signals.add(Signal.BUY);
      } else {
        signals.add(Signal.NONE);
      }
    }

    return signals;
  }
}
EOF
cat > lib/features/strategy/domain/evaluator/example_strategy.dart << 'EOF'
import '../indicators/ema.dart';
import '../ast/greater_than_node.dart';
import '../ast/and_node.dart';
import '../ast/cross_up_node.dart';
import 'sequential_evaluator.dart';

SequentialEvaluator buildExampleStrategy() {
  final ema10 = EMAIndicator(10);
  final ema20 = EMAIndicator(20);

  final greater = GreaterThanNode(ema10, ema20);
  final cross = CrossUpNode(ema10, ema20);

  final root = AndNode(greater, cross);

  return SequentialEvaluator(
    emaFast: ema10,
    emaSlow: ema20,
    root: root,
  );
}
EOF
cat > test/strategy/sequential_evaluator_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/strategy/domain/evaluator/example_strategy.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  test('SequentialEvaluator produces signals', () {
    final history = List.generate(30, (i) => CandleEntity(
      instrument: "EUR_USD",
      timeUtc: DateTime.utc(2025,1,1,0,i),
      open: i.toDouble(),
      high: i.toDouble() + 1,
      low: i.toDouble() - 1,
      close: i.toDouble(),
      volume: 1,
    ));

    final evaluator = buildExampleStrategy();
    final signals = evaluator.evaluateSeries(history);

    expect(signals.length, history.length);
  });
}
EOF
cat > lib/core/network/ws_manager.dart << 'EOF'
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WSManager {
  final String url;
  WebSocketChannel? _channel;
  StreamController<String> _streamController = StreamController.broadcast();
  Timer? _reconnectTimer;
  Timer? _pingTimer;

  WSManager(this.url);

  Stream<String> get stream => _streamController.stream;

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.stream.listen(
      (event) {
        _streamController.add(event);
      },
      onDone: _handleDisconnect,
      onError: (err) {
        print('WebSocket error: $err');
        _handleDisconnect();
      },
      cancelOnError: true,
    );

    _startPing();
  }

  void _handleDisconnect() {
    _stopPing();
    _reconnectTimer = Timer(Duration(seconds: 3), () {
      connect();
    });
  }

  void _startPing() {
    _pingTimer = Timer.periodic(Duration(seconds: 15), (_) {
      _channel?.sink.add('ping');
    });
  }

  void _stopPing() {
    _pingTimer?.cancel();
  }

  void send(String msg) {
    _channel?.sink.add(msg);
  }

  void dispose() {
    _stopPing();
    _reconnectTimer?.cancel();
    _channel?.sink.close(status.goingAway);
  }
}
EOF
cat > lib/features/market/data/streaming/tick_aggregator.dart << 'EOF'
import 'dart:collection';
import '../../../core/models/tick_entity.dart';
import '../../../core/models/candle_entity.dart';

class TickAggregator {
  final Duration interval;
  final String instrument;
  final SplayTreeMap<DateTime, List<TickEntity>> _buckets = SplayTreeMap();

  TickAggregator(this.instrument, this.interval);

  void addTick(TickEntity tick) {
    final alignedTime = _align(tick.timeUtc);
    _buckets.putIfAbsent(alignedTime, () => []).add(tick);
  }

  DateTime _align(DateTime time) {
    final seconds = time.second;
    final aligned = DateTime.utc(time.year, time.month, time.day, time.hour,
        time.minute, (seconds ~/ interval.inSeconds) * interval.inSeconds);
    return aligned;
  }

  List<CandleEntity> buildCandles() {
    List<CandleEntity> candles = [];

    for (final entry in _buckets.entries) {
      final ticks = entry.value;
      final open = ticks.first.bid;
      final close = ticks.last.bid;
      final high = ticks.map((e) => e.bid).reduce((a, b) => a > b ? a : b);
      final low = ticks.map((e) => e.bid).reduce((a, b) => a < b ? a : b);

      candles.add(CandleEntity(
        instrument: instrument,
        timeUtc: entry.key,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: ticks.length.toDouble(),
      ));
    }

    _buckets.clear();
    return candles;
  }
}
EOF
cat > lib/core/network/rest_client.dart << 'EOF'
import 'dart:convert';
import 'package:http/http.dart' as http;

class RestClient {
  final String token;
  final String baseUrl;

  RestClient(this.token, this.baseUrl);

  Future<http.Response> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    for (int attempt = 0; attempt < 3; attempt++) {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 429) {
        final retryAfter = response.headers['retry-after'];
        final wait = int.tryParse(retryAfter ?? '2') ?? 2;
        await Future.delayed(Duration(seconds: wait));
      } else if (response.statusCode == 401) {
        // Handle token refresh logic here
        throw Exception('Token expired');
      } else {
        return response;
      }
    }

    throw Exception('Too many requests, even after retrying.');
  }
}
EOF
cat > test/ws/ws_manager_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/core/network/ws_manager.dart';

void main() {
  test('WSManager initializes and reconnects', () async {
    final ws = WSManager('wss://echo.websocket.events');
    ws.connect();

    await Future.delayed(Duration(seconds: 2));
    ws.send('ping');

    await ws.stream.first;

    ws.dispose();
  });
}
EOF
cat > lib/features/strategy/domain/indicators/indicator.dart << 'EOF'
import '../../../core/models/candle_entity.dart';

abstract class Indicator<T> {
  void addCandle(CandleEntity candle); // تحديث بالقيمة الجديدة
  T get current;                        // آخر قيمة
  List<T> get series;                  // السلسلة التاريخية (اختياري)
}
EOF
cat > lib/features/strategy/domain/indicators/ema_indicator.dart << 'EOF'
import 'indicator.dart';
import '../../../core/models/candle_entity.dart';

class EMAIndicator implements Indicator<double> {
  final int period;
  double? _ema;
  final List<double> _series = [];

  EMAIndicator(this.period);

  double get _multiplier => 2.0 / (period + 1);

  @override
  void addCandle(CandleEntity candle) {
    final price = candle.close;

    _ema = _ema == null ? price : (price - _ema!) * _multiplier + _ema!;
    _series.add(_ema!);
  }

  @override
  double get current => _ema ?? 0;

  @override
  List<double> get series => List.unmodifiable(_series);
}
EOF
cat > lib/features/strategy/domain/indicators/rsi_indicator.dart << 'EOF'
import 'indicator.dart';
import '../../../core/models/candle_entity.dart';

class RSIIndicator implements Indicator<double> {
  final int period;
  final List<CandleEntity> _history = [];
  final List<double> _series = [];
  double? _avgGain;
  double? _avgLoss;

  RSIIndicator(this.period);

  @override
  void addCandle(CandleEntity candle) {
    if (_history.isNotEmpty) {
      final prev = _history.last;
      final change = candle.close - prev.close;
      final gain = change > 0 ? change : 0;
      final loss = change < 0 ? -change : 0;

      if (_avgGain == null) {
        _avgGain = gain;
        _avgLoss = loss;
      } else {
        _avgGain = (_avgGain! * (period - 1) + gain) / period;
        _avgLoss = (_avgLoss! * (period - 1) + loss) / period;
      }

      if (_avgLoss == 0) {
        _series.add(100.0);
      } else {
        final rs = _avgGain! / _avgLoss!;
        _series.add(100 - (100 / (1 + rs)));
      }
    }

    _history.add(candle);
  }

  @override
  double get current => _series.isEmpty ? 0 : _series.last;

  @override
  List<double> get series => List.unmodifiable(_series);
}
EOF
cat > lib/features/strategy/domain/indicators/bollinger_indicator.dart << 'EOF'
import 'indicator.dart';
import '../../../core/models/candle_entity.dart';
import 'dart:math';

class BollingerBand {
  final double upper;
  final double middle;
  final double lower;

  BollingerBand(this.upper, this.middle, this.lower);
}

class BollingerIndicator implements Indicator<BollingerBand> {
  final int period;
  final List<double> _closes = [];
  final List<BollingerBand> _series = [];

  BollingerIndicator(this.period);

  @override
  void addCandle(CandleEntity candle) {
    _closes.add(candle.close);
    if (_closes.length > period) _closes.removeAt(0);

    if (_closes.length == period) {
      final mean = _closes.reduce((a, b) => a + b) / period;
      final std = sqrt(_closes.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) / period);
      final upper = mean + 2 * std;
      final lower = mean - 2 * std;
      _series.add(BollingerBand(upper, mean, lower));
    }
  }

  @override
  BollingerBand get current => _series.isEmpty ? BollingerBand(0,0,0) : _series.last;

  @override
  List<BollingerBand> get series => List.unmodifiable(_series);
}
EOF
cat > test/indicators/ema_rsi_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/strategy/domain/indicators/ema_indicator.dart';
import 'package:your_app/features/strategy/domain/indicators/rsi_indicator.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  final candles = List.generate(20, (i) => CandleEntity(
    instrument: "XAU_USD",
    timeUtc: DateTime.utc(2025,1,1,0,i),
    open: i.toDouble(),
    high: i.toDouble(),
    low: i.toDouble(),
    close: i.toDouble(),
    volume: 1,
  ));

  test('EMA calculates correctly', () {
    final ema = EMAIndicator(10);
    for (final c in candles) ema.addCandle(c);
    expect(ema.series.length, candles.length);
    expect(ema.current, greaterThan(0));
  });

  test('RSI calculates correctly', () {
    final rsi = RSIIndicator(14);
    for (final c in candles) rsi.addCandle(c);
    expect(rsi.series.length, greaterThan(1));
    expect(rsi.current, inInclusiveRange(0, 100));
  });
}
EOF
cat > lib/features/market/domain/backtest/backtest_models.dart << 'EOF'
enum OrderSide { buy, sell }

class Order {
  final OrderSide side;
  final DateTime time;
  final double price;
  final double size;

  Order({
    required this.side,
    required this.time,
    required this.price,
    required this.size,
  });
}

class Position {
  final OrderSide side;
  final DateTime entryTime;
  final double entryPrice;
  final double size;
  DateTime? exitTime;
  double? exitPrice;

  Position({
    required this.side,
    required this.entryTime,
    required this.entryPrice,
    required this.size,
    this.exitPrice,
    this.exitTime,
  });

  double get profit {
    if (exitPrice == null) return 0.0;
    return (side == OrderSide.buy)
        ? (exitPrice! - entryPrice) * size
        : (entryPrice - exitPrice!) * size;
  }
}
EOF
cat > lib/features/market/domain/backtest/backtest_result.dart << 'EOF'
class BacktestResult {
  final List<double> equityCurve;
  final List<double> balanceCurve;
  final List<dynamic> trades; // يمكن ترقية النوع لاحقًا
  final double netProfit;
  final double winRate;
  final double maxDrawdown;

  BacktestResult({
    required this.equityCurve,
    required this.balanceCurve,
    required this.trades,
    required this.netProfit,
    required this.winRate,
    required this.maxDrawdown,
  });
}
EOF
cat > lib/features/market/domain/backtest/backtest_engine.dart << 'EOF'
import 'package:meta/meta.dart';
import '../../../core/models/candle_entity.dart';
import '../strategy/domain/evaluator/sequential_evaluator.dart';
import 'backtest_models.dart';
import 'backtest_result.dart';

class BacktestEngine {
  final List<CandleEntity> history;
  final SequentialEvaluator evaluator;
  final double initialBalance;
  final double takeProfit; // نسبة الربح (مثال: 0.02 = 2%)
  final double stopLoss;   // نسبة الخسارة (مثال: 0.01 = 1%)

  BacktestEngine({
    required this.history,
    required this.evaluator,
    this.initialBalance = 10000,
    this.takeProfit = 0,
    this.stopLoss = 0,
  });

  BacktestResult run() {
    double balance = initialBalance;
    double equity = initialBalance;
    List<double> equityCurve = [];
    List<double> balanceCurve = [];
    List<dynamic> trades = [];

    Position? currentPosition;

    for (int i = 0; i < history.length; i++) {
      final candle = history[i];

      // --- 1) تحديث المؤشرات وإشارات الاستراتيجية ---
      evaluator.emaFast.addCandle(candle);
      evaluator.emaSlow.addCandle(candle);
      bool signal = evaluator.root.evaluate(candle, i);

      // --- 2) إدارة الصفقات المفتوحة ---
      if (currentPosition != null) {
        final price = candle.close;

        final profit = (currentPosition.side == OrderSide.buy)
            ? (price - currentPosition.entryPrice) * currentPosition.size
            : (currentPosition.entryPrice - price) * currentPosition.size;

        equity = balance + profit;

        // --- تحقق TP/SL إذا كانت > 0 ---
        if (takeProfit > 0 && profit >= currentPosition.entryPrice * takeProfit) {
          currentPosition.exitPrice = price;
          currentPosition.exitTime = candle.timeUtc;
          trades.add(currentPosition);
          balance += profit;
          currentPosition = null;
        } else if (stopLoss > 0 &&
            profit <= -currentPosition.entryPrice * stopLoss) {
          currentPosition.exitPrice = price;
          currentPosition.exitTime = candle.timeUtc;
          trades.add(currentPosition);
          balance += profit;
          currentPosition = null;
        }
      }

      // --- 3) تقييم الدخول/الخروج الجديد إذا لم يكن هناك صفقة حالية ---
      if (currentPosition == null && signal) {
        currentPosition = Position(
          side: OrderSide.buy,
          entryPrice: candle.close,
          entryTime: candle.timeUtc,
          size: 1.0,
        );
      }

      equityCurve.add(equity);
      balanceCurve.add(balance);
    }

    // --- 4) حساب الإحصاءات ---
    final netProfit = equity - initialBalance;
    final closedTrades = trades.where((t) => t.exitPrice != null).toList();
    final wins = closedTrades.where((p) => p.profit > 0).length;
    final totalTrades = closedTrades.length;
    final winRate = totalTrades > 0 ? wins / totalTrades : 0.0;

    double peak = equityCurve.isNotEmpty ? equityCurve.first : initialBalance;
    double maxDrawdown = 0;
    for (var val in equityCurve) {
      if (val > peak) peak = val;
      final dd = (peak - val) / peak;
      if (dd > maxDrawdown) maxDrawdown = dd;
    }

    return BacktestResult(
      equityCurve: equityCurve,
      balanceCurve: balanceCurve,
      trades: trades,
      netProfit: netProfit,
      winRate: winRate,
      maxDrawdown: maxDrawdown,
    );
  }
}
EOF
cat > test/backtest/backtest_engine_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/backtest/backtest_engine.dart';
import 'package:your_app/features/strategy/domain/evaluator/example_strategy.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  test('Backtest basic run', () {
    final history = List.generate(50, (i) => CandleEntity(
      instrument: "EUR_USD",
      timeUtc: DateTime.utc(2025,1,1,0,i),
      open: i.toDouble(),
      high: i.toDouble()+1,
      low: i.toDouble()-1,
      close: i.toDouble(),
      volume: 1,
    ));

    final engine = BacktestEngine(
      history: history,
      evaluator: buildExampleStrategy(),
      initialBalance: 10000,
      takeProfit: 0.01,
      stopLoss: 0.005,
    );

    final result = engine.run();
    expect(result.equityCurve.length, history.length);
    expect(result.netProfit, isA<double>());
    expect(result.winRate, inInclusiveRange(0.0, 1.0));
  });
}
EOF
cat > lib/features/market/presentation/bloc/oanda/oanda_setup_event.dart << 'EOF'
abstract class OandaSetupEvent {}

class SubmitOandaCredentials extends OandaSetupEvent {
  final String token;
  final String accountId;

  SubmitOandaCredentials({
    required this.token,
    required this.accountId,
  });
}

class RetryConnection extends OandaSetupEvent {}

class LogoutOanda extends OandaSetupEvent {}
EOF
cat > lib/features/market/presentation/bloc/oanda/oanda_setup_state.dart << 'EOF'
abstract class OandaSetupState {}

class OandaInitial extends OandaSetupState {}

class OandaLoading extends OandaSetupState {}

class OandaConnected extends OandaSetupState {}

class OandaTokenExpired extends OandaSetupState {}

class OandaError extends OandaSetupState {
  final String message;
  OandaError(this.message);
}

class OandaLoggedOut extends OandaSetupState {}
EOF
cat > lib/features/market/presentation/bloc/oanda/oanda_setup_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'oanda_setup_event.dart';
import 'oanda_setup_state.dart';
import '../../../../core/storage/oanda/secure_storage.dart';
import '../../../../core/network/rest_client.dart';

class OandaSetupBloc extends Bloc<OandaSetupEvent, OandaSetupState> {
  final OandaSecureStorage storage;
  final String baseUrl;

  OandaSetupBloc({
    required this.storage,
    required this.baseUrl,
  }) : super(OandaInitial()) {
    on<SubmitOandaCredentials>(_onSubmit);
    on<RetryConnection>(_onRetry);
    on<LogoutOanda>(_onLogout);
  }

  Future<void> _onSubmit(SubmitOandaCredentials event, Emitter<OandaSetupState> emit) async {
    emit(OandaLoading());

    try {
      // store securely
      await storage.saveToken(event.token);
      await storage.saveAccountId(event.accountId);

      // test connection
      final rest = RestClient(event.token, baseUrl);
      final res = await rest.get('/v3/accounts/${event.accountId}');
      if (res.statusCode == 200) {
        emit(OandaConnected());
      } else if (res.statusCode == 401) {
        emit(OandaTokenExpired());
      } else {
        emit(OandaError('HTTP ${res.statusCode}'));
      }
    } catch (e) {
      emit(OandaError(e.toString()));
    }
  }

  Future<void> _onRetry(RetryConnection event, Emitter<OandaSetupState> emit) async {
    final token = await storage.loadToken();
    final accountId = await storage.loadAccountId();

    if (token == null || accountId == null) {
      return emit(OandaError('No credentials stored'));
    }

    add(SubmitOandaCredentials(token: token, accountId: accountId));
  }

  Future<void> _onLogout(LogoutOanda event, Emitter<OandaSetupState> emit) async {
    await storage.clearAll();
    emit(OandaLoggedOut());
  }
}
EOF
cat > test/bloc/oanda_setup/oanda_setup_bloc_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/market/presentation/bloc/oanda/oanda_setup_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/oanda/oanda_setup_event.dart';
import 'package:your_app/features/market/presentation/bloc/oanda/oanda_setup_state.dart';
import 'package:mocktail/mocktail.dart';
import '../../../mocks.dart';

class MockSecureStorage extends Mock implements OandaSecureStorage {}
class MockRestClient extends Mock implements RestClient {}

void main() {
  group('OandaSetupBloc', () {
    late MockSecureStorage mockStorage;

    setUp(() {
      mockStorage = MockSecureStorage();
    });

    blocTest<OandaSetupBloc, OandaSetupState>(
      'emits Connected when valid credentials',
      build: () {
        return OandaSetupBloc(storage: mockStorage, baseUrl: 'https://fake');
      },
      act: (bloc) => bloc.add(SubmitOandaCredentials(token: 't', accountId: 'id')),
      expect: () => [isA<OandaLoading>(), isA<OandaConnected>()],
    );
  });
}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_event.dart << 'EOF'
abstract class ChartEvent {}

class LoadChartData extends ChartEvent {
  final String symbol;
  final String timeframe;

  LoadChartData({
    required this.symbol,
    required this.timeframe,
  });
}

class UpdateVisibleRange extends ChartEvent {
  final DateTime min;
  final DateTime max;

  UpdateVisibleRange({
    required this.min,
    required this.max,
  });
}

class RefreshChart extends ChartEvent {}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_state.dart << 'EOF'
import '../../../../core/models/candle_entity.dart';

abstract class ChartState {}

class ChartInitial extends ChartState {}

class ChartLoading extends ChartState {}

class ChartLoaded extends ChartState {
  final List<CandleEntity> candles;
  final DateTime visibleMin;
  final DateTime visibleMax;

  ChartLoaded({
    required this.candles,
    required this.visibleMin,
    required this.visibleMax,
  });
}

class ChartUpdating extends ChartState {
  final ChartLoaded previous;

  ChartUpdating(this.previous);
}

class ChartError extends ChartState {
  final String message;

  ChartError(this.message);
}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chart_event.dart';
import 'chart_state.dart';
import '../../../../core/models/candle_entity.dart';
import '../../../../market/data/repositories/market_repository.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final MarketRepository repository;

  ChartBloc(this.repository) : super(ChartInitial()) {
    on<LoadChartData>(_onLoad);
    on<UpdateVisibleRange>(_onUpdateRange);
    on<RefreshChart>(_onRefresh);
  }

  Future<void> _onLoad(LoadChartData event, Emitter<ChartState> emit) async {
    emit(ChartLoading());
    try {
      final candles = await repository.getHistoricalCandles(
        symbol: event.symbol,
        timeframe: event.timeframe,
      );

      if (candles.isEmpty) {
        return emit(ChartError("No candles returned"));
      }

      emit(ChartLoaded(
        candles: candles,
        visibleMin: candles.first.timeUtc,
        visibleMax: candles.last.timeUtc,
      ));
    } catch (e) {
      emit(ChartError(e.toString()));
    }
  }

  void _onUpdateRange(UpdateVisibleRange event, Emitter<ChartState> emit) {
    final stateNow = state;
    if (stateNow is ChartLoaded) {
      emit(ChartLoaded(
        candles: stateNow.candles,
        visibleMin: event.min,
        visibleMax: event.max,
      ));
    }
  }

  void _onRefresh(RefreshChart event, Emitter<ChartState> emit) {
    final stateNow = state;
    if (stateNow is ChartLoaded) {
      add(LoadChartData(
        symbol: stateNow.candles.first.instrument,
        timeframe: (stateNow.visibleMax.difference(stateNow.visibleMin).inMinutes == 1)
            ? "M1"
            : "Unknown",
      ));
    }
  }
}
EOF
cat > test/bloc/chart/chart_bloc_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_event.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_state.dart';
import 'package:your_app/market/data/repositories/market_repository.dart';
import 'package:mocktail/mocktail.dart';
import '../../../mocks.dart';
import '../../../../core/models/candle_entity.dart';

class MockMarketRepo extends Mock implements MarketRepository {}

void main() {
  late MockMarketRepo mockRepo;

  setUp(() {
    mockRepo = MockMarketRepo();
  });

  blocTest<ChartBloc, ChartState>(
    'emits [ChartLoading, ChartLoaded] when candles returned',
    build: () {
      when(() => mockRepo.getHistoricalCandles(symbol: any(named: "symbol"), timeframe: any(named: "timeframe")))
          .thenAnswer((_) async => [
                CandleEntity(
                    instrument: "EUR_USD",
                    timeUtc: DateTime.utc(2025, 1, 1, 0, 0),
                    open: 1.0,
                    high: 2.0,
                    low: 0.9,
                    close: 1.5,
                    volume: 1),
              ]);
      return ChartBloc(mockRepo);
    },
    act: (bloc) => bloc.add(LoadChartData(symbol: "EUR_USD", timeframe: "M1")),
    expect: () => [
      isA<ChartLoading>(),
      isA<ChartLoaded>(),
    ],
  );
}
EOF
cat > lib/features/market/presentation/bloc/trading/trading_event.dart << 'EOF'
abstract class TradingEvent {}

class PlaceOrder extends TradingEvent {
  final String instrument;
  final OrderSide side;
  final double price;
  final double size;

  PlaceOrder({
    required this.instrument,
    required this.side,
    required this.price,
    required this.size,
  });
}

class ClosePosition extends TradingEvent {
  final String positionId;

  ClosePosition({required this.positionId});
}

class RefreshPositions extends TradingEvent {}
EOF
cat > lib/features/market/presentation/bloc/trading/trading_state.dart << 'EOF'
import '../../../../market/domain/backtest/backtest_models.dart';

abstract class TradingState {}

class TradingInitial extends TradingState {}

class TradingLoading extends TradingState {}

class TradingPositionsLoaded extends TradingState {
  final List<Position> positions;
  TradingPositionsLoaded(this.positions);
}

class TradingOrderSuccess extends TradingState {
  final String message;
  TradingOrderSuccess(this.message);
}

class TradingFailure extends TradingState {
  final String error;
  TradingFailure(this.error);
}
EOF
cat > lib/features/market/presentation/bloc/trading/trading_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'trading_event.dart';
import 'trading_state.dart';
import '../../../../market/data/repositories/trading_repository.dart';
import '../../../../market/domain/backtest/backtest_models.dart';

class TradingBloc extends Bloc<TradingEvent, TradingState> {
  final TradingRepository repository;

  TradingBloc(this.repository) : super(TradingInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<ClosePosition>(_onClosePosition);
    on<RefreshPositions>(_onRefreshPositions);
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<TradingState> emit) async {
    emit(TradingLoading());

    try {
      final updatedPositions = await repository.placeOrder(
        instrument: event.instrument,
        side: event.side,
        price: event.price,
        size: event.size,
      );

      emit(TradingOrderSuccess("Order placed successfully"));
      emit(TradingPositionsLoaded(updatedPositions));
    } catch (e) {
      emit(TradingFailure(e.toString()));
    }
  }

  Future<void> _onClosePosition(ClosePosition event, Emitter<TradingState> emit) async {
    emit(TradingLoading());

    try {
      final updatedPositions = await repository.closePosition(event.positionId);
      emit(TradingOrderSuccess("Position closed successfully"));
      emit(TradingPositionsLoaded(updatedPositions));
    } catch (e) {
      emit(TradingFailure(e.toString()));
    }
  }

  Future<void> _onRefreshPositions(RefreshPositions event, Emitter<TradingState> emit) async {
    emit(TradingLoading());

    try {
      final positions = await repository.getOpenPositions();
      emit(TradingPositionsLoaded(positions));
    } catch (e) {
      emit(TradingFailure(e.toString()));
    }
  }
}
EOF
cat > test/bloc/trading/trading_bloc_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/market/presentation/bloc/trading/trading_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/trading/trading_event.dart';
import 'package:your_app/features/market/presentation/bloc/trading/trading_state.dart';
import 'package:your_app/market/data/repositories/trading_repository.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../market/domain/backtest/backtest_models.dart';

class MockTradingRepo extends Mock implements TradingRepository {}

void main() {
  late MockTradingRepo mockRepo;

  setUp(() {
    mockRepo = MockTradingRepo();
  });

  blocTest<TradingBloc, TradingState>(
    'emits OrderSuccess and PositionsLoaded on successful PlaceOrder',
    build: () {
      when(() => mockRepo.placeOrder(
          instrument: any(named: 'instrument'),
          side: any(named: 'side'),
          price: any(named: 'price'),
          size: any(named: 'size')))
          .thenAnswer((_) async => <Position>[]);

      return TradingBloc(mockRepo);
    },
    act: (bloc) => bloc.add(PlaceOrder(
      instrument: "EUR_USD",
      side: OrderSide.buy,
      price: 1.1,
      size: 1.0,
    )),
    expect: () => [
      isA<TradingLoading>(),
      isA<TradingOrderSuccess>(),
      isA<TradingPositionsLoaded>(),
    ],
  );
}
EOF
cat > lib/features/market/presentation/bloc/backtest/backtest_event.dart << 'EOF'
abstract class BacktestEvent {}

class RunBacktest extends BacktestEvent {
  final List<dynamic> history; // List<CandleEntity>
  final String strategyId;      // معرف الاستراتيجية (سيتم ترجمته لاحقًا)
  final double takeProfit;
  final double stopLoss;

  RunBacktest({
    required this.history,
    required this.strategyId,
    this.takeProfit = 0,
    this.stopLoss = 0,
  });
}

class CancelBacktest extends BacktestEvent {}
EOF
cat > lib/features/market/presentation/bloc/backtest/backtest_state.dart << 'EOF'
import '../../../../features/market/domain/backtest/backtest_result.dart';

abstract class BacktestState {}

class BacktestInitial extends BacktestState {}

class BacktestRunning extends BacktestState {}

class BacktestSuccess extends BacktestState {
  final BacktestResult result;
  BacktestSuccess(this.result);
}

class BacktestError extends BacktestState {
  final String message;
  BacktestError(this.message);
}

class BacktestCancelled extends BacktestState {}
EOF
cat > lib/features/market/presentation/bloc/backtest/backtest_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'backtest_event.dart';
import 'backtest_state.dart';
import '../../../../features/market/domain/backtest/backtest_engine.dart';
import '../../../../features/strategy/domain/evaluator/example_strategy.dart';
import '../../../../core/models/candle_entity.dart';

class BacktestBloc extends Bloc<BacktestEvent, BacktestState> {
  BacktestBloc() : super(BacktestInitial()) {
    on<RunBacktest>(_onRunBacktest);
    on<CancelBacktest>(_onCancelBacktest);
  }

  bool _cancelRequested = false;

  Future<void> _onRunBacktest(RunBacktest event, Emitter<BacktestState> emit) async {
    emit(BacktestRunning());
    _cancelRequested = false;

    try {
      // ترجمة strategyId إلى StrategyEvaluator
      // هنا افتراضيا نستخدم مثال
      final evaluator = buildExampleStrategy();

      final engine = BacktestEngine(
        history: event.history.cast<CandleEntity>(),
        evaluator: evaluator,
        takeProfit: event.takeProfit,
        stopLoss: event.stopLoss,
      );

      final result = engine.run();

      if (_cancelRequested) {
        emit(BacktestCancelled());
      } else {
        emit(BacktestSuccess(result));
      }
    } catch (e) {
      emit(BacktestError(e.toString()));
    }
  }

  void _onCancelBacktest(CancelBacktest event, Emitter<BacktestState> emit) {
    _cancelRequested = true;
    emit(BacktestCancelled());
  }
}
EOF
cat > test/bloc/backtest/backtest_bloc_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/market/presentation/bloc/backtest/backtest_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/backtest/backtest_event.dart';
import 'package:your_app/features/market/presentation/bloc/backtest/backtest_state.dart';
import '../../../mocks.dart';
import '../../../../core/models/candle_entity.dart';

void main() {
  blocTest<BacktestBloc, BacktestState>(
    'emits [Running, Success] when backtest runs without cancellation',
    build: () => BacktestBloc(),
    act: (bloc) => bloc.add(RunBacktest(
      history: [
        CandleEntity(
            instrument: "EUR_USD",
            timeUtc: DateTime.utc(2025, 1, 1),
            open: 1.0,
            high: 1.1,
            low: 0.9,
            close: 1.05,
            volume: 1)
      ],
      strategyId: "example",
    )),
    expect: () => [
      isA<BacktestRunning>(),
      isA<BacktestSuccess>(),
    ],
  );
}
EOF
cat > lib/features/strategy/presentation/bloc/strategy_builder_event.dart << 'EOF'
abstract class StrategyBuilderEvent {}

class AddBlock extends StrategyBuilderEvent {
  final String id;
  final String type;
  final Map<String, dynamic> params;

  AddBlock({
    required this.id,
    required this.type,
    required this.params,
  });
}

class RemoveBlock extends StrategyBuilderEvent {
  final String id;
  RemoveBlock(this.id);
}

class ConnectBlocks extends StrategyBuilderEvent {
  final String fromId;
  final String toId;

  ConnectBlocks({required this.fromId, required this.toId});
}

class UpdateBlockParams extends StrategyBuilderEvent {
  final String id;
  final Map<String, dynamic> params;

  UpdateBlockParams({required this.id, required this.params});
}

class LoadStrategyGraph extends StrategyBuilderEvent {
  final String graphId;
  LoadStrategyGraph(this.graphId);
}

class SaveStrategyGraph extends StrategyBuilderEvent {
  final String graphId;
  SaveStrategyGraph(this.graphId);
}
EOF
cat > lib/features/strategy/presentation/bloc/strategy_builder_state.dart << 'EOF'
import '../../../../core/models/strategy_graph.dart';

abstract class StrategyBuilderState {}

class BuilderInitial extends StrategyBuilderState {}

class BuilderLoaded extends StrategyBuilderState {
  final StrategyGraph graph;
  BuilderLoaded(this.graph);
}

class BuilderError extends StrategyBuilderState {
  final String message;
  BuilderError(this.message);
}
EOF
cat > lib/features/strategy/presentation/bloc/strategy_builder_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'strategy_builder_event.dart';
import 'strategy_builder_state.dart';
import '../../../../core/storage/strategy/strategy_storage.dart';
import '../../../../core/models/strategy_graph.dart';

class StrategyBuilderBloc extends Bloc<StrategyBuilderEvent, StrategyBuilderState> {
  final StrategyStorage storage;

  StrategyBuilderBloc(this.storage) : super(BuilderInitial()) {
    on<AddBlock>(_onAddBlock);
    on<RemoveBlock>(_onRemoveBlock);
    on<ConnectBlocks>(_onConnect);
    on<UpdateBlockParams>(_onUpdateParams);
    on<LoadStrategyGraph>(_onLoad);
    on<SaveStrategyGraph>(_onSave);
  }

  StrategyGraph _current = StrategyGraph(blocks: [], connections: []);

  void _onAddBlock(AddBlock event, Emitter<StrategyBuilderState> emit) {
    _current.blocks.add(
      Block(id: event.id, type: event.type, params: event.params),
    );
    emit(BuilderLoaded(_current));
  }

  void _onRemoveBlock(RemoveBlock event, Emitter<StrategyBuilderState> emit) {
    _current.blocks.removeWhere((b) => b.id == event.id);
    _current.connections.removeWhere((c) => c.fromBlockId == event.id || c.toBlockId == event.id);
    emit(BuilderLoaded(_current));
  }

  void _onConnect(ConnectBlocks event, Emitter<StrategyBuilderState> emit) {
    _current.connections.add(Connection(fromBlockId: event.fromId, toBlockId: event.toId));
    emit(BuilderLoaded(_current));
  }

  void _onUpdateParams(UpdateBlockParams event, Emitter<StrategyBuilderState> emit) {
    final block = _current.blocks.firstWhere((b) => b.id == event.id);
    if (block != null) {
      block.params.addAll(event.params);
    }
    emit(BuilderLoaded(_current));
  }

  Future<void> _onLoad(LoadStrategyGraph event, Emitter<StrategyBuilderState> emit) async {
    try {
      final graph = await storage.load(event.graphId);
      _current = graph;
      emit(BuilderLoaded(graph));
    } catch (e) {
      emit(BuilderError(e.toString()));
    }
  }

  Future<void> _onSave(SaveStrategyGraph event, Emitter<StrategyBuilderState> emit) async {
    try {
      await storage.save(event.graphId, _current);
      emit(BuilderLoaded(_current));
    } catch (e) {
      emit(BuilderError(e.toString()));
    }
  }
}
EOF
cat > lib/core/storage/strategy/strategy_storage.dart << 'EOF'
import '../../../../core/models/strategy_graph.dart';

abstract class StrategyStorage {
  Future<void> save(String id, StrategyGraph graph);
  Future<StrategyGraph> load(String id);
}
EOF
cat > test/bloc/strategy_builder/strategy_builder_bloc_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/strategy/presentation/bloc/strategy_builder_bloc.dart';
import 'package:your_app/features/strategy/presentation/bloc/strategy_builder_event.dart';
import 'package:your_app/features/strategy/presentation/bloc/strategy_builder_state.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../core/models/strategy_graph.dart';
import '../../../mocks.dart';

class MockStrategyStorage extends Mock implements StrategyStorage {}

void main() {
  late MockStrategyStorage mockStorage;

  setUp(() {
    mockStorage = MockStrategyStorage();
  });

  blocTest<StrategyBuilderBloc, StrategyBuilderState>(
    'emits BuilderLoaded on AddBlock',
    build: () => StrategyBuilderBloc(mockStorage),
    act: (bloc) =>
        bloc.add(AddBlock(id: 'b1', type: 'ema', params: {})),
    expect: () => [isA<BuilderLoaded>()],
  );
}
EOF
cat > lib/features/alert/presentation/bloc/smart_alert_event.dart << 'EOF'
abstract class SmartAlertEvent {}

class AddAlertRule extends SmartAlertEvent {
  final String id;
  final String condition; // expression like "RSI < 30"
  AddAlertRule(this.id, this.condition);
}

class RemoveAlertRule extends SmartAlertEvent {
  final String id;
  RemoveAlertRule(this.id);
}

class CheckAlerts extends SmartAlertEvent {
  final dynamic candle; // can be CandleEntity or other
  CheckAlerts(this.candle);
}
EOF
cat > lib/features/alert/presentation/bloc/smart_alert_state.dart << 'EOF'
abstract class SmartAlertState {}

class AlertInitial extends SmartAlertState {}

class AlertRuleAdded extends SmartAlertState {}

class AlertRuleRemoved extends SmartAlertState {}

class AlertTriggered extends SmartAlertState {
  final String id;
  AlertTriggered(this.id);
}

class AlertError extends SmartAlertState {
  final String message;
  AlertError(this.message);
}
EOF
cat > lib/features/alert/presentation/bloc/smart_alert_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'smart_alert_event.dart';
import 'smart_alert_state.dart';

class SmartAlertBloc extends Bloc<SmartAlertEvent, SmartAlertState> {
  final Map<String, String> _rules = {};

  SmartAlertBloc() : super(AlertInitial()) {
    on<AddAlertRule>(_onAddRule);
    on<RemoveAlertRule>(_onRemoveRule);
    on<CheckAlerts>(_onCheck);
  }

  void _onAddRule(AddAlertRule event, Emitter<SmartAlertState> emit) {
    _rules[event.id] = event.condition;
    emit(AlertRuleAdded());
  }

  void _onRemoveRule(RemoveAlertRule event, Emitter<SmartAlertState> emit) {
    _rules.remove(event.id);
    emit(AlertRuleRemoved());
  }

  void _onCheck(CheckAlerts event, Emitter<SmartAlertState> emit) {
    try {
      // simple evaluator placeholder
      final triggered = _rules.entries
          .where((e) => event.candle.toString().contains(e.value))
          .map((e) => e.key)
          .toList();

      for (final id in triggered) {
        emit(AlertTriggered(id));
      }
    } catch (e) {
      emit(AlertError(e.toString()));
    }
  }
}
EOF
cat > lib/features/replay/presentation/bloc/replay_event.dart << 'EOF'
abstract class ReplayEvent {}

class StartReplay extends ReplayEvent {
  final List<dynamic> history;
  StartReplay(this.history);
}

class PauseReplay extends ReplayEvent {}

class SeekReplay extends ReplayEvent {
  final int index;
  SeekReplay(this.index);
}

class ChangeReplaySpeed extends ReplayEvent {
  final double speed;
  ChangeReplaySpeed(this.speed);
}
EOF
cat > lib/features/replay/presentation/bloc/replay_state.dart << 'EOF'
abstract class ReplayState {}

class ReplayInitial extends ReplayState {}

class ReplayRunning extends ReplayState {
  final int index;
  final double speed;
  ReplayRunning(this.index, this.speed);
}

class ReplayPaused extends ReplayState {
  final int index;
  final double speed;
  ReplayPaused(this.index, this.speed);
}

class ReplayError extends ReplayState {
  final String error;
  ReplayError(this.error);
}
EOF
cat > lib/features/replay/presentation/bloc/replay_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'replay_event.dart';
import 'replay_state.dart';

class ReplayBloc extends Bloc<ReplayEvent, ReplayState> {
  ReplayBloc() : super(ReplayInitial()) {
    on<StartReplay>(_onStart);
    on<PauseReplay>(_onPause);
    on<SeekReplay>(_onSeek);
    on<ChangeReplaySpeed>(_onSpeed);
  }

  int _currentIndex = 0;
  double _speed = 1.0;

  void _onStart(StartReplay event, Emitter<ReplayState> emit) {
    if (event.history.isEmpty) {
      return emit(ReplayError("No data"));
    }
    _currentIndex = 0;
    emit(ReplayRunning(_currentIndex, _speed));
  }

  void _onPause(PauseReplay event, Emitter<ReplayState> emit) {
    emit(ReplayPaused(_currentIndex, _speed));
  }

  void _onSeek(SeekReplay event, Emitter<ReplayState> emit) {
    _currentIndex = event.index;
    emit(ReplayRunning(_currentIndex, _speed));
  }

  void _onSpeed(ChangeReplaySpeed event, Emitter<ReplayState> emit) {
    _speed = event.speed;
    emit(ReplayRunning(_currentIndex, _speed));
  }
}
EOF
cat > lib/core/storage/theme/theme_hive.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'theme_hive.g.dart';

@HiveType(typeId: 10)
class ThemeEntity extends HiveObject {
  @HiveField(0)
  final bool isDark;

  @HiveField(1)
  final int primaryColorValue;

  @HiveField(2)
  final int accentColorValue;

  ThemeEntity({
    required this.isDark,
    required this.primaryColorValue,
    required this.accentColorValue,
  });

  ThemeData toThemeData() {
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: Color(primaryColorValue),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(
          primaryColorValue,
          <int, Color>{
            50: Color(primaryColorValue),
            100: Color(primaryColorValue),
            200: Color(primaryColorValue),
            300: Color(primaryColorValue),
            400: Color(primaryColorValue),
            500: Color(primaryColorValue),
            600: Color(primaryColorValue),
            700: Color(primaryColorValue),
            800: Color(primaryColorValue),
            900: Color(primaryColorValue),
          },
        ),
      ).copyWith(secondary: Color(accentColorValue)),
    );
  }
}
EOF
cat > lib/core/storage/theme/theme_storage.dart << 'EOF'
import 'package:hive/hive.dart';
import 'theme_hive.dart';

class ThemeStorage {
  static const _box = "theme_box";

  Future<void> saveTheme(ThemeEntity theme) async {
    final box = await Hive.openBox<ThemeEntity>(_box);
    await box.put('current', theme);
  }

  Future<ThemeEntity?> loadTheme() async {
    final box = await Hive.openBox<ThemeEntity>(_box);
    return box.get('current');
  }

  Future<void> clear() async {
    final box = await Hive.openBox<ThemeEntity>(_box);
    await box.clear();
  }
}
EOF
cat > test/storage/theme/theme_storage_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:your_app/core/storage/theme/theme_storage.dart';
import 'package:your_app/core/storage/theme/theme_hive.dart';
import 'dart:io';

class FakePathProvider extends Fake implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return Directory.systemTemp.path;
  }
}

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.path);
    Hive.registerAdapter(ThemeEntityAdapter());
  });

  test('save and load theme', () async {
    final store = ThemeStorage();
    final theme = ThemeEntity(isDark: true, primaryColorValue: 0xFF0000, accentColorValue: 0x00FF00);
    await store.saveTheme(theme);

    final loaded = await store.loadTheme();
    expect(loaded?.isDark, true);
    expect(loaded?.primaryColorValue, theme.primaryColorValue);
  });
}
EOF
cat > lib/core/storage/script/script_hive.dart << 'EOF'
import 'package:hive/hive.dart';

part 'script_hive.g.dart';

@HiveType(typeId: 11)
class ScriptEntity extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String script;

  ScriptEntity({required this.name, required this.script});
}
EOF
cat > lib/core/storage/script/script_storage.dart << 'EOF'
import 'package:hive/hive.dart';
import 'script_hive.dart';

class ScriptStorage {
  static const _box = "scripts_box";

  Future<void> saveScript(ScriptEntity script) async {
    final box = await Hive.openBox<ScriptEntity>(_box);
    await box.put(script.name, script);
  }

  Future<ScriptEntity?> loadScript(String name) async {
    final box = await Hive.openBox<ScriptEntity>(_box);
    return box.get(name);
  }

  Future<List<ScriptEntity>> getAllScripts() async {
    final box = await Hive.openBox<ScriptEntity>(_box);
    return box.values.toList();
  }

  Future<void> deleteScript(String name) async {
    final box = await Hive.openBox<ScriptEntity>(_box);
    await box.delete(name);
  }
}
EOF
cat > test/storage/script/script_storage_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:your_app/core/storage/script/script_storage.dart';
import 'package:your_app/core/storage/script/script_hive.dart';

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.path);
    Hive.registerAdapter(ScriptEntityAdapter());
  });

  test('save and load script', () async {
    final storage = ScriptStorage();
    final script = ScriptEntity(name: "Test1", script: "EMA(10)>EMA(20)");
    await storage.saveScript(script);

    final loaded = await storage.loadScript("Test1");
    expect(loaded?.script, "EMA(10)>EMA(20)");
  });
}
EOF
cat > lib/core/storage/audit/audit_hive.dart << 'EOF'
import 'package:hive/hive.dart';

part 'audit_hive.g.dart';

@HiveType(typeId: 12)
class AuditEntity extends HiveObject {
  @HiveField(0)
  final DateTime time;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final String message;

  AuditEntity({
    required this.time,
    required this.type,
    required this.message,
  });
}
EOF
cat > lib/core/storage/audit/audit_storage.dart << 'EOF'
import 'package:hive/hive.dart';
import 'audit_hive.dart';

class AuditStorage {
  static const _box = "audit_box";

  Future<void> logEvent(AuditEntity event) async {
    final box = await Hive.openBox<AuditEntity>(_box);
    await box.add(event);
  }

  Future<List<AuditEntity>> getEvents() async {
    final box = await Hive.openBox<AuditEntity>(_box);
    return box.values.toList();
  }

  Future<void> clear() async {
    final box = await Hive.openBox<AuditEntity>(_box);
    await box.clear();
  }
}
EOF
cat > test/storage/audit/audit_storage_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:your_app/core/storage/audit/audit_storage.dart';
import 'package:your_app/core/storage/audit/audit_hive.dart';

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.path);
    Hive.registerAdapter(AuditEntityAdapter());
  });

  test('log and retrieve audit event', () async {
    final storage = AuditStorage();
    final event = AuditEntity(time: DateTime.now(), type: "Test", message: "Hello");
    await storage.logEvent(event);

    final list = await storage.getEvents();
    expect(list.length, greaterThan(0));
  });
}
EOF
cat > lib/core/storage/indicator/indicator_hive.dart << 'EOF'
import 'package:hive/hive.dart';

part 'indicator_hive.g.dart';

@HiveType(typeId: 13)
class IndicatorSettingsEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final Map<String, dynamic> params;

  IndicatorSettingsEntity({
    required this.id,
    required this.params,
  });
}
EOF
cat > lib/core/storage/indicator/indicator_storage.dart << 'EOF'
import 'package:hive/hive.dart';
import 'indicator_hive.dart';

class IndicatorSettingsStorage {
  static const _box = "indicator_box";

  Future<void> saveSettings(IndicatorSettingsEntity e) async {
    final box = await Hive.openBox<IndicatorSettingsEntity>(_box);
    await box.put(e.id, e);
  }

  Future<IndicatorSettingsEntity?> loadSettings(String id) async {
    final box = await Hive.openBox<IndicatorSettingsEntity>(_box);
    return box.get(id);
  }

  Future<List<IndicatorSettingsEntity>> getAll() async {
    final box = await Hive.openBox<IndicatorSettingsEntity>(_box);
    return box.values.toList();
  }
}
EOF
cat > test/storage/indicator/indicator_storage_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:your_app/core/storage/indicator/indicator_storage.dart';
import 'package:your_app/core/storage/indicator/indicator_hive.dart';

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.path);
    Hive.registerAdapter(IndicatorSettingsEntityAdapter());
  });

  test('save and load indicator settings', () async {
    final store = IndicatorSettingsStorage();
    final e = IndicatorSettingsEntity(id: "EMA10", params: {"color": 0xFF0000});
    await store.saveSettings(e);

    final loaded = await store.loadSettings("EMA10");
    expect(loaded?.params["color"], 0xFF0000);
  });
}
EOF
cat > lib/core/storage/replay/replay_hive.dart << 'EOF'
import 'package:hive/hive.dart';

part 'replay_hive.g.dart';

@HiveType(typeId: 14)
class ReplayStateEntity extends HiveObject {
  @HiveField(0)
  final String symbol;

  @HiveField(1)
  final int lastIndex;

  ReplayStateEntity({required this.symbol, required this.lastIndex});
}
EOF
cat > lib/core/storage/replay/replay_storage.dart << 'EOF'
import 'package:hive/hive.dart';
import 'replay_hive.dart';

class ReplayStorage {
  static const _box = "replay_box";

  Future<void> save(String symbol, int index) async {
    final box = await Hive.openBox<ReplayStateEntity>(_box);
    await box.put(symbol, ReplayStateEntity(symbol: symbol, lastIndex: index));
  }

  Future<ReplayStateEntity?> load(String symbol) async {
    final box = await Hive.openBox<ReplayStateEntity>(_box);
    return box.get(symbol);
  }
}
EOF
cat > test/unit/indicators/ema_indicator_edge_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/strategy/domain/indicators/ema_indicator.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  test('EMA with constant values stabilizes', () {
    final ema = EMAIndicator(5);
    final candles = List.generate(100, (i) => CandleEntity(
      instrument: "XAU_USD",
      timeUtc: DateTime.utc(2025,1,1,0,i),
      open: 10.0,
      high: 10.0,
      low: 10.0,
      close: 10.0,
      volume: 1,
    ));

    for (var c in candles) {
      ema.addCandle(c);
    }

    // After many identical closes, current should equal 10
    expect(ema.current, 10.0);
  });
}
EOF
cat > test/unit/indicators/rsi_no_loss_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/strategy/domain/indicators/rsi_indicator.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  test('RSI when there is no loss should be 100', () {
    final rsi = RSIIndicator(14);
    final candles = List.generate(20, (i) => CandleEntity(
      instrument: "EUR_USD",
      timeUtc: DateTime.utc(2025,1,1,0,i),
      open: i.toDouble(),
      high: i.toDouble()+1,
      low: i.toDouble(),
      close: i.toDouble()+2,
      volume: 1,
    ));

    for (var c in candles) {
      rsi.addCandle(c);
    }

    expect(rsi.current, 100.0);
  });
}
EOF
cat > test/unit/backtest/backtest_engine_profit_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/backtest/backtest_engine.dart';
import 'package:your_app/features/strategy/domain/evaluator/example_strategy.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  test('Backtest net profit should accumulate correctly', () {
    // Construct history where price moves up
    final history = [
      CandleEntity(instrument: "EUR_USD", timeUtc: DateTime.utc(2025,1,1), open: 1.0, high: 2.0, low: 1.0, close: 1.5, volume: 1),
      CandleEntity(instrument: "EUR_USD", timeUtc: DateTime.utc(2025,1,1,0,1), open: 1.5, high: 2.5, low: 1.5, close: 2.0, volume: 1),
    ];

    final engine = BacktestEngine(
      history: history,
      evaluator: buildExampleStrategy(),
      initialBalance: 1000,
      takeProfit: 0,
      stopLoss: 0,
    );

    final result = engine.run();

    expect(result.netProfit, greaterThan(0));
    expect(result.equityCurve.last, greaterThan(result.equityCurve.first));
  });
}
EOF
cat > test/unit/streaming/tick_aggregator_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/data/streaming/tick_aggregator.dart';
import 'package:your_app/core/models/tick_entity.dart';

void main() {
  test('TickAggregator handles out of order ticks', () {
    final agg = TickAggregator("EUR_USD", Duration(seconds: 60));

    final t1 = TickEntity(instrument:"EUR_USD", timeUtc: DateTime.utc(2025,1,1,0,1), bid:2, ask:2);
    final t0 = TickEntity(instrument:"EUR_USD", timeUtc: DateTime.utc(2025,1,1,0,0), bid:1, ask:1);

    agg.addTick(t1);
    agg.addTick(t0);

    final candles = agg.buildCandles();
    expect(candles.length, 2);
    expect(candles[0].open, 1);
    expect(candles[1].open, 2);
  });
}
EOF
cat > test/bloc/backtest/backtest_cancel_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/market/presentation/bloc/backtest/backtest_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/backtest/backtest_event.dart';
import 'package:your_app/features/market/presentation/bloc/backtest/backtest_state.dart';

void main() {
  blocTest<BacktestBloc, BacktestState>(
    'emits Cancelled when cancel event is added',
    build: () => BacktestBloc(),
    act: (bloc) {
      bloc.add(RunBacktest(history: [], strategyId: "", takeProfit: 0, stopLoss: 0));
      bloc.add(CancelBacktest());
    },
    expect: () => [isA<BacktestRunning>(), isA<BacktestCancelled>()],
  );
}
EOF
cat > test/bloc/replay/replay_edge_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:your_app/features/replay/presentation/bloc/replay_bloc.dart';
import 'package:your_app/features/replay/presentation/bloc/replay_event.dart';
import 'package:your_app/features/replay/presentation/bloc/replay_state.dart';

void main() {
  blocTest<ReplayBloc, ReplayState>(
    'SeekReplay updates index',
    build: () => ReplayBloc(),
    act: (bloc) => bloc.add(SeekReplay(5)),
    expect: () => [isA<ReplayRunning>()],
    verify: (bloc) {
      final state = bloc.state;
      expect((state as ReplayRunning).index, 5);
    },
  );

  blocTest<ReplayBloc, ReplayState>(
    'ChangeReplaySpeed updates speed',
    build: () => ReplayBloc(),
    act: (bloc) => bloc.add(ChangeReplaySpeed(2.0)),
    expect: () => [isA<ReplayRunning>()],
    verify: (bloc) {
      final state = bloc.state;
      expect((state as ReplayRunning).speed, 2.0);
    },
  );
}
EOF
cat > integration_test/chart_integration_test.dart << 'EOF'
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_bloc.dart';
import 'package:your_app/features/market/presentation/bloc/chart/chart_event.dart';
import 'package:your_app/market/data/repositories/market_repository.dart';
import 'package:your_app/core/network/rest_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ChartBloc integration test', (tester) async {
    final repo = MarketRepository(RestClient("fakeToken","https://fake.url"));
    final bloc = ChartBloc(repo);

    bloc.add(LoadChartData(symbol: "EUR_USD", timeframe: "M1"));
    await tester.pumpAndSettle();
    expect(bloc.state, isNot(isA<ChartError>()));
  });
}
EOF
cat > test/stress/backtest_stress_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/domain/backtest/backtest_engine.dart';
import 'package:your_app/features/strategy/domain/evaluator/example_strategy.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  test('Backtest handles 10000 candles in <1 second', () {
    final history = List.generate(10000, (i) => CandleEntity(
      instrument: "XAU_USD",
      timeUtc: DateTime.utc(2025,1,1,0,i),
      open: i.toDouble(),
      high: i.toDouble()+1,
      low: i.toDouble(),
      close: i.toDouble(),
      volume: 1,
    ));

    final engine = BacktestEngine(history: history, evaluator: buildExampleStrategy());
    final stopwatch = Stopwatch()..start();
    engine.run();
    stopwatch.stop();

    expect(stopwatch.elapsed.inSeconds < 1, true);
  });
}
EOF
cat > test/integration/ws/ws_reconnect_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/core/network/ws_manager.dart';

void main() {
  test('WSManager reconnect logic', () async {
    final ws = WSManager('wss://echo.websocket.events');
    ws.connect();
    await Future.delayed(Duration(seconds: 2));
    ws.send('test');

    final data = await ws.stream.first;
    expect(data, isNotNull);

    ws.dispose();
  });
}
EOF
cat > test/unit/network/rest_token_expired_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/core/network/rest_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('REST client handles token expired (401)', () async {
    final mockClient = MockClient((request) async {
      return http.Response('', 401);
    });

    final client = RestClient("token","base", client: mockClient);
    expect(() => client.get("/x"), throwsException);
  });
}
EOF
cat > lib/core/sync/sync_manager.dart << 'EOF'
import 'dart:async';
import '../network/ws_manager.dart';
import '../../features/market/data/streaming/tick_aggregator.dart';
import '../models/tick_entity.dart';
import '../network/rest_client.dart';

typedef CandleUpdateCallback = void Function(List<dynamic> candles);

class SyncManager {
  final WSManager ws;
  final RestClient rest;
  final TickAggregator aggregator;
  final CandleUpdateCallback onCandle;

  StreamSubscription? _wsSub;

  SyncManager({
    required this.ws,
    required this.rest,
    required this.aggregator,
    required this.onCandle,
  });

  void start() {
    ws.connect();
    _wsSub = ws.stream.listen(_processMessage);
  }

  Future<void> stop() async {
    await _wsSub?.cancel();
    ws.dispose();
  }

  void _processMessage(dynamic data) {
    final tick = TickEntity.fromJson("UNKNOWN", data);
    aggregator.addTick(tick);

    final candles = aggregator.buildCandles();
    if (candles.isNotEmpty) {
      onCandle(candles);
    }
  }
}
EOF
cat > test/sync/sync_manager_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/core/sync/sync_manager.dart';
import 'package:your_app/core/network/ws_manager.dart';
import 'package:your_app/core/network/rest_client.dart';
import 'package:your_app/features/market/data/streaming/tick_aggregator.dart';

void main() {
  test('SyncManager processes ticks and builds candles', () async {
    final ws = WSManager('wss://echo.websocket.events');
    final rest = RestClient('','');
    final agg = TickAggregator("SYM", Duration(seconds: 60));
    bool called = false;

    final manager = SyncManager(
      ws: ws,
      rest: rest,
      aggregator: agg,
      onCandle: (c) => called = true,
    );

    manager.start();
    await Future.delayed(Duration(seconds: 1));
    await manager.stop();

    expect(called, true);
  });
}
EOF
cat > test/widgets/chart/interactive_chart_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:your_app/features/chart/presentation/widgets/interactive_chart.dart';

void main() {
  testWidgets('Pinch Zoom changes scale', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: InteractiveChart(candles: [], onRangeChanged: (_,__){}),
    ));

    final finder = find.byType(InteractiveChart);
    await tester.pinch(finder, 1.5);
    await tester.pump();

    // تأكد أن scale تغيرت
    // يمكن إضافة تحقق داخلي من حالة widget
  });
}
EOF
cat > lib/core/network/network_service.dart << 'EOF'
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus { online, offline }

class NetworkService {
  final _controller = StreamController<NetworkStatus>.broadcast();

  NetworkService() {
    Connectivity().onConnectivityChanged.listen((status) {
      if (status == ConnectivityResult.none) {
        _controller.add(NetworkStatus.offline);
      } else {
        _controller.add(NetworkStatus.online);
      }
    });
  }

  Stream<NetworkStatus> get networkStatusStream => _controller.stream;
}
EOF
cat >> lib/main.dart << 'EOF'

// بعد runApp
final netService = NetworkService();
netService.networkStatusStream.listen((status) {
  print('Network changed: $status');
  // يمكن إرسال event إلى Bloc معين
});
EOF
cat > lib/market/data/repositories/market_repository.dart << 'EOF'
import '../../../core/storage/chart_cache/chart_cache_storage.dart';
import '../../../core/network/rest_client.dart';
import '../../../core/models/candle_entity.dart';

class MarketRepository {
  final RestClient rest;
  final ChartCacheStorage cache;

  MarketRepository({required this.rest, required this.cache});

  Future<List<CandleEntity>> getHistoricalCandles({
    required String symbol,
    required String timeframe,
  }) async {
    final cached = await cache.get(symbol, timeframe);
    if (cached.isNotEmpty) {
      // return cache while fetching remote update
      _refreshRemote(symbol, timeframe);
      return cached;
    }
    final remote = await _fetchRemote(symbol, timeframe);
    await cache.save(symbol, timeframe, remote);
    return remote;
  }

  Future<void> _refreshRemote(String symbol, String timeframe) async {
    try {
      final remote = await _fetchRemote(symbol, timeframe);
      await cache.save(symbol, timeframe, remote);
    } catch (e) {
      // ignore
    }
  }

  Future<List<CandleEntity>> _fetchRemote(
      String symbol, String timeframe) async {
    final resp = await rest.get("/history/$symbol/$timeframe");
    // parse JSON → List<CandleEntity>
    // implementation depends on API shape
    return [];
  }
}
EOF
cat > lib/core/storage/chart_cache/chart_cache_hive.dart << 'EOF'
import 'package:hive/hive.dart';
import '../../../core/models/candle_entity.dart';

part "chart_cache_hive.g.dart";

@HiveType(typeId: 50)
class ChartCacheEntity extends HiveObject {
  @HiveField(0)
  final String symbol;

  @HiveField(1)
  final String timeframe;

  @HiveField(2)
  final List<CandleEntity> candles;

  ChartCacheEntity({
    required this.symbol,
    required this.timeframe,
    required this.candles,
  });
}
EOF
cat > lib/core/storage/chart_cache/chart_cache_storage.dart << 'EOF'
import 'package:hive/hive.dart';
import 'chart_cache_hive.dart';

class ChartCacheStorage {
  static const _box = "chart_cache_box";

  Future<void> save(
      String symbol, String timeframe, List<CandleEntity> candles) async {
    final box = await Hive.openBox<ChartCacheEntity>(_box);
    await box.put("${symbol}_$timeframe",
        ChartCacheEntity(symbol: symbol, timeframe: timeframe, candles: candles));
  }

  Future<List<CandleEntity>> get(String symbol, String timeframe) async {
    final box = await Hive.openBox<ChartCacheEntity>(_box);
    final entity = box.get("${symbol}_$timeframe");
    return entity?.candles ?? [];
  }

  Future<void> clear() async {
    final box = await Hive.openBox<ChartCacheEntity>(_box);
    await box.clear();
  }
}
EOF
cat > test/widgets/offline/offline_banner_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:your_app/main.dart';

void main() {
  testWidgets('Offline banner appears', (tester) async {
    await tester.pumpWidget(MyApp());
    // Simulate offline event
    // This part may require dependency injection of NetworkService
  });
}
EOF
cat > lib/core/time/time_canon.dart << 'EOF'
class TimeCanon {
  /// يحوّل أي DateTime أو String إلى UTC موحّد
  static DateTime toUtc(dynamic t) {
    if (t is DateTime) {
      return t.toUtc();
    }
    if (t is String) {
      return DateTime.parse(t).toUtc();
    }
    throw ArgumentError("Unsupported time type: $t");
  }

  /// يقارن زمنين بعد توحيدهما
  static bool isSameInstant(dynamic a, dynamic b) {
    return toUtc(a).isAtSameMomentAs(toUtc(b));
  }

  /// يضمن أن أي Timestamp صادر عن النظام هو UTC فقط
  static String isoUtc(DateTime t) {
    return t.toUtc().toIso8601String();
  }
}
EOF
cat > lib/core/models/candle_entity.dart << 'EOF'
import '../time/time_canon.dart';

class CandleEntity {
  final String instrument;
  final DateTime timeUtc;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  CandleEntity({
    required this.instrument,
    required this.timeUtc,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory CandleEntity.fromJson(String instrument, Map<String, dynamic> json) {
    return CandleEntity(
      instrument: instrument,
      timeUtc: TimeCanon.toUtc(json['time']),
      open: double.parse(json['open']),
      high: double.parse(json['high']),
      low: double.parse(json['low']),
      close: double.parse(json['close']),
      volume: double.parse(json['volume']),
    );
  }
}
EOF
cat > lib/core/models/price/market_price.dart << 'EOF'
enum PriceType { bid, ask, mid }

class MarketPrice {
  final double bid;
  final double ask;

  MarketPrice({required this.bid, required this.ask});

  double of(PriceType type) {
    switch (type) {
      case PriceType.bid:
        return bid;
      case PriceType.ask:
        return ask;
      case PriceType.mid:
        return (bid + ask) / 2;
    }
  }
}
EOF
cat > lib/core/models/tick_entity.dart << 'EOF'
import '../time/time_canon.dart';
import 'price/market_price.dart';

class TickEntity {
  final String instrument;
  final DateTime timeUtc;
  final MarketPrice price;

  TickEntity({
    required this.instrument,
    required this.timeUtc,
    required this.price,
  });

  factory TickEntity.fromJson(String instrument, Map<String, dynamic> json) {
    return TickEntity(
      instrument: instrument,
      timeUtc: TimeCanon.toUtc(json['time']),
      price: MarketPrice(
        bid: double.parse(json['bid']),
        ask: double.parse(json['ask']),
      ),
    );
  }
}
EOF
cat > lib/features/market/data/streaming/tick_aggregator.dart << 'EOF'
import '../../../core/models/tick_entity.dart';
import '../../../core/models/candle_entity.dart';
import '../../../core/time/time_canon.dart';

class TickAggregator {
  final String instrument;
  final Duration timeframe;
  CandleEntity? _current;
  final List<CandleEntity> archive = [];

  TickAggregator(this.instrument, this.timeframe);

  void addTick(TickEntity tick) {
    final tickTime = tick.timeUtc;

    if (_current == null) {
      _current = _newCandleFromTick(tick);
      return;
    }

    // إذا قفز الزمن أكثر من timeframe → فجوة
    if (tickTime.difference(_current!.timeUtc) >= timeframe) {
      archive.add(_current!);
      _current = _newCandleFromTick(tick);
      return;
    }

    // تحديث High/Low/Close
    _current = CandleEntity(
      instrument: instrument,
      timeUtc: _current!.timeUtc,
      open: _current!.open,
      high: tick.price.of(PriceType.mid) > _current!.high
          ? tick.price.of(PriceType.mid)
          : _current!.high,
      low: tick.price.of(PriceType.mid) < _current!.low
          ? tick.price.of(PriceType.mid)
          : _current!.low,
      close: tick.price.of(PriceType.mid),
      volume: _current!.volume + 1,
    );
  }

  CandleEntity _newCandleFromTick(TickEntity t) {
    final p = t.price.of(PriceType.mid);
    return CandleEntity(
      instrument: instrument,
      timeUtc: t.timeUtc,
      open: p,
      high: p,
      low: p,
      close: p,
      volume: 1,
    );
  }

  List<CandleEntity> buildCandles() {
    return List.unmodifiable(archive);
  }
}
EOF
cat > lib/features/strategy/domain/ast/expr.dart << 'EOF'
abstract class Expr {
  bool eval(Map<String, double> ctx);
}

class GreaterThan extends Expr {
  final String left;
  final String right;

  GreaterThan(this.left, this.right);

  @override
  bool eval(Map<String, double> ctx) {
    return ctx[left]! > ctx[right]!;
  }
}

class LessThan extends Expr {
  final String left;
  final String right;

  LessThan(this.left, this.right);

  @override
  bool eval(Map<String, double> ctx) {
    return ctx[left]! < ctx[right]!;
  }
}

class AndExpr extends Expr {
  final Expr a, b;
  AndExpr(this.a, this.b);

  @override
  bool eval(Map<String, double> ctx) => a.eval(ctx) && b.eval(ctx);
}
EOF
cat > lib/features/strategy/domain/signal/signal.dart << 'EOF'
enum SignalType { buy, sell, hold }

class Signal {
  final SignalType type;
  final DateTime time;

  Signal(this.type, this.time);
}
EOF
cat > lib/features/strategy/domain/fsm/strategy_state.dart << 'EOF'
enum StrategyState {
  idle,
  initializing,
  active,
  paused,
  error,
  completed,
}
EOF
cat > lib/features/strategy/domain/fsm/strategy_fsm.dart << 'EOF'
import 'strategy_state.dart';

class StrategyFSM {
  StrategyState _state = StrategyState.idle;
  StrategyState get state => _state;

  void transitionTo(StrategyState next) {
    // منطق انتقال آمن
    if (_state == StrategyState.error && next != StrategyState.idle) return;
    _state = next;
  }

  bool get isRunning => _state == StrategyState.active;
}
EOF
cat > lib/features/strategy/presentation/bloc/strategy_bloc.dart << 'EOF'
import '../../../domain/fsm/strategy_fsm.dart';

class StrategyBloc {
  final StrategyFSM fsm = StrategyFSM();

  void start() {
    fsm.transitionTo(StrategyState.initializing);
    // تحميل البيانات
    fsm.transitionTo(StrategyState.active);
  }

  void stop() {
    fsm.transitionTo(StrategyState.paused);
  }
}
EOF
cat > lib/features/trading/domain/lot_manager.dart << 'EOF'
class LotManager {
  double lotSize = 1.0;

  void setLot(double l) {
    if (l <= 0) throw ArgumentError("Lot size must be > 0");
    lotSize = l;
  }

  double get current => lotSize;
}
EOF
cat > lib/features/trading/domain/execution_engine.dart << 'EOF'
import 'lot_manager.dart';

class ExecutionEngine {
  final LotManager lotManager;

  ExecutionEngine(this.lotManager);

  void executeBuy(String symbol) {
    final lot = lotManager.current;
    print("Executing BUY $symbol @ lot $lot");
    // TODO: تنفيذ الصفقة
  }
}
EOF
cat > lib/features/account/domain/account_model.dart << 'EOF'
class AccountModel {
  double balance;
  double equity;
  double marginUsed = 0;
  double leverage = 100;

  AccountModel({
    required this.balance,
    required this.equity,
    this.leverage = 100,
  });

  double get availableMargin => equity - marginUsed;

  bool canOpen(double lotSize, double price) {
    final required = (lotSize * price) / leverage;
    return required <= availableMargin;
  }

  void openPosition(double lotSize, double price) {
    final required = (lotSize * price) / leverage;
    if (!canOpen(lotSize, price)) throw Exception("Insufficient margin");
    marginUsed += required;
  }

  void closePosition(double lotSize, double price) {
    final released = (lotSize * price) / leverage;
    marginUsed -= released;
  }
}
EOF
cat > lib/features/trading/domain/slippage_model.dart << 'EOF'
import 'dart:math';

class SlippageModel {
  double maxSlippage = 0.0005;

  double apply(double intendedPrice) {
    final slip = Random().nextDouble() * maxSlippage;
    return intendedPrice + slip;
  }
}
EOF
cat > lib/features/trading/domain/slipped_execution.dart << 'EOF'
import 'slippage_model.dart';

class SlippedExecution {
  final SlippageModel slippage;

  SlippedExecution(this.slippage);

  double execute(double intendedPrice) {
    return slippage.apply(intendedPrice);
  }
}
EOF
cat > lib/core/models/price/spread_model.dart << 'EOF'
class SpreadModel {
  final double bid;
  final double ask;

  SpreadModel({required this.bid, required this.ask});

  double get spread => ask - bid;
}
EOF
cat > lib/features/trading/domain/order/order.dart << 'EOF'
enum OrderStatus { pending, partiallyFilled, filled, rejected }

class Order {
  final String id;
  final String symbol;
  final double requestedLots;
  double filledLots;
  final double price;
  OrderStatus status;

  Order({
    required this.id,
    required this.symbol,
    required this.requestedLots,
    required this.filledLots,
    required this.price,
    this.status = OrderStatus.pending,
  });

  double get remainingLots => requestedLots - filledLots;

  void fill(double lots) {
    filledLots += lots;
    if (filledLots >= requestedLots) {
      filledLots = requestedLots;
      status = OrderStatus.filled;
    } else {
      status = OrderStatus.partiallyFilled;
    }
  }
}
EOF
cat > lib/features/trading/domain/order/partial_execution_engine.dart << 'EOF'
import 'dart:math';
import 'order.dart';

class PartialExecutionEngine {
  final Random _rng = Random();

  Order execute(Order order) {
    // محاكاة تنفيذ جزئي
    final fill = order.requestedLots * (0.5 + _rng.nextDouble() * 0.5);

    order.fill(fill);
    return order;
  }
}
EOF
cat > lib/features/trading/domain/errors/execution_error.dart << 'EOF'
enum ExecutionErrorType {
  network,
  insufficientMargin,
  rejectedByBroker,
  timeout,
}

class ExecutionError implements Exception {
  final ExecutionErrorType type;
  final String message;

  ExecutionError(this.type, this.message);
}
EOF
cat > lib/features/trading/domain/order/retriable_execution_engine.dart << 'EOF'
import 'dart:async';
import '../errors/execution_error.dart';
import 'order.dart';

class RetriableExecutionEngine {
  Future<Order> executeWithRetry(
    Order order, {
    int maxRetries = 3,
  }) async {
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        // هنا مكان ربط الـ API الحقيقي لاحقًا
        if (attempt == 0) throw ExecutionError(ExecutionErrorType.network, "Timeout");

        order.status = OrderStatus.filled;
        return order;
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      }
    }
    throw ExecutionError(ExecutionErrorType.timeout, "Max retries exceeded");
  }
}
EOF
cat > lib/features/trading/domain/order/order.dart << 'EOF'
enum OrderStatus { pending, partiallyFilled, filled, rejected }

class Order {
  final String id;
  final String symbol;
  final double requestedLots;
  double filledLots;
  final double price;
  final DateTime createdAt;
  DateTime? executedAt;
  OrderStatus status;

  Order({
    required this.id,
    required this.symbol,
    required this.requestedLots,
    required this.filledLots,
    required this.price,
    DateTime? createdAt,
    this.executedAt,
    this.status = OrderStatus.pending,
  }) : createdAt = createdAt ?? DateTime.now().toUtc();

  double get remainingLots => requestedLots - filledLots;

  void markExecuted() {
    executedAt = DateTime.now().toUtc();
    status = OrderStatus.filled;
  }
}
EOF
cat > lib/features/trading/domain/history/trade_history.dart << 'EOF'
class TradeHistory {
  final List<String> events = [];

  void log(String event) {
    events.add("${DateTime.now().toUtc().toIso8601String()} | $event");
  }
}
EOF
cat > lib/features/trading/domain/audit/reject_logger.dart << 'EOF'
class RejectLogger {
  final List<String> rejected = [];

  void log(String orderId, String reason) {
    rejected.add("${DateTime.now().toUtc().toIso8601String()} | $orderId | $reason");
  }
}
EOF
cat > lib/core/models/dto/candle_dto.dart << 'EOF'
class CandleDto {
  final String time;
  final String open;
  final String high;
  final String low;
  final String close;
  final String volume;

  CandleDto({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory CandleDto.fromJson(Map<String, dynamic> json) {
    return CandleDto(
      time: json['time'],
      open: json['o'],
      high: json['h'],
      low: json['l'],
      close: json['c'],
      volume: json['v'],
    );
  }
}
EOF
cat > lib/features/market/domain/repository/market_repository.dart << 'EOF'
import '../../../../core/models/candle_entity.dart';

abstract class MarketRepository {
  Future<List<CandleEntity>> getCandles(String symbol, String timeframe);
  Stream<CandleEntity> streamCandles(String symbol, String timeframe);
}
EOF
cat > lib/features/market/data/repository/market_repository_impl.dart << 'EOF'
import '../../../domain/repository/market_repository.dart';
import '../../../../core/models/candle_entity.dart';

class MarketRepositoryImpl implements MarketRepository {
  @override
  Future<List<CandleEntity>> getCandles(String symbol, String timeframe) async {
    // التنفيذ عبر REST
    throw UnimplementedError();
  }

  @override
  Stream<CandleEntity> streamCandles(String symbol, String timeframe) {
    // التنفيذ عبر WebSocket
    throw UnimplementedError();
  }
}
EOF
cat > lib/features/trading/domain/interface/trading_engine.dart << 'EOF'
import '../order/order.dart';

abstract class TradingEngine {
  Future<Order> sendOrder(Order order);
  void cancelOrder(String orderId);
  List<Order> activeOrders();
}
EOF
cat > lib/features/trading/domain/usecases/place_order_usecase.dart << 'EOF'
import '../interface/trading_engine.dart';
import '../order/order.dart';

class PlaceOrderUseCase {
  final TradingEngine engine;

  PlaceOrderUseCase(this.engine);

  Future<Order> call(Order order) => engine.sendOrder(order);
}
EOF
cat > lib/core/async/dispatcher.dart << 'EOF'
import 'dart:async';
import 'package:flutter/foundation.dart';

class Dispatcher {
  static Future<T> computeAsync<T>(FutureOr<T> Function() fn) {
    return compute(_wrap, fn);
  }

  static T _wrap<T>(FutureOr<T> Function() fn) => fn();
}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_state.dart << 'EOF'
import '../../../../core/models/candle_entity.dart';

abstract class ChartState {}

class ChartIdle extends ChartState {}

class ChartLoading extends ChartState {}

class ChartLoaded extends ChartState {
  final List<CandleEntity> candles;
  final DateTime from;
  final DateTime to;

  ChartLoaded(this.candles, this.from, this.to);
}

class ChartLiveUpdated extends ChartState {
  final CandleEntity latest;
  ChartLiveUpdated(this.latest);
}

class ChartError extends ChartState {
  final String message;
  ChartError(this.message);
}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_event.dart << 'EOF'
abstract class ChartEvent {}

class LoadChartHistory extends ChartEvent {
  final String symbol;
  final String timeframe;
  final DateTime from;
  final DateTime to;

  LoadChartHistory(this.symbol, this.timeframe, this.from, this.to);
}

class AppendLiveCandle extends ChartEvent {
  final CandleEntity newCandle;
  AppendLiveCandle(this.newCandle);
}
EOF
cat > lib/features/backtest/domain/backtest_controller.dart << 'EOF'
import 'dart:async';

class BacktestController {
  bool _cancelled = false;

  bool get isCancelled => _cancelled;

  void cancel() {
    _cancelled = true;
  }
}
EOF
cat > lib/features/common/data/cache/bloc_state_cache.dart << 'EOF'
import 'package:hive/hive.dart';

class BlocStateCache {
  final Box box;

  BlocStateCache(this.box);

  void save(String key, dynamic data) => box.put(key, data);
  dynamic load(String key) => box.get(key);
}
EOF
cat > lib/core/network/websocket/ping_manager.dart << 'EOF'
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class PingManager {
  final WebSocketChannel channel;
  late Timer _timer;

  PingManager(this.channel);

  void start() {
    _timer = Timer.periodic(Duration(seconds: 20), (_) {
      channel.sink.add('ping');
    });
  }

  void stop() {
    _timer.cancel();
  }
}
EOF
cat > lib/core/network/websocket/message_verifier.dart << 'EOF'
class MessageVerifier {
  int? lastId;

  bool isInOrder(int newId) {
    if (lastId == null) {
      lastId = newId;
      return true;
    }

    if (newId > lastId!) {
      lastId = newId;
      return true;
    }

    return false; // out-of-order
  }
}
EOF
cat > lib/features/market/data/cache/tick_buffer.dart << 'EOF'
import '../../../core/models/tick_entity.dart';

class TickBuffer {
  final List<TickEntity> buffer = [];

  void add(TickEntity t) => buffer.add(t);

  List<TickEntity> flush() {
    final copy = List<TickEntity>.from(buffer);
    buffer.clear();
    return copy;
  }
}
EOF
cat > lib/core/network/fallback_manager.dart << 'EOF'
enum SourceStatus { healthy, degraded, offline }

class FallbackManager {
  SourceStatus status = SourceStatus.healthy;

  void markDegraded() => status = SourceStatus.degraded;
  void markOffline() => status = SourceStatus.offline;
  void markHealthy() => status = SourceStatus.healthy;

  bool shouldUseRest() => status != SourceStatus.healthy;
}
EOF
cat > lib/features/market/domain/sync/market_sync_coordinator.dart << 'EOF'
import '../../../core/models/candle_entity.dart';
import '../../../core/models/tick_entity.dart';

typedef TickListener = void Function(TickEntity tick);
typedef CandleListener = void Function(CandleEntity candle);

class MarketSyncCoordinator {
  final _tickListeners = <TickListener>[];
  final _candleListeners = <CandleListener>[];

  void registerTickListener(TickListener listener) => _tickListeners.add(listener);
  void registerCandleListener(CandleListener listener) => _candleListeners.add(listener);

  void dispatchTick(TickEntity tick) {
    for (final l in _tickListeners) {
      l(tick);
    }
  }

  void dispatchCandle(CandleEntity candle) {
    for (final l in _candleListeners) {
      l(candle);
    }
  }
}
EOF
cat > lib/features/indicators/domain/visible_range_engine.dart << 'EOF'
import '../../../core/models/candle_entity.dart';

class VisibleRangeEngine {
  List<CandleEntity> applyVisibleRange(
    List<CandleEntity> candles,
    DateTime from,
    DateTime to,
  ) {
    return candles.where((c) => c.timeUtc.isAfter(from) && c.timeUtc.isBefore(to)).toList();
  }
}
EOF
cat > lib/features/indicators/domain/live_indicator_updater.dart << 'EOF'
import '../../../core/models/tick_entity.dart';
import '../../../core/models/candle_entity.dart';

class LiveIndicatorUpdater {
  CandleEntity _current = CandleEntity(...); // يبدأ من آخر شمعة

  void onTick(TickEntity tick) {
    // تحديث High/Low/Close لحظيًا
    final mid = (tick.price.ask + tick.price.bid) / 2;
    _current = CandleEntity(
      instrument: _current.instrument,
      timeUtc: _current.timeUtc,
      open: _current.open,
      high: mid > _current.high ? mid : _current.high,
      low: mid < _current.low ? mid : _current.low,
      close: mid,
      volume: _current.volume + 1,
    );

    // إرسال المؤشرات للمراقبين
  }
}
EOF
cat > lib/features/indicators/domain/sync_aligner.dart << 'EOF'
class SyncAligner {
  final Duration bufferDelay = Duration(milliseconds: 500);

  DateTime align(DateTime input) {
    return input.add(bufferDelay);
  }
}
EOF
cat > lib/features/chart/domain/tools/drawing_tool_sync.dart << 'EOF'
class DrawingToolSync {
  double mapPriceToY({
    required double price,
    required double minPrice,
    required double maxPrice,
    required double height,
  }) {
    return height * (maxPrice - price) / (maxPrice - minPrice);
  }

  double mapTimeToX({
    required DateTime time,
    required DateTime start,
    required DateTime end,
    required double width,
  }) {
    final total = end.difference(start).inMilliseconds.toDouble();
    final delta = time.difference(start).inMilliseconds.toDouble();
    return width * (delta / total);
  }
}
EOF
cat > lib/core/storage/hive/hive_migration.dart << 'EOF'
import 'package:hive/hive.dart';

Future<void> performMigration(Box box, int fromVersion, int toVersion) async {
  if (fromVersion < 2 && toVersion >= 2) {
    // نقل بيانات أو تحديث schema
    final all = box.toMap();
    for (var k in all.keys) {
      final entry = all[k];
      if (entry is Map && !entry.containsKey('volume')) {
        entry['volume'] = '0';
        await box.put(k, entry);
      }
    }
  }
}
EOF
cat > lib/core/storage/safe_storage.dart << 'EOF'
import 'package:hive/hive.dart';

class SafeStorage {
  final Box box;

  SafeStorage(this.box);

  T? read<T>(String key) {
    try {
      return box.get(key) as T?;
    } catch (e) {
      return null;
    }
  }

  Future<void> write<T>(String key, T value) async {
    try {
      await box.put(key, value);
    } catch (e) {
      print("Storage error: $e");
    }
  }
}
EOF
cat > lib/features/market/data/cache/candle_cache_cleaner.dart << 'EOF'
import '../../../core/models/candle_entity.dart';

class CandleCacheCleaner {
  final int maxSize;

  CandleCacheCleaner({this.maxSize = 1000});

  List<CandleEntity> clean(List<CandleEntity> candles) {
    if (candles.length <= maxSize) return candles;
    return candles.sublist(candles.length - maxSize);
  }
}
EOF
cat > lib/core/storage/hive/compactor.dart << 'EOF'
import 'package:hive/hive.dart';

Future<void> compactIfNeeded(Box box) async {
  if (box.length > 1000) {
    await box.compact();
  }
}
EOF
cat > lib/core/storage/usage_monitor.dart << 'EOF'
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageUsageMonitor {
  Future<int> calculateUsedBytes() async {
    final dir = await getApplicationDocumentsDirectory();
    int total = 0;
    await for (var file in dir.list(recursive: true)) {
      if (file is File) {
        total += await file.length();
      }
    }
    return total;
  }
}
EOF
cat > lib/features/indicators/engine/indicator_engine.dart << 'EOF'
import '../../../core/models/candle_entity.dart';

abstract class IndicatorPlugin {
  Map<String, double> compute(List<CandleEntity> candles);
}

class IndicatorEngine {
  final List<IndicatorPlugin> plugins;

  IndicatorEngine(this.plugins);

  Map<String, double> calculate(List<CandleEntity> candles) {
    final result = <String, double>{};
    for (final plugin in plugins) {
      result.addAll(plugin.compute(candles));
    }
    return result;
  }
}
EOF
cat > lib/features/indicators/plugins/ema_plugin.dart << 'EOF'
import '../../engine/indicator_engine.dart';
import '../../../../core/models/candle_entity.dart';

class EMAPlugin implements IndicatorPlugin {
  final int period;
  double? prevEma;

  EMAPlugin(this.period);

  @override
  Map<String, double> compute(List<CandleEntity> candles) {
    final prices = candles.map((e) => e.close).toList();
    final multiplier = 2 / (period + 1);
    double? ema = prevEma ?? prices.first;

    for (final price in prices) {
      ema = (price - ema!) * multiplier + ema;
    }

    prevEma = ema;
    return {'EMA$period': ema ?? 0};
  }
}
EOF
cat > lib/features/indicators/engine/zoom_sensitive_engine.dart << 'EOF'
import '../../../core/models/candle_entity.dart';
import 'indicator_engine.dart';

class ZoomSensitiveEngine extends IndicatorEngine {
  ZoomSensitiveEngine(super.plugins);

  Map<String, double> calculateInRange(
      List<CandleEntity> all, DateTime from, DateTime to) {
    final visible = all.where((c) => c.timeUtc.isAfter(from) && c.timeUtc.isBefore(to)).toList();
    return super.calculate(visible);
  }
}
EOF
cat > assets/js/chart_extension.js << 'EOF'
// تُستدعى من Flutter
function addIndicatorSeries(name, dataPoints) {
  const series = chart.addLineSeries({ color: '#00bcd4' });
  series.setData(dataPoints);
}
EOF
cat > test/performance/indicator_perf_test.dart << 'EOF'
import 'package:test/test.dart';
import '../../../lib/features/indicators/engine/indicator_engine.dart';
import '../../../lib/features/indicators/plugins/ema_plugin.dart';

void main() {
  test('EMA performance on 50k candles', () {
    final candles = List.generate(
      50000,
      (i) => CandleEntity(...), // mock data
    );

    final engine = IndicatorEngine([EMAPlugin(50)]);

    final sw = Stopwatch()..start();
    final result = engine.calculate(candles);
    sw.stop();

    print("Execution time: ${sw.elapsedMilliseconds} ms");

    expect(sw.elapsedMilliseconds < 300, true); // أقل من 300ms
  });
}
EOF
cat > lib/core/navigation/fade_route.dart << 'EOF'
import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute(this.page)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
}
EOF
cat > lib/core/widgets/shimmer_placeholder.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPlaceholder extends StatelessWidget {
  final double height;
  final double width;

  ShimmerPlaceholder({this.height = 100, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        color: Colors.white,
      ),
    );
  }
}
EOF
cat > lib/core/network/error_handler.dart << 'EOF'
class NetworkErrorHandler {
  static String parseError(dynamic error) {
    if (error.toString().contains('SocketException')) return "انقطع الاتصال بالإنترنت.";
    if (error.toString().contains('TimeoutException')) return "انتهت مهلة الاتصال.";
    return "حدث خطأ غير متوقع. حاول لاحقاً.";
  }
}
EOF
cat > lib/core/widgets/notification_toast.dart << 'EOF'
import 'package:fluttertoast/fluttertoast.dart';

class NotificationToast {
  static void show(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
EOF
cat > lib/core/audio/alert_sound.dart << 'EOF'
import 'package:audioplayers/audioplayers.dart';

class AlertSound {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playBuy() => _player.play(AssetSource('audio/buy.mp3'));
  Future<void> playSell() => _player.play(AssetSource('audio/sell.mp3'));
}
EOF
cat > lib/core/theme/app_theme.dart << 'EOF'
import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
  );

  static final dark = ThemeData.dark().copyWith(
    primaryColor: Colors.blueGrey,
    brightness: Brightness.dark,
  );
}
EOF
cat > lib/features/settings/domain/chart_style_settings.dart << 'EOF'
class ChartStyleSettings {
  String candleUpColor = "#00ff00";
  String candleDownColor = "#ff0000";
  String emaColor = "#00bcd4";
}
EOF
cat > lib/core/storage/preferences.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDark);
  }

  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('darkMode') ?? false;
  }
}
EOF
cat > lib/features/settings/domain/trading_profile.dart << 'EOF'
class TradingProfile {
  final String name;
  final double riskPercent;
  final double lotSize;

  TradingProfile({
    required this.name,
    required this.riskPercent,
    required this.lotSize,
  });
}
EOF
cat > lib/features/settings/presentation/settings_screen.dart << 'EOF'
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الإعدادات")),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text("الوضع الليلي"),
            value: true,
            onChanged: (val) {},
          ),
          ListTile(
            title: Text("لون الشمعة الصاعدة"),
            trailing: CircleAvatar(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }
}
EOF
cat > lib/features/alerts/domain/alert_condition.dart << 'EOF'
class AlertCondition {
  final String indicator;
  final String operator; // ex: <, >, <=
  final double threshold;
  final Duration duration; // e.g., trigger if condition holds for 2 minutes

  AlertCondition({
    required this.indicator,
    required this.operator,
    required this.threshold,
    required this.duration,
  });
}
EOF
cat > lib/features/alerts/domain/alert_engine.dart << 'EOF'
import 'alert_condition.dart';

class AlertEngine {
  final List<AlertCondition> conditions;
  final Map<String, DateTime> _startMap = {};

  AlertEngine(this.conditions);

  List<String> evaluate(Map<String, double> indicatorValues) {
    final now = DateTime.now();
    final triggered = <String>[];

    for (final cond in conditions) {
      final value = indicatorValues[cond.indicator] ?? 0;
      final satisfied = _compare(value, cond.operator, cond.threshold);

      final key = cond.indicator + cond.operator + cond.threshold.toString();
      if (satisfied) {
        _startMap.putIfAbsent(key, () => now);
        if (now.difference(_startMap[key]!) >= cond.duration) {
          triggered.add('${cond.indicator} ${cond.operator} ${cond.threshold}');
        }
      } else {
        _startMap.remove(key);
      }
    }

    return triggered;
  }

  bool _compare(double v, String op, double t) {
    switch (op) {
      case '>': return v > t;
      case '<': return v < t;
      case '>=': return v >= t;
      case '<=': return v <= t;
      case '==': return v == t;
      default: return false;
    }
  }
}
EOF
cat > lib/features/alerts/presentation/alert_notifier.dart << 'EOF'
import '../../../core/widgets/notification_toast.dart';
import '../../../core/audio/alert_sound.dart';

class AlertNotifier {
  final _sound = AlertSound();

  void trigger(String message) {
    NotificationToast.show(message);
    _sound.playBuy(); // مثال: صوت موحد
  }
}
EOF
cat > lib/features/alerts/data/alert_log_repository.dart << 'EOF'
import 'package:hive/hive.dart';

class AlertLogRepository {
  static Future<void> log(String msg) async {
    final box = await Hive.openBox('alertLogs');
    await box.add({'msg': msg, 'timestamp': DateTime.now().toIso8601String()});
  }

  static Future<List<Map>> getLogs() async {
    final box = await Hive.openBox('alertLogs');
    return box.values.cast<Map>().toList();
  }
}
EOF
cat > lib/features/alerts/presentation/alert_log_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import '../data/alert_log_repository.dart';

class AlertLogScreen extends StatefulWidget {
  @override
  _AlertLogScreenState createState() => _AlertLogScreenState();
}

class _AlertLogScreenState extends State<AlertLogScreen> {
  List<Map> logs = [];

  @override
  void initState() {
    super.initState();
    AlertLogRepository.getLogs().then((value) => setState(() => logs = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("سجل التنبيهات")),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(logs[i]['msg']),
          subtitle: Text(logs[i]['timestamp']),
        ),
      ),
    );
  }
}
EOF
cat > lib/features/indicators/presentation/indicator_selector.dart << 'EOF'
import 'package:flutter/material.dart';

class IndicatorSelector extends StatelessWidget {
  final Function(String) onSelect;

  IndicatorSelector({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final indicators = ["EMA", "RSI", "Stochastic", "MACD"];

    return BottomSheet(
      onClosing: () {},
      builder: (ctx) => ListView(
        children: indicators.map((ind) => ListTile(
          title: Text(ind),
          onTap: () => onSelect(ind),
        )).toList(),
      ),
    );
  }
}
EOF
cat > lib/features/strategy/domain/strategy_model.dart << 'EOF'
class StrategyModel {
  final List<String> requiredSignals;
  final String action; // BUY / SELL

  StrategyModel({
    required this.requiredSignals,
    required this.action,
  });

  bool canTrigger(List<String> activeSignals) {
    return requiredSignals.every((sig) => activeSignals.contains(sig));
  }
}
EOF
cat > lib/features/strategy/domain/strategy_engine.dart << 'EOF'
import 'strategy_model.dart';

class StrategyEngine {
  final List<StrategyModel> strategies;

  StrategyEngine(this.strategies);

  String? evaluate(List<String> activeSignals) {
    for (final strategy in strategies) {
      if (strategy.canTrigger(activeSignals)) return strategy.action;
    }
    return null;
  }
}
EOF
cat > assets/js/zone_overlay.js << 'EOF'
// يستدعيها Flutter عندما يحصل تنبيه
function highlightZone(fromTs, toTs, color = '#ffc107') {
  chart.addAreaSeries({
    topColor: color,
    bottomColor: color + "33",
    lineColor: color,
    lineWidth: 1,
  }).setData([
    { time: fromTs, value: 1 },
    { time: toTs, value: 1 }
  ]);
}
EOF
cat > lib/features/chart/domain/chart_zones_repository.dart << 'EOF'
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
EOF
cat > lib/features/analytics/domain/trade_statistics.dart << 'EOF'
import '../../../features/trading/domain/order/order.dart';

class TradeStatistics {
  final List<Order> orders;

  TradeStatistics(this.orders);

  double get totalProfit => orders.fold(0.0, (sum, o) => sum + (o.filledLots * o.price));

  double get winRate {
    final wins = orders.where((o) => o.price > 0).length;
    return orders.isEmpty ? 0 : wins / orders.length;
  }

  double get maxDrawdown {
    // مثال تقريبي
    double peak = 0;
    double drawdown = 0;
    double equity = 0;
    for (var o in orders) {
      equity += o.price;
      if (equity > peak) peak = equity;
      drawdown = peak - equity;
    }
    return drawdown;
  }
}
EOF
cat > assets/js/equity_curve.js << 'EOF'
function drawEquityCurve(points) {
  const series = chart.addLineSeries({ color: '#2196f3' });
  series.setData(points);
}
EOF
cat > lib/features/analytics/domain/strategy_comparer.dart << 'EOF'
import 'trade_statistics.dart';

class StrategyComparer {
  final TradeStatistics a, b;

  StrategyComparer(this.a, this.b);

  String compare() {
    if (a.totalProfit > b.totalProfit) return "A أفضل";
    if (b.totalProfit > a.totalProfit) return "B أفضل";
    return "متعادلان";
  }
}
EOF
cat > lib/core/markets/market_definitions.dart << 'EOF'
enum MarketType { forex, crypto, commodity, stock }

class Instrument {
  final String symbol;
  final MarketType type;

  Instrument(this.symbol, this.type);
}
EOF
cat > lib/core/network/markets_api.dart << 'EOF'
import 'rest_client.dart';
import '../models/dto/instrument_dto.dart';

class MarketsApi {
  final RestClient client;

  MarketsApi(this.client);

  Future<List<InstrumentDto>> fetchAll() async {
    final res = await client.get("/instruments");
    return (res['instruments'] as List)
        .map((j) => InstrumentDto.fromJson(j))
        .toList();
  }
}
EOF
cat > lib/core/markets/filter.dart << 'EOF'
import 'market_definitions.dart';

class MarketFilter {
  static List<Instrument> byType(List<Instrument> list, MarketType type) =>
      list.where((i) => i.type == type).toList();
}
EOF
cat > lib/features/market/presentation/screens/market_info_screen.dart << 'EOF'
import 'package:flutter/material.dart';

class MarketInfoScreen extends StatelessWidget {
  final String symbol;
  final String description;

  MarketInfoScreen(this.symbol, this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(symbol)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text("معلومات عن السوق: $description"),
      ),
    );
  }
}
EOF
cat > lib/features/analytics/domain/liquidity_analyzer.dart << 'EOF'
import '../../../core/models/candle_entity.dart';

class LiquidityAnalyzer {
  final List<CandleEntity> candles;

  LiquidityAnalyzer(this.candles);

  double averageRange() {
    return candles.fold(0, (sum, c) => sum + (c.high - c.low)) / candles.length;
  }

  double volatility() {
    return averageRange(); // تبسيط
  }
}
EOF
cat > lib/core/async/batch_computer.dart << 'EOF'
import 'dart:async';

class BatchComputer {
  Future<void> processInBatches<T>(
      List<T> items,
      Future<void> Function(T) action,
      {int batchSize = 1000}) async {
    for (var i = 0; i < items.length; i += batchSize) {
      final batch = items.sublist(i, i + batchSize);
      await Future.wait(batch.map(action));
    }
  }
}
EOF
cat > lib/core/performance/fps_monitor.dart << 'EOF'
import 'package:flutter/scheduler.dart';

class FPSMonitor {
  void start(void Function(int) callback) {
    int lastFrameTime = 0;
    SchedulerBinding.instance.addTimingsCallback((timings) {
      final frameTime = timings.first.totalSpan.inMilliseconds;
      final fps = frameTime == 0 ? 0 : (1000 / frameTime).round();
      callback(fps);
      lastFrameTime = frameTime;
    });
  }
}
EOF
cat > lib/features/trading/data/exchanges/crypto/crypto_api.dart << 'EOF'
import '../../../core/network/rest_client.dart';

class CryptoApi {
  final RestClient client;

  CryptoApi(this.client);

  Future<double> fetchPrice(String symbol) async {
    final res = await client.get("/crypto/$symbol/price");
    return double.parse(res['price']);
  }
}
EOF
cat > lib/features/trading/data/exchanges/stock/stock_api.dart << 'EOF'
import '../../../core/network/rest_client.dart';

class StockApi {
  final RestClient client;

  StockApi(this.client);

  Future<double> fetchQuote(String symbol) async {
    final res = await client.get("/stocks/$symbol/quote");
    return double.parse(res['quote']);
  }
}
EOF
cat > lib/core/time/time_zone_config.dart << 'EOF'
class TimeZoneConfig {
  static const Map<String, int> instrumentOffsets = {
    "BTC_USD": -4, // مثال EDT
    "EUR_USD": 0,  // UTC
    "AAPL": -5     // EST
  };

  static DateTime toLocal(String symbol, DateTime utc) {
    final offset = instrumentOffsets[symbol] ?? 0;
    return utc.add(Duration(hours: offset));
  }
}
EOF
cat > lib/features/market/presentation/bloc/auto_fetch_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/markets_api.dart';
import '../../../core/models/dto/instrument_dto.dart';

class AutoFetchBloc extends Bloc<void, List<InstrumentDto>> {
  final MarketsApi marketsApi;

  AutoFetchBloc(this.marketsApi) : super([]) {
    on((_, emit) async {
      final list = await marketsApi.fetchAll();
      emit(list);
    });
  }
}
EOF
cat > lib/core/markets/search_filter.dart << 'EOF'
import 'market_definitions.dart';

class MarketSearchFilter {
  static List<Instrument> search(List<Instrument> all, String q) {
    return all.where((i) => i.symbol.contains(q.toUpperCase())).toList();
  }

  static List<Instrument> sortByName(List<Instrument> all) {
    all.sort((a, b) => a.symbol.compareTo(b.symbol));
    return all;
  }
}
EOF
cat > lib/features/analytics/domain/risk_analyzer.dart << 'EOF'
import '../../../features/trading/domain/order/order.dart';

class RiskAnalyzer {
  final double accountSize;

  RiskAnalyzer(this.accountSize);

  double riskPerTrade(double stopLossPips) {
    return accountSize * (stopLossPips / 100);
  }

  double lotSize(double riskAmount, double pipValue) {
    return riskAmount / pipValue;
  }
}
EOF
cat > lib/features/trading/presentation/widgets/stop_take_input.dart << 'EOF'
import 'package:flutter/material.dart';

class StopTakeInput extends StatelessWidget {
  final Function(double, double) onApply;

  StopTakeInput({required this.onApply});

  @override
  Widget build(BuildContext context) {
    double sl = 0, tp = 0;
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: "Stop Loss"),
          onChanged: (v) => sl = double.tryParse(v) ?? 0,
        ),
        TextField(
          decoration: InputDecoration(labelText: "Take Profit"),
          onChanged: (v) => tp = double.tryParse(v) ?? 0,
        ),
        ElevatedButton(
          child: Text("Apply"),
          onPressed: () => onApply(sl, tp),
        )
      ],
    );
  }
}
EOF
cat > assets/js/sl_tp_overlay.js << 'EOF'
function drawSLTP(slTime, slPrice, tpTime, tpPrice) {
  chart.createPriceLine({
    price: slPrice,
    color: 'red',
    lineWidth: 1,
    lineStyle: LightweightCharts.LineStyle.Dashed,
  });
  chart.createPriceLine({
    price: tpPrice,
    color: 'green',
    lineWidth: 1,
  });
}
EOF
cat > lib/features/trading/presentation/widgets/signals_panel.dart << 'EOF'
import 'package:flutter/material.dart';

class SignalsPanel extends StatelessWidget {
  final List<String> signals;

  SignalsPanel(this.signals);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: signals.map((s) => Text(s, style: TextStyle(fontSize: 14))).toList(),
    );
  }
}
EOF
cat > lib/features/trading/presentation/widgets/trade_action_button.dart << 'EOF'
import 'package:flutter/material.dart';

class TradeActionButton extends StatelessWidget {
  final String action;
  final VoidCallback onTap;

  TradeActionButton({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isBuy = action.toUpperCase() == "BUY";
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isBuy ? Colors.green : Colors.red,
      ),
      child: Text(action),
      onPressed: onTap,
    );
  }
}
EOF
cat > lib/features/settings/presentation/widgets/color_picker_tile.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerTile extends StatelessWidget {
  final String title;
  final Color current;
  final ValueChanged<Color> onColorChanged;

  ColorPickerTile({
    required this.title,
    required this.current,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: CircleAvatar(backgroundColor: current),
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("اختر اللون"),
          content: BlockPicker(
            pickerColor: current,
            onColorChanged: onColorChanged,
          ),
        ),
      ),
    );
  }
}
EOF
cat > lib/core/storage/indicator/indicator_settings_storage.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class IndicatorSettingsStorageSP {
  static const _key = "indicatorSettings";

  static Future<void> save(String id, Map<String, dynamic> params) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key + id, jsonEncode(params));
  }

  static Future<Map<String, dynamic>?> load(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_key + id);
    return str == null ? null : jsonDecode(str);
  }
}
EOF
cat > lib/core/init/app_initializer.dart << 'EOF'
import 'package:flutter/material.dart';
import '../storage/preferences.dart';
import '../storage/indicator/indicator_settings_storage.dart';

class AppInitializer {
  static Future<void> init() async {
    final isDark = await UserPreferences.loadTheme();
    // إعداد الثيم
    // تحميل إعدادات المؤشرات
  }
}
EOF
cat > lib/features/strategy/domain/dsl/strategy_dsl.dart << 'EOF'
class StrategyDSLParser {
  /// مثال: "EMA50 > EMA150 AND RSI14 < 30"
  static List<String> tokenize(String expr) =>
      expr.split(RegExp(r"\s+")).toList();
}
EOF
cat > lib/features/strategy/presentation/widgets/strategy_dsl_editor.dart << 'EOF'
import 'package:flutter/material.dart';

class StrategyDslEditor extends StatefulWidget {
  final String initial;
  final ValueChanged<String> onChanged;

  StrategyDslEditor({required this.initial, required this.onChanged});

  @override
  _StrategyDslEditorState createState() => _StrategyDslEditorState();
}

class _StrategyDslEditorState extends State<StrategyDslEditor> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      decoration: InputDecoration(labelText: "Strategy Expression"),
      onSubmitted: widget.onChanged,
    );
  }
}
EOF
cat > lib/core/export/csv_exporter.dart << 'EOF'
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
EOF
cat > lib/core/integration/webhook_handler.dart << 'EOF'
typedef WebhookHandlerFunc = Future<void> Function(Map<String, dynamic>);

class WebhookHandler {
  final Map<String, WebhookHandlerFunc> handlers = {};

  void register(String event, WebhookHandlerFunc fn) => handlers[event] = fn;

  Future<void> handle(String event, Map<String, dynamic> body) async {
    if (handlers.containsKey(event)) await handlers[event]!(body);
  }
}
EOF
cat > lib/core/integration/telegram/telegram_bot.dart << 'EOF'
import 'package:telebot/telebot.dart';

class TelegramBot {
  final String token;
  final Telebot _bot;

  TelegramBot(this.token) : _bot = Telebot(token);

  void start() {
    _bot.start();
    _bot.onMessage((msg) {
      print("Telegram Msg: ${msg.text}");
    });
  }
}
EOF
cat > lib/core/export/pdf/pdf_report.dart << 'EOF'
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfReport {
  static Future<List<int>> generate(List<String> lines) async {
    final pdf = Document();
    pdf.addPage(Page(build: (_) {
      return Column(children: lines.map((l) => Text(l)).toList());
    }));
    return pdf.save();
  }
}
EOF
cat > lib/features/alerts/data/alert_preferences.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AlertPreferences {
  static Future<void> save(String id, Map<String, dynamic> cfg) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("alert_$id", jsonEncode(cfg));
  }

  static Future<Map<String, dynamic>?> load(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString("alert_$id");
    return str == null ? null : jsonDecode(str);
  }
}
EOF
cat > lib/core/sync/cloud/cloud_sync_service.dart << 'EOF'
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// يمكن استبدال بـ Firebase/Backend حقيقي لاحقًا

class CloudSyncService {
  static Future<void> uploadUserSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("cloud_user_settings", jsonEncode(settings));
  }

  static Future<Map<String, dynamic>?> downloadUserSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString("cloud_user_settings");
    return str == null ? null : jsonDecode(str);
  }
}
EOF
cat > lib/core/export/settings/json_settings_exporter.dart << 'EOF'
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
EOF
cat > lib/core/notifications/firebase_messaging_service.dart << 'EOF'
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    await _fcm.requestPermission();
    FirebaseMessaging.onMessage.listen((msg) {
      // Handle foreground
    });
  }

  Future<String?> getToken() => _fcm.getToken();
}
EOF
cat > lib/core/integration/webhook_push_bridge.dart << 'EOF'
import '../notifications/firebase_messaging_service.dart';

class WebhookPushBridge {
  final FirebaseMessagingService fcm;

  WebhookPushBridge(this.fcm);

  Future<void> sendPushOnWebhook(Map<String, dynamic> body) async {
    final token = await fcm.getToken();
    if (token != null) {
      // تنفيذ POST لFCM API (Server Side)
    }
  }
}
EOF
cat > lib/core/telemetry/sentry_service.dart << 'EOF'
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryService {
  static Future<void> init() async {
    await SentryFlutter.init(
      (options) => options.dsn = 'YOUR_SENTRY_DSN_HERE',
    );
  }
}
EOF
cat > lib/core/log/logger_service.dart << 'EOF'
import 'package:logger/logger.dart';

class LoggerService {
  static final Logger _logger = Logger();

  static void d(String msg) => _logger.d(msg);
  static void e(String msg, [dynamic err]) => _logger.e(msg, err);
  static void i(String msg) => _logger.i(msg);
}
EOF
cat > lib/features/strategy/domain/undo_redo_manager.dart << 'EOF'
class UndoRedoManager<T> {
  final List<T> _stack = [];
  int _pointer = -1;

  void add(T state) {
    _stack.removeRange(_pointer + 1, _stack.length);
    _stack.add(state);
    _pointer++;
  }

  T? undo() => _pointer > 0 ? _stack[--_pointer] : null;
  T? redo() => _pointer < _stack.length - 1 ? _stack[++_pointer] : null;
}
EOF
cat > lib/core/permissions/permission_manager.dart << 'EOF'
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<bool> requestStorage() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  static Future<bool> requestNotifications() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }
}
EOF
cat > lib/core/storage/audit/event_audit_manager.dart << 'EOF'
import 'package:hive/hive.dart';

class EventAuditManager {
  static Future<void> log(String event) async {
    final box = await Hive.openBox('eventAudit');
    await box.add({'event': event, 'timestamp': DateTime.now().toIso8601String()});
  }

  static Future<List<Map>> getAll() async {
    final box = await Hive.openBox('eventAudit');
    return box.values.cast<Map>().toList();
  }
}
EOF
cat > lib/features/dashboard/presentation/dashboard_screen.dart << 'EOF'
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("إجمالي الأرباح"),
          Text("مجموع الصفقات"),
          Text("أعلى Drawdown"),
        ],
      ),
    );
  }
}
EOF
cat > lib/features/replay/domain/replay_state.dart << 'EOF'
enum ReplayPlaybackState {
  idle,
  playing,
  paused,
  ended,
}
EOF
cat > lib/features/replay/domain/replay_engine.dart << 'EOF'
import '../../../core/models/candle_entity.dart';

typedef ReplayTickCallback = void Function(CandleEntity);

class ReplayEngine {
  final List<CandleEntity> history;
  int _index = 0;
  bool _isPlaying = false;
  Duration _speedFactor = Duration(milliseconds: 500); // 2x real

  ReplayEngine(this.history);

  void play(ReplayTickCallback onTick) async {
    _isPlaying = true;
    while (_isPlaying && _index < history.length) {
      onTick(history[_index]);
      await Future.delayed(_speedFactor);
      _index++;
    }
  }

  void pause() => _isPlaying = false;

  void resume(ReplayTickCallback onTick) => play(onTick);

  void stop() {
    _isPlaying = false;
    _index = 0;
  }

  void setSpeed(double factor) {
    _speedFactor = Duration(milliseconds: (1000 / factor).round());
  }
}
EOF
cat > lib/features/replay/presentation/bloc/replay_event.dart << 'EOF'
abstract class ReplayEvent {}
class StartReplay extends ReplayEvent {
  final DateTime from;
  final DateTime to;
  final double speed;

  StartReplay({required this.from, required this.to, this.speed = 1});
}
class PauseReplay extends ReplayEvent {}
class ResumeReplay extends ReplayEvent {}
class StopReplay extends ReplayEvent {}
EOF
cat > lib/features/replay/presentation/bloc/replay_state.dart << 'EOF'
import '../../../domain/replay_state.dart';

abstract class ReplayStatus {}
class ReplayIdle extends ReplayStatus {}
class ReplayPlaying extends ReplayStatus {}
class ReplayPaused extends ReplayStatus {}
class ReplayEnded extends ReplayStatus {}
EOF
cat > lib/features/replay/presentation/bloc/replay_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'replay_event.dart';
import 'replay_state.dart';
import '../../../domain/replay_engine.dart';
import '../../../domain/replay_state.dart';

class ReplayBloc extends Bloc<ReplayEvent, ReplayStatus> {
  ReplayEngine? engine;

  ReplayBloc() : super(ReplayIdle()) {
    on<StartReplay>(_onStart);
    on<PauseReplay>((_, emit) => emit(ReplayPaused()));
    on<ResumeReplay>((_, emit) => emit(ReplayPlaying()));
    on<StopReplay>((_, emit) => emit(ReplayEnded()));
  }

  void _onStart(StartReplay event, Emitter<ReplayStatus> emit) async {
    // load history from repo
    engine = ReplayEngine([]);
    engine!.setSpeed(event.speed);
    emit(ReplayPlaying());
    engine!.play((c) {
      // dispatch to chart Bloc
    });
  }
}
EOF
cat > lib/features/replay/presentation/widgets/replay_controls.dart << 'EOF'
import 'package:flutter/material.dart';

class ReplayControls extends StatelessWidget {
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onStop;

  ReplayControls({
    required this.onPlay,
    required this.onPause,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(icon: Icon(Icons.play_arrow), onPressed: onPlay),
        IconButton(icon: Icon(Icons.pause), onPressed: onPause),
        IconButton(icon: Icon(Icons.stop), onPressed: onStop),
      ],
    );
  }
}
EOF
cat > lib/features/market_depth/domain/order_book.dart << 'EOF'
class OrderBookLevel {
  final double price;
  final double volume;
  OrderBookLevel(this.price, this.volume);
}

class OrderBook {
  final List<OrderBookLevel> bids;
  final List<OrderBookLevel> asks;

  OrderBook({required this.bids, required this.asks});
}
EOF
cat > lib/features/market_depth/data/order_book_ws.dart << 'EOF'
import '../../../core/network/ws_manager.dart';
import '../domain/order_book.dart';

class OrderBookWs {
  final WSManager ws;
  OrderBookWs(this.ws);

  void listen(void Function(OrderBook) onUpdate) {
    ws.stream.listen((data) {
      final bids = <OrderBookLevel>[];
      final asks = <OrderBookLevel>[];
      for (var b in data['bids']) {
        bids.add(OrderBookLevel(b[0], b[1]));
      }
      for (var a in data['asks']) {
        asks.add(OrderBookLevel(a[0], a[1]));
      }
      onUpdate(OrderBook(bids: bids, asks: asks));
    });
  }
}
EOF
cat > lib/features/market_depth/presentation/widgets/order_book_view.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../domain/order_book.dart';

class OrderBookView extends StatelessWidget {
  final OrderBook book;
  OrderBookView(this.book);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: ListView(
          children: book.bids.map((l) => Text("Bid ${l.price}: ${l.volume}")).toList(),
        )),
        Expanded(child: ListView(
          children: book.asks.map((l) => Text("Ask ${l.price}: ${l.volume}")).toList(),
        )),
      ],
    );
  }
}
EOF
cat > lib/features/market_depth/presentation/bloc/order_book_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/order_book.dart';

abstract class OrderBookEvent {}
class OrderBookUpdate extends OrderBookEvent {
  final OrderBook book;
  OrderBookUpdate(this.book);
}

abstract class OrderBookState {}
class OrderBookInitial extends OrderBookState {}
class OrderBookLoaded extends OrderBookState {
  final OrderBook book;
  OrderBookLoaded(this.book);
}

class OrderBookBloc extends Bloc<OrderBookEvent, OrderBookState> {
  OrderBookBloc(): super(OrderBookInitial()) {
    on<OrderBookUpdate>((evt, emit) => emit(OrderBookLoaded(evt.book)));
  }
}
EOF
cat > lib/features/tape/domain/tape_event.dart << 'EOF'
class TapeEvent {
  final double price;
  final double volume;
  final DateTime time;
  final String side; // buy/sell

  TapeEvent(this.price, this.volume, this.time, this.side);
}
EOF
cat > lib/features/tape/presentation/widgets/tape_view.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../domain/tape_event.dart';

class TapeView extends StatelessWidget {
  final List<TapeEvent> events;
  TapeView(this.events);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: events.map((e) =>
        ListTile(
          title: Text("${e.price} (${e.side})"),
          trailing: Text("${e.volume}"),
          subtitle: Text("${e.time.toIso8601String()}"),
        )).toList(),
    );
  }
}
EOF
cat > lib/features/indicators/plugins/vwap_plugin.dart << 'EOF'
import '../../engine/indicator_engine.dart';
import '../../../../core/models/candle_entity.dart';

class VWAPPlugin implements IndicatorPlugin {
  @override
  Map<String, double> compute(List<CandleEntity> candles) {
    double cumulPV = 0, cumulVol = 0;
    for (var c in candles) {
      final typical = (c.high + c.low + c.close) / 3;
      cumulPV += typical * c.volume;
      cumulVol += c.volume;
    }
    final vwap = cumulVol == 0 ? 0 : cumulPV / cumulVol;
    return {'VWAP': vwap};
  }
}
EOF
cat > lib/features/trading/domain/order/advanced_order.dart << 'EOF'
enum OrderType { market, limit, stop, stopLimit }

class AdvancedOrder {
  final String id;
  final String symbol;
  final OrderType type;
  final double price;
  final double stopPrice;
  final double lots;

  AdvancedOrder({
    required this.id,
    required this.symbol,
    this.type = OrderType.market,
    this.price = 0,
    this.stopPrice = 0,
    required this.lots,
  });
}
EOF
cat > lib/features/trading/domain/order/oco_order.dart << 'EOF'
class OCOOrder {
  final AdvancedOrder primary;
  final AdvancedOrder secondary;

  OCOOrder(this.primary, this.secondary);
}
EOF
cat > lib/features/trading/domain/order/oco_execution_engine.dart << 'EOF'
import 'oco_order.dart';

class OCOExecutionEngine {
  void submit(OCOOrder oco) {
    // if primary fills -> cancel secondary
  }
}
EOF
cat > lib/features/trading/domain/hedging/hedge_manager.dart << 'EOF'
class HedgeManager {
  bool shouldHedge(double exposure, double threshold) {
    return exposure.abs() > threshold;
  }
}
EOF
cat > lib/features/trading/domain/risk/position_sizing.dart << 'EOF'
double calculateLotSize({
  required double riskPercent,
  required double accountBalance,
  required double stopLossPips,
  required double pipValue,
}) {
  final riskAmt = accountBalance * (riskPercent / 100);
  return riskAmt / (stopLossPips * pipValue);
}
EOF
cat > lib/features/trading/domain/order/fee_model.dart << 'EOF'
class FeeModel {
  final double commissionPerLot;
  final double spreadCost;

  FeeModel(this.commissionPerLot, this.spreadCost);

  double totalCost(double lots) =>
      commissionPerLot * lots + spreadCost * lots;
}
EOF
cat > lib/features/trading/domain/order/execution_with_fees.dart << 'EOF'
import 'fee_model.dart';
import 'order.dart';

class ExecutionWithFees {
  final FeeModel feeModel;

  ExecutionWithFees(this.feeModel);

  double netPnL(double grossPnL, double lots) {
    final cost = feeModel.totalCost(lots);
    return grossPnL - cost;
  }
}
EOF
cat > lib/core/network/ws/ws_channel_manager.dart << 'EOF'
import 'package:web_socket_channel/web_socket_channel.dart';

class WSChannelManager {
  WebSocketChannel? _channel;
  String? _currentSymbol;

  WebSocketChannel? get channel => _channel;

  void connectForSymbol(String symbol, String url) {
    if (_currentSymbol == symbol) {
      return; // Already connected for same
    }
    _disconnect();
    _currentSymbol = symbol;
    _channel = WebSocketChannel.connect(Uri.parse("$url?symbol=$symbol"));
  }

  void _disconnect() {
    _channel?.sink.close();
    _channel = null;
    _currentSymbol = null;
  }

  void dispose() => _disconnect();
}
EOF
cat > lib/features/replay/domain/replay_engine2.dart << 'EOF'
import '../../../core/models/tick_entity.dart';
import '../../../core/models/candle_entity.dart';

typedef ReplayTickCb = void Function(TickEntity);
typedef ReplayCandleCb = void Function(CandleEntity);

class ReplayEngine2 {
  final List<TickEntity> ticks;
  final List<CandleEntity> candles;
  int _tickIdx = 0;
  int _candleIdx = 0;
  bool _playing = false;

  ReplayEngine2(this.ticks, this.candles);

  void play({required ReplayTickCb onTick, required ReplayCandleCb onCandle}) async {
    _playing = true;
    while (_playing &&
           (_tickIdx < ticks.length || _candleIdx < candles.length)) {
      if (_tickIdx < ticks.length) {
        onTick(ticks[_tickIdx++]);
      }
      if (_candleIdx < candles.length) {
        onCandle(candles[_candleIdx++]);
      }
      await Future.delayed(Duration(milliseconds: 200));
    }
  }

  void stop() => _playing = false;
}
EOF
cat > lib/features/indicators/engine/zoom_sensitive_engine_fix.dart << 'EOF'
import '../../../core/models/candle_entity.dart';
import 'indicator_engine.dart';

class ZoomSensitiveEngineFix extends IndicatorEngine {
  ZoomSensitiveEngineFix(super.plugins);

  Map<String, double> calculateInRange(
      List<CandleEntity> all, DateTime from, DateTime to) {
    final visible = all.where((c) =>
      !c.timeUtc.isBefore(from) && !c.timeUtc.isAfter(to)
    ).toList();
    final result = super.calculate(visible);
    return result;
  }
}
EOF
cat > lib/core/storage/indicator/indicator_settings_storage2.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class IndicatorSettingsStorage2 {
  static Future<void> save(String id, Map<String, dynamic> params) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "indicator_settings_$id";
    prefs.setString(key, jsonEncode(params));
  }

  static Future<Map<String, dynamic>?> load(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "indicator_settings_$id";
    final str = prefs.getString(key);
    return str == null ? null : jsonDecode(str);
  }
}
EOF
cat > lib/core/storage/audit/event_audit_manager2.dart << 'EOF'
import 'package:hive/hive.dart';

class EventAuditManager2 {
  static Box? _box;

  static Future<Box> _openBox() async {
    if (_box != null && _box!.isOpen) return _box!;
    _box = await Hive.openBox('eventAudit');
    return _box!;
  }

  static Future<void> log(String event) async {
    final b = await _openBox();
    await b.add({'event': event, 'timestamp': DateTime.now().toIso8601String()});
  }

  static Future<List<Map>> getAll() async {
    final b = await _openBox();
    return b.values.cast<Map>().toList();
  }
}
EOF
cat > lib/features/indicators/engine/windowed_engine.dart << 'EOF'
import '../../../core/models/candle_entity.dart';
import 'indicator_engine.dart';

class WindowedIndicatorEngine extends IndicatorEngine {
  WindowedIndicatorEngine(super.plugins);

  @override
  Map<String, double> calculate(List<CandleEntity> candles) {
    final windowSize = 500; // آخر 500 شمعة فقط
    final subset = candles.length > windowSize
        ? candles.sublist(candles.length - windowSize)
        : candles;
    return super.calculate(subset);
  }
}
EOF
cat > lib/features/chart/domain/drawing_storage.dart << 'EOF'
import 'package:hive/hive.dart';

class DrawingStorage {
  static Box? _box;

  static Future<Box> _getBox() async =>
      _box ??= await Hive.openBox('drawings');

  static Future<void> saveDrawing(String key, Map data) async {
    final b = await _getBox();
    await b.put(key, data);
  }

  static Future<Map?> loadDrawing(String key) async {
    final b = await _getBox();
    return b.get(key)?.cast<String, dynamic>();
  }
}
EOF
cat > lib/features/backtest/domain/backtest_engine2.dart << 'EOF'
import '../../../core/models/candle_entity.dart';

class BacktestEngine2 {
  final List<CandleEntity> history;
  final StrategyEngine strategy;

  BacktestEngine2(this.history, this.strategy);

  void run() {
    Map<String, double> lastIndicators = {};

    for (int i = 0; i < history.length; i++) {
      final candle = history[i];
      // تحديث المؤشرات أولا
      lastIndicators = calculateIndicators(history.sublist(0, i + 1));
      final signals = strategy.evaluateSignals(lastIndicators);

      // تنفيذ الإشارات بعد التأكد من الانتهاء من التحديث
      for (final s in signals) {
        executeSignal(s, candle);
      }
    }
  }
}
EOF
cat > lib/features/strategy/domain/dsl/strategy_dsl_validator.dart << 'EOF'
class StrategyDslValidator {
  static bool isValid(List<String> tokens) {
    if (tokens.isEmpty) return false;
    final ops = ['>', '<', '>=', '<=', 'AND', 'OR'];
    // بسيط جدًا: لا يمكن أن يبدأ بـ Operator أو ينتهي به
    if (ops.contains(tokens.first) || ops.contains(tokens.last)) return false;
    return true;
  }
}
EOF
cat > lib/core/time/market_hours_filter.dart << 'EOF'
class MarketHoursFilter {
  static bool isMarketOpen(DateTime timeUtc) {
    final weekday = timeUtc.weekday;
    final hour = timeUtc.hour;
    // أمثلة (Forex): من الأحد 22:00 إلى الجمعة 22:00 UTC
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) return false;
    if (hour < 22 && weekday == DateTime.sunday) return false;
    return true;
  }
}
EOF
cat > lib/features/market/presentation/widgets/chart_screen_lifecycle_fix.dart << 'EOF'
import 'package:flutter/material.dart';
import 'chart_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  WebViewController? _controller;

  @override
  void dispose() {
    _controller = null; // يسمح بالـGC بإنهاء WebView
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      onWebViewCreated: (ctrl) => _controller = ctrl,
      initialUrl: "about:blank",
    );
  }
}
EOF
cat > lib/core/navigation/back_handler.dart << 'EOF'
import 'package:flutter/material.dart';

class BackHandler extends StatelessWidget {
  final Widget child;
  final VoidCallback onBack;

  BackHandler({required this.child, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBack();
        return false;
      },
      child: child,
    );
  }
}
EOF
cat > lib/core/state/event_queue.dart << 'EOF'
import 'dart:async';

class EventQueue<T> {
  final _queue = StreamController<T>();
  bool _processing = false;

  void add(T event) {
    _queue.add(event);
    if (!_processing) _process();
  }

  void _process() async {
    _processing = true;
    await for (final e in _queue.stream) {
      // يمرّر هذا الحدث إلى الـ Bloc أو Handler المناسب
    }
    _processing = false;
  }

  void dispose() => _queue.close();
}
EOF
cat > lib/features/settings/data/chart_settings_storage.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChartSettingsStorage {
  static const key = "chart_settings";

  static Future<void> save(Map<String, dynamic> cfg) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(cfg));
  }

  static Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(key);
    return str == null ? null : jsonDecode(str);
  }
}
EOF
cat > lib/features/replay/domain/replay_scheduler.dart << 'EOF'
import 'dart:async';

class ReplayScheduler {
  Timer? _replayTimer;

  void start(void Function() onTick, Duration interval) {
    stop();
    _replayTimer = Timer.periodic(interval, (_) => onTick());
  }

  void stop() {
    _replayTimer?.cancel();
    _replayTimer = null;
  }
}
EOF
cat > lib/core/network/network_observer.dart << 'EOF'
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetState { online, offline }

class NetworkObserver {
  final _controller = StreamController<NetState>.broadcast();

  NetworkObserver() {
    Connectivity().onConnectivityChanged.listen((status) {
      _controller.add(status == ConnectivityResult.none
        ? NetState.offline : NetState.online);
    });
  }

  Stream<NetState> get stream => _controller.stream;
}
EOF
cat > lib/core/storage/safe_restore.dart << 'EOF'
import 'package:hive/hive.dart';

Future<void> safeRestore(String boxName) async {
  try {
    await Hive.openBox(boxName);
  } catch (err) {
    await Hive.deleteBoxFromDisk(boxName);
    await Hive.openBox(boxName);
  }
}
EOF
cat > lib/features/market/presentation/bloc/market_sync_bloc_fix.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/market_repository.dart';

class MarketSyncBloc extends Cubit<bool> {
  final MarketRepository repo;

  MarketSyncBloc(this.repo) : super(false);

  Future<void> init(String symbol, String timeframe) async {
    await repo.getCandles(symbol, timeframe);
    emit(true); // جاهز لبث اللحظي
  }
}
EOF
cat > lib/core/webview/js_error_filter.js << 'EOF'
window.onerror = function(message, source, lineno, colno, error) {
  if (message.includes('ResizeObserver')) return true;
  return false;
};
EOF
cat > lib/core/lifecycle/app_lifecycle_observer.dart << 'EOF'
import 'package:flutter/widgets.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      // هنا قم بإغلاق الموارد (WebSockets, Streams, Timers)
    }
  }
}
EOF
cat > lib/core/storage/audit/event_audit_manager3.dart << 'EOF'
import 'package:hive/hive.dart';

class EventAuditManager3 {
  static Box? _box;

  static Future<Box> _openBox() async {
    if (_box != null && _box!.isOpen) return _box!;
    _box = await Hive.openBox('eventAudit');
    return _box!;
  }

  static Future<void> log(String event) async {
    final box = await _openBox();
    final timestamp = DateTime.now().toUtc().toIso8601String();
    await box.add({'event': event, 'timestamp': timestamp});
  }

  static Future<List<Map>> getAllSorted() async {
    final box = await _openBox();
    final values = box.values.cast<Map>().toList();
    values.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
    return values;
  }
}
EOF
cat > lib/core/audio/alert_sound_singleton.dart << 'EOF'
import 'package:audioplayers/audioplayers.dart';

class AlertSoundManager {
  static final AlertSoundManager _instance = AlertSoundManager._internal();
  factory AlertSoundManager() => _instance;

  final AudioPlayer _player = AudioPlayer();

  AlertSoundManager._internal();

  Future<void> playBuy() => _player.play(AssetSource('audio/buy.mp3'));
  Future<void> playSell() => _player.play(AssetSource('audio/sell.mp3'));
}
EOF
cat > lib/features/trading/domain/sl_tp_settings.dart << 'EOF'
class SLTPSettings {
  double stopLoss = 0;
  double takeProfit = 0;

  void update(double sl, double tp) {
    stopLoss = sl;
    takeProfit = tp;
  }
}
EOF
cat > lib/core/webview/js_batch_update.js << 'EOF'
function batchUpdate(seriesData) {
  const chunkSize = 500;
  for (let i = 0; i < seriesData.length; i += chunkSize) {
    setTimeout(() => {
      chart.series[0].setData(seriesData.slice(i, i + chunkSize));
    }, i / chunkSize);
  }
}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_bloc_fix.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartBlocFix extends Bloc<ChartEvent, ChartState> {
  List<CandleEntity> _candles = [];

  ChartBlocFix() : super(ChartIdle()) {
    on<LoadChartHistory>((evt, emit) {
      _candles = evt.candles;
      emit(ChartLoaded(_candles, evt.from, evt.to));
    });

    on<ClearChart>((_, emit) {
      _candles.clear();
      emit(ChartIdle());
    });
  }
}
EOF
cat > lib/features/trading/domain/history/trade_history_fix.dart << 'EOF'
import '../order/order.dart';
import '../../../../../core/storage/audit/event_audit_manager3.dart';

class TradeHistoryFix {
  static void recordUpdate(Order order, String note) {
    EventAuditManager3.log("TradeUpdate: ${order.id} | $note");
  }
}
EOF
cat > lib/features/indicators/domain/indicator_update_lock.dart << 'EOF'
import 'dart:async';

class IndicatorUpdateLock {
  bool _busy = false;

  Future<void> run(Future<void> Function() action) async {
    if (_busy) return;
    _busy = true;
    await action();
    _busy = false;
  }
}
EOF
cat > lib/features/market/data/repository/history_paging.dart << 'EOF'
import '../../../../core/models/candle_entity.dart';
import '../../../domain/repository/market_repository.dart';

class HistoryPaging {
  final MarketRepository repo;

  HistoryPaging(this.repo);

  Future<List<CandleEntity>> fetchAll(
      String symbol, String timeframe) async {
    List<CandleEntity> all = [];
    int page = 0;
    while (true) {
      final chunk = await repo.fetchHistoryPage(symbol, timeframe, page++);
      if (chunk.isEmpty) break;
      all.addAll(chunk);
    }
    return all;
  }
}
EOF
cat > lib/features/strategy/domain/dsl/strategy_dsl_safety.dart << 'EOF'
class StrategyDslSafety {
  static bool hasEnoughTokens(List<String> tokens) {
    return tokens.length >= 3;
  }
}
EOF
cat > lib/core/state/debounce_helper.dart << 'EOF'
import 'dart:async';

class DebounceHelper<T> {
  final Duration delay;
  Timer? _timer;
  void Function(T)? _action;

  DebounceHelper(this.delay);

  void call(T value, void Function(T) action) {
    _action = action;
    _timer?.cancel();
    _timer = Timer(delay, () => action(value));
  }
}
EOF
cat > lib/features/market/presentation/bloc/chart/timeframe_stream_fix.dart << 'EOF'
import 'dart:async';

class TimeframeStreamFix {
  StreamSubscription? _sub;

  void subscribe(Stream stream, Function onData) {
    _sub?.cancel(); // إلغاء القديم أولاً
    _sub = stream.listen((data) => onData(data));
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
EOF
cat > lib/features/market/presentation/bloc/chart/history_cache_fix.dart << 'EOF'
import '../../../../core/models/candle_entity.dart';

class HistoryCacheFix {
  List<CandleEntity>? _lastCache;

  List<CandleEntity>? get cached => _lastCache;

  void save(List<CandleEntity> data) {
    _lastCache = data;
  }

  void clear() {
    _lastCache = null;
  }
}
EOF
cat > lib/features/market/data/repository/instant_first_candle_fix.dart << 'EOF'
import '../../../../core/models/candle_entity.dart';
import '../local/candle_dao.dart';

class InstantFirstCandleFix {
  final CandleDao dao;
  InstantFirstCandleFix(this.dao);

  Future<CandleEntity?> getLastKnown(String symbol, String tf) async {
    return await dao.getLastCandle(symbol, tf);
  }
}
EOF
cat > lib/features/market_depth/domain/order_book_safe.dart << 'EOF'
import 'order_book.dart';

class OrderBookSafe {
  static OrderBook empty() =>
      OrderBook(bids: const [], asks: const []);
}
EOF
cat > lib/features/replay/domain/replay_scheduler_fix.dart << 'EOF'
import 'dart:async';

class ReplaySchedulerFix {
  Timer? _timer;

  void start(void Function() cb, Duration interval) {
    stop();
    _timer = Timer.periodic(interval, (_) => cb());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
EOF
cat > lib/features/chart/data/view_state_storage.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ViewStateStorage {
  static const key = "chart_view_state";

  static Future<void> save(Map<String, dynamic> state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(state));
  }

  static Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(key);
    return str == null ? null : jsonDecode(str);
  }
}
EOF
cat > lib/core/state/mode_mutex.dart << 'EOF'
class ModeMutex {
  bool _replayActive = false;

  bool get canStartLive => !_replayActive;

  void startReplay() => _replayActive = true;
  void stopReplay() => _replayActive = false;
}
EOF
cat > lib/core/time/time_formatter.dart << 'EOF'
class TimeFormatter {
  static String format(DateTime utc) {
    return utc.toLocal().toIso8601String();
  }
}
EOF
cat > lib/features/indicators/engine/plugin_manager_fix.dart << 'EOF'
import 'indicator_engine.dart';

class PluginManagerFix {
  final List<IndicatorPlugin> _plugins = [];

  void add(IndicatorPlugin p) => _plugins.add(p);

  void remove(IndicatorPlugin p) => _plugins.remove(p);

  void clear() => _plugins.clear();

  List<IndicatorPlugin> get active => List.unmodifiable(_plugins);
}
EOF
cat > lib/core/network/ws/ws_disconnect_on_offline.dart << 'EOF'
import 'ws_channel_manager.dart';
import '../network_observer.dart';

class WsDisconnectOnOffline {
  final WSChannelManager manager;
  final NetworkObserver observer;

  WsDisconnectOnOffline(this.manager, this.observer) {
    observer.stream.listen((state) {
      if (state == NetState.offline) {
        manager.dispose();
      }
    });
  }
}
EOF
cat > lib/features/backtest/domain/backtest_cancel_token.dart << 'EOF'
class BacktestCancelToken {
  bool _cancelled = false;
  void cancel() => _cancelled = true;
  bool get isCancelled => _cancelled;
}
EOF
cat > lib/core/network/rest_error.dart << 'EOF'
class RestError implements Exception {
  final String message;
  RestError(this.message);
}
EOF
cat > lib/features/market/data/repository/market_repository_error_fix.dart << 'EOF'
import '../../../../core/network/rest_error.dart';

Future<List<CandleEntity>> safeGetCandles(...) async {
  try {
    return await _fetchRemote(...);
  } catch (e) {
    throw RestError("فشل في جلب البيانات: $e");
  }
}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_bloc_error_handling.dart << 'EOF'
on<LoadChartHistory>((evt, emit) async {
  try {
    final candles = await repo.getCandles(...);
    emit(ChartLoaded(candles, evt.from, evt.to));
  } catch (e) {
    if (e is RestError) {
      emit(ChartError(e.message));
    } else {
      emit(ChartError("حدث خطأ غير متوقع"));
    }
  }
});
EOF
cat > lib/features/chart/domain/draw_mode_flag.dart << 'EOF'
class DrawModeFlag {
  bool _active = false;
  void enable() => _active = true;
  void disable() => _active = false;
  bool get isActive => _active;
}
EOF
cat > lib/core/models/price/spread_fix.dart << 'EOF'
class SpreadCalculator {
  static double forBuy(double ask, double bid) => ask - bid;
  static double forSell(double bid, double ask) => bid - ask;
}
EOF
cat > lib/features/indicators/plugins/rsi_plugin_fix.dart << 'EOF'
Map<String, double> compute(...) {
  if (candles.length < period) {
    return {"RSI$period": 0.0};
  }
  // الحساب العادي
}
EOF
cat > lib/core/navigation/router_observer_fix.dart << 'EOF'
import 'package:flutter/widgets.dart';

class RouterObserverFix extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPop(Route route, Route? previousRoute) {
    // إيقاف Replay / Streams
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    // مماثل
  }
}
EOF
cat > lib/core/streams/symbol_stream_guard.dart << 'EOF'
import 'dart:async';

class SymbolStreamGuard {
  StreamSubscription? _sub;

  void bind(Stream stream, void Function(dynamic) onData) {
    _sub?.cancel(); // إلغاء الاشتراك السابق دائمًا
    _sub = stream.listen(onData);
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
EOF
cat > lib/features/market/data/repository/boot_history_restore_fix.dart << 'EOF'
import '../../../../core/models/candle_entity.dart';
import '../local/candle_dao.dart';

class BootHistoryRestoreFix {
  final CandleDao dao;
  BootHistoryRestoreFix(this.dao);

  Future<List<CandleEntity>> restoreOnBoot(String symbol, String tf) async {
    final cached = await dao.getAll(symbol, tf);
    return cached.isEmpty ? [] : cached;
  }
}
EOF
cat > lib/core/compute/async_loader_fix.dart << 'EOF'
import 'dart:isolate';

Future<T> runInIsolate<T>(T Function() fn) async {
  return await Isolate.run(fn);
}
EOF
cat > lib/core/network/ws/ws_timeframe_guard.dart << 'EOF'
import 'ws_channel_manager.dart';

class WsTimeframeGuard {
  final WSChannelManager manager;

  WsTimeframeGuard(this.manager);

  void switchTimeframe(String newSymbol, String url) {
    manager.dispose(); // إغلاق أي اتصال سابق
    manager.connectForSymbol(newSymbol, url);
  }
}
EOF
cat > lib/features/replay/domain/replay_engine_cleanup_fix.dart << 'EOF'
class ReplayEngineCleanupFix {
  bool _playing = false;

  void stop() {
    _playing = false;
  }

  bool get isPlaying => _playing;
}
EOF
cat > lib/features/chart/domain/touch_mode_guard.dart << 'EOF'
class TouchModeGuard {
  bool drawing = false;

  bool allowWebViewGesture() => !drawing;
}
EOF
cat > lib/features/indicators/domain/indicator_queue_fix.dart << 'EOF'
import 'dart:async';

class IndicatorQueueFix {
  final _queue = StreamController<void>();

  void enqueue(void Function() task) {
    _queue.add(null);
    task();
  }

  void dispose() {
    _queue.close();
  }
}
EOF
cat > lib/features/chart/data/orientation_state_fix.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OrientationStateFix {
  static const key = "chart_orientation_state";

  static Future<void> save(Map<String, dynamic> state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(state));
  }

  static Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(key);
    return str == null ? null : jsonDecode(str);
  }
}
EOF
cat > lib/core/storage/hive_cleanup_fix.dart << 'EOF'
import 'package:hive/hive.dart';

Future<void> closeAllHiveBoxes() async {
  for (var box in Hive.boxes.values) {
    if (box.isOpen) {
      await box.close();
    }
  }
}
EOF
cat > lib/features/backtest/domain/backtest_cancel_guard.dart << 'EOF'
class BacktestCancelGuard {
  bool _cancel = false;

  void cancel() => _cancel = true;
  bool get cancelled => _cancel;
}
EOF
cat > lib/features/indicators/domain/indicator_cache_cleanup.dart << 'EOF'
class IndicatorCacheCleanup {
  static void clearCache(Map<String, double> cache) {
    cache.clear();
  }
}
EOF
cat > lib/core/compute/backtest_save_isolate.dart << 'EOF'
import 'dart:isolate';

Future<void> saveBacktestInIsolate(Function saveFn) async {
  await Isolate.run(saveFn);
}
EOF
cat > lib/core/storage/audit/audit_flush_on_error.dart << 'EOF'
import 'event_audit_manager3.dart';

Future<void> flushAuditOnError() async {
  final events = await EventAuditManager3.getAllSorted();
  for (var e in events) {
    //  ضمان الحفظ النهائي (مثال عمليات إضافية)
  }
}
EOF
cat > lib/core/webview/js_sl_tp_fix.js << 'EOF'
function drawSLTPWhenReady(sl, tp) {
  if (!window.chart) {
    setTimeout(() => drawSLTPWhenReady(sl, tp), 50);
    return;
  }
  drawSLTP(sl, tp);
}
EOF
cat > lib/features/market/data/repository/history_refresh_fix.dart << 'EOF'
Future<List<CandleEntity>> refreshHistory(
    String symbol, String timeframe) async {
  await cache.clear();  // إزالة الكاش القديم
  return await repo.getCandles(symbol, timeframe);
}
EOF
cat > lib/features/backtest/presentation/bloc/backtest_control_fix.dart << 'EOF'
class BacktestControlFix {
  bool _isRunning = false;

  bool startIfNotRunning(Function startFn) {
    if (_isRunning) return false;
    _isRunning = true;
    startFn();
    return true;
  }

  void done() => _isRunning = false;
}
EOF
cat > lib/features/market/presentation/bloc/timeframe_loading_fix.dart << 'EOF'
class TimeframeLoadingFix {
  bool _loading = false;

  Future<void> loadIfNotLoading(Future<void> Function() loadFn) async {
    if (_loading) return;
    _loading = true;
    await loadFn();
    _loading = false;
  }
}
EOF
cat > lib/core/time/market_hours_filter_fix.dart << 'EOF'
class MarketHoursFilterFix {
  static bool isMarketOpen(DateTime t) {
    final utc = t.toUtc();
    final weekday = utc.weekday;
    // Forex example:
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
      return false;
    }
    return true;
  }
}
EOF
cat > lib/features/alerts/data/alert_persistence_fix.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AlertPersistenceFix {
  static Future<void> save(String key, Map cfg) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("alert_cfg_$key", jsonEncode(cfg));
  }

  static Future<Map?> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString("alert_cfg_$key");
    return str == null ? null : jsonDecode(str);
  }
}
EOF
cat > lib/core/state/bloc_close_fix.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';

mixin BlocCloseFix on BlocBase {
  @override
  Future<void> close() async {
    await super.close();
  }
}
EOF
cat > lib/core/storage/sync/preferences_write_lock.dart << 'EOF'
import 'dart:async';

class PreferencesWriteLock {
  Completer<void>? _lock;

  Future<void> synchronized(Future<void> Function() fn) async {
    while (_lock != null) {
      await _lock!.future;
    }
    _lock = Completer<void>();
    await fn();
    _lock!.complete();
    _lock = null;
  }
}
EOF
cat > lib/core/network/ws/parsers/tick_parser_fix.dart << 'EOF'
Map<String, dynamic>? safeParse(dynamic data) {
  try {
    if (data == null || data['price'] == null) return null;
    return data as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}
EOF
cat > lib/features/indicators/domain/visible_synchronizer_fix.dart << 'EOF'
import '../../../core/models/candle_entity.dart';

class VisibleSynchronizerFix {
  List<CandleEntity> sync(
      List<CandleEntity> all, DateTime from, DateTime to) {
    return all.where((c) =>
        !c.timeUtc.isBefore(from) && !c.timeUtc.isAfter(to)).toList();
  }
}
EOF
cat > lib/features/strategy/domain/strategy_engine_cleanup_fix.dart << 'EOF'
class StrategyEngineCleanupFix {
  void clearCache(Map<String, double> cache) => cache.clear();
}
EOF
cat > lib/features/strategy/domain/dsl/strategy_dsl_safe_eval.dart << 'EOF'
import 'strategy_dsl_validator.dart';
import 'strategy_dsl_safety.dart';

bool safeEval(String expr) {
  final tokens = expr.split(RegExp(r"\s+"));
  if (!StrategyDslValidator.isValid(tokens)) return false;
  if (!StrategyDslSafety.hasEnoughTokens(tokens)) return false;
  return true;
}
EOF
cat > lib/features/alerts/domain/alert_rate_limit_fix.dart << 'EOF'
class AlertRateLimiter {
  DateTime? lastTriggered;

  bool canTrigger(Duration minGap) {
    final now = DateTime.now();
    if (lastTriggered == null ||
        now.difference(lastTriggered!) >= minGap) {
      lastTriggered = now;
      return true;
    }
    return false;
  }
}
EOF
cat > lib/core/network/ws/ws_reconnect_manager.dart << 'EOF'
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WsReconnectManager {
  final String url;
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;

  WsReconnectManager(this.url);

  void connect(void Function(dynamic) onData) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel?.stream.listen(onData,
        onError: (_) => _scheduleReconnect(onData),
        onDone: () => _scheduleReconnect(onData));
  }

  void _scheduleReconnect(void Function(dynamic) onData) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: 5), () => connect(onData));
  }

  void dispose() {
    _channel?.sink.close();
    _reconnectTimer?.cancel();
  }
}
EOF
cat > lib/features/indicators/engine/plugin_manager_cleanup_fix.dart << 'EOF'
import 'indicator_engine.dart';

class PluginManagerCleanupFix {
  final List<IndicatorPlugin> _active = [];

  void add(IndicatorPlugin p) {
    _active.add(p);
  }

  void remove(IndicatorPlugin p) {
    _active.removeWhere((x) => x == p);
    // تحرّر أي مورد داخلي داخل p إن وجد
  }

  void clear() => _active.clear();
}
EOF
cat > lib/features/replay/domain/replay_strategy_sync_fix.dart << 'EOF'
class ReplayStrategySyncFix {
  bool _ready = false;

  void markReady() => _ready = true;
  bool get isReady => _ready;
}
EOF
cat > lib/core/state/subscription_cleanup_fix.dart << 'EOF'
import 'dart:async';

mixin SubscriptionCleanupFix {
  final List<StreamSubscription> _subs = [];

  void addSub(StreamSubscription sub) => _subs.add(sub);

  @override
  Future<void> close() async {
    for (final s in _subs) {
      await s.cancel();
    }
    _subs.clear();
    await super.close();
  }
}
EOF
cat > lib/features/market/data/cache/history_cache_by_tf.dart << 'EOF'
import '../../../../core/models/candle_entity.dart';

class HistoryCacheByTimeframe {
  final Map<String, List<CandleEntity>> _cache = {};

  void save(String symbol, String timeframe, List<CandleEntity> data) {
    _cache["$symbol-$timeframe"] = data;
  }

  List<CandleEntity>? load(String symbol, String timeframe) {
    return _cache["$symbol-$timeframe"];
  }

  void clear(String symbol, String timeframe) {
    _cache.remove("$symbol-$timeframe");
  }
}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_bloc_order_fix.dart << 'EOF'
void _onLoadChartHistory(...) async {
  final history = await repo.getCandles(...);
  emit(ChartLoaded(history, ...));
  // بعد الانتهاء فقط
  _streamSubscription = stream.listen((candle) {
    add(AppendLiveCandle(candle));
  });
}
EOF
cat > lib/features/market_depth/presentation/bloc/order_book_state_fix.dart << 'EOF'
class OrderBookState {
  final List bids;
  final List asks;

  OrderBookState({this.bids = const [], this.asks = const []});
}
EOF
cat > lib/core/network/network_listener_fix.dart << 'EOF'
import 'package:flutter/material.dart';
import 'network_observer.dart';

class NetworkStateListener extends StatefulWidget {
  final Widget child;
  NetworkStateListener(this.child);

  @override
  _NetworkStateListenerState createState() => _NetworkStateListenerState();
}

class _NetworkStateListenerState extends State<NetworkStateListener> {
  @override
  void initState() {
    super.initState();
    NetworkObserver().stream.listen((state) {
      setState(() {}); // triggers rebuild to show Online/Offline
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
EOF
cat > lib/features/replay/domain/replay_engine_reset_fix.dart << 'EOF'
class ReplayEngineResetFix {
  int _index = 0;

  void reset() => _index = 0;
}
EOF
cat > lib/features/indicators/plugins/vwap_plugin_fix.dart << 'EOF'
Map<String, double> compute(List candles) {
  double cumulPV = 0, cumulVol = 0;
  for (var c in candles) {
    final typical = (c.high + c.low + c.close) / 3;
    cumulPV += typical * c.volume;
    cumulVol += c.volume;
  }
  final vwap = cumulVol == 0 ? 0.0 : cumulPV / cumulVol;
  return {'VWAP': vwap};
}
EOF
cat > lib/features/indicators/domain/compute_lock.dart << 'EOF'
import 'dart:async';

class ComputeLock {
  bool _busy = false;

  Future<T?> run<T>(Future<T> Function() fn) async {
    if (_busy) return null;
    _busy = true;
    final result = await fn();
    _busy = false;
    return result;
  }
}
EOF
cat > lib/features/backtest/domain/backtest_sync_signals_fix.dart << 'EOF'
void executeSignalsSafely() {
  updateEquity();
  for (final s in signals) {
    executeSignal(s);
  }
}
EOF
cat > lib/features/market/data/repository/timeframe_transition_fix.dart << 'EOF'
Future<void> transitionTF(
    String symbol, String fromTF, String toTF) async {
  await manager.dispose(); // close WS
  final hist = await repo.getCandles(symbol, toTF); // load history
  manager.connectForSymbol(symbol, wsUrl(toTF)); // open new WS
}
EOF
cat > lib/features/alerts/presentation/bloc/alert_bloc_cleanup.dart << 'EOF'
import 'dart:async';
mixin AlertBlocCleanup {
  final List<StreamController> _controllers = [];

  void addController(StreamController c) => _controllers.add(c);

  @override
  Future<void> close() async {
    for (final c in _controllers) {
      await c.close();
    }
    await super.close();
  }
}
EOF
cat > lib/core/bloc/init/bloc_init_coordinator.dart << 'EOF'
typedef InitFuture = Future<void> Function();

class BlocInitCoordinator {
  final List<InitFuture> _initializers = [];

  void add(InitFuture fn) => _initializers.add(fn);

  Future<void> run() async {
    for (final init in _initializers) {
      await init();
    }
  }
}
EOF
cat > lib/core/network/rest/cancelable_request.dart << 'EOF'
import 'dart:async';

class CancelableRequest {
  bool _cancelled = false;

  void cancel() => _cancelled = true;

  Future<T?> execute<T>(Future<T> Function() fn) async {
    if (_cancelled) return null;
    final result = await fn();
    if (_cancelled) return null;
    return result;
  }
}
EOF
cat > lib/features/indicators/data/cache/indicator_results_cache_fix.dart << 'EOF'
import 'dart:collection';

class IndicatorResultsCacheFix {
  final _cache = HashMap<String, double>();

  void put(String key, double value) => _cache[key] = value;
  double? get(String key) => _cache[key];

  void clear() => _cache.clear();
}
EOF
cat > lib/features/strategy/domain/strategy_safe_eval_fix.dart << 'EOF'
bool canEvaluate(Map<String, double> indicators) {
  if (indicators.isEmpty) return false;
  return true;
}
EOF
cat > lib/core/state/event/event_queue_fix.dart << 'EOF'
import 'dart:async';

class EventQueueFix<T> {
  final _queue = StreamController<T>();
  bool _processing = false;

  void add(T evt) { _queue.add(evt); if (!_processing) _process(); }

  void _process() async {
    _processing = true;
    await for (final e in _queue.stream) {
      // معالجة الحدث داخل Bloc أو Handler
    }
    _processing = false;
  }

  void dispose() => _queue.close();
}
EOF
cat > lib/core/network/ws/ws_reconnect_guard_fix.dart << 'EOF'
import 'dart:async';
import 'ws_reconnect_manager.dart';

class WsReconnectGuardFix {
  final WsReconnectManager manager;
  bool _attempting = false;

  WsReconnectGuardFix(this.manager);

  void attemptReconnect(void Function(dynamic) onData) {
    if (_attempting) return;
    _attempting = true;
    manager.connect((msg) {
      onData(msg);
      _attempting = false;
    });
  }
}
EOF
cat > lib/core/network/retry/retry_with_backoff.dart << 'EOF'
Future<T> retryWithBackoff<T>(
    Future<T> Function() fn, {
    int retries = 3,
    Duration delay = const Duration(milliseconds: 500),
  }) async {
  try {
    return await fn();
  } catch (e) {
    if (retries > 0) {
      await Future.delayed(delay);
      return retryWithBackoff(fn, retries: retries - 1, delay: delay * 2);
    }
    rethrow;
  }
}
EOF
cat > lib/core/state/shared/latest_price_holder_fix.dart << 'EOF'
class LatestPriceHolderFix {
  double? _price;

  void update(double v) => _price = v;
  double? get current => _price;
}
EOF
cat > lib/features/backtest/domain/backtest_equity_update_fix.dart << 'EOF'
void safelyUpdateEquity(List signals, double Function() equityCalc) {
  for (final s in signals) {
    executeSignal(s);
  }
  final newEquity = equityCalc();
  // تحديث Equity مرة واحدة بعد تنفيذ كل الإشارات
}
EOF
cat > lib/core/state/bloc/bloc_event_cancel_fix.dart << 'EOF'
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin BlocEventCancelFix<Event> on Bloc<Event, dynamic> {
  final List<StreamSubscription> _evtSubs = [];

  void addCancelable(StreamSubscription sub) => _evtSubs.add(sub);

  @override
  Future<void> close() async {
    for (final s in _evtSubs) {
      await s.cancel();
    }
    _evtSubs.clear();
    return super.close();
  }
}
EOF
cat > lib/features/chart/domain/touch_event_filter.dart << 'EOF'
class TouchEventFilter {
  bool drawingMode = false;

  bool shouldHandleTouch(double x, double y) {
    return drawingMode; // فقط في وضع الرسم
  }
}
EOF
cat > lib/features/market/domain/candle_deduper.dart << 'EOF'
import '../../../core/models/candle_entity.dart';

class CandleDeduper {
  final Set<int> _seenTimestamps = {};

  bool isDuplicate(CandleEntity candle) {
    final ts = candle.timeUtc.millisecondsSinceEpoch;
    if (_seenTimestamps.contains(ts)) return true;
    _seenTimestamps.add(ts);
    return false;
  }
}
EOF
cat > lib/features/replay/domain/replay_volume_fix.dart << 'EOF'
import '../../../core/models/candle_entity.dart';

class ReplayVolumeFix {
  double lastVolume = 0;

  void track(CandleEntity candle) {
    lastVolume = candle.volume;
  }
}
EOF
cat > lib/core/widgets/fix/disposable_stateful.dart << 'EOF'
import 'package:flutter/widgets.dart';

abstract class DisposableStateful<T extends StatefulWidget> extends State<T> {
  @override
  void dispose() {
    super.dispose();
  }

  void cleanUp() {
    dispose();
  }
}
EOF
cat > lib/features/replay/domain/replay_execution_lock.dart << 'EOF'
class ReplayExecutionLock {
  bool _busy = false;

  Future<void> runSafe(Future<void> Function() fn) async {
    if (_busy) return;
    _busy = true;
    await fn();
    _busy = false;
  }
}
EOF
cat > lib/core/lifecycle/init_once_guard.dart << 'EOF'
class InitOnceGuard {
  bool _initialized = false;

  Future<void> runOnce(Future<void> Function() fn) async {
    if (_initialized) return;
    _initialized = true;
    await fn();
  }
}
EOF
cat > lib/core/bloc/sync/bloc_init_barrier.dart << 'EOF'
class BlocInitBarrier {
  bool chartReady = false;
  bool indicatorReady = false;

  bool get allReady => chartReady && indicatorReady;

  void setChartReady() => chartReady = true;
  void setIndicatorReady() => indicatorReady = true;
}
EOF
cat > lib/features/trading/domain/order_submit_guard.dart << 'EOF'
class OrderSubmitGuard {
  bool canSubmit(String? symbol) => symbol != null && symbol.isNotEmpty;
}
EOF
cat > lib/features/backtest/domain/signal_eval_buffer_fix.dart << 'EOF'
class SignalEvalBufferFix {
  bool _processing = false;

  Future<void> process(Future<void> Function() fn) async {
    if (_processing) return;
    _processing = true;
    await fn();
    _processing = false;
  }
}
EOF
cat > lib/core/lifecycle/resource_lifecycle_observer_fix.dart << 'EOF'
import 'package:flutter/widgets.dart';

class ResourceLifecycleObserverFix extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // إغلاق الموارد هنا
    }
  }
}
EOF
cat > lib/core/network/ws/lifecycle/ws_lifecycle_handler.dart << 'EOF'
import 'package:flutter/widgets.dart';
import '../ws_channel_manager.dart';

class WsLifecycleHandler extends WidgetsBindingObserver {
  final WSChannelManager manager;

  WsLifecycleHandler(this.manager);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      manager.dispose();
    }
  }
}
EOF
cat > lib/core/state/tab/tab_state_preserver.dart << 'EOF'
import 'package:flutter/widgets.dart';

class TabStatePreserver with WidgetsBindingObserver {
  final Map<String, dynamic> _states = {};

  void save(String key, dynamic state) => _states[key] = state;
  dynamic restore(String key) => _states[key];
}
EOF
cat > lib/core/network/ws/ws_reconnect_fix.dart << 'EOF'
import 'dart:async';
import 'ws_reconnect_manager.dart';

class WsReconnectFix {
  final WsReconnectManager manager;
  Timer? _retry;

  WsReconnectFix(this.manager);

  void attempt(void Function(dynamic) onData) {
    _retry?.cancel();
    _retry = Timer.periodic(Duration(seconds: 5), (_) {
      manager.connect(onData);
    });
  }

  void stop() => _retry?.cancel();
}
EOF
cat > lib/core/network/rest/parsers/safe_json_parser.dart << 'EOF'
T? safeJsonParse<T>(Map<String, dynamic>? json, String key) {
  if (json == null) return null;
  if (!json.containsKey(key)) return null;
  return json[key] as T;
}
EOF
cat > lib/core/network/ws/error/ws_error_handler.dart << 'EOF'
import 'package:web_socket_channel/web_socket_channel.dart';

class WsErrorHandler {
  void bind(WebSocketChannel channel, void Function(dynamic) onData) {
    channel.stream.listen(
      (msg) => onData(msg),
      onError: (_) => channel.sink.close(),
      onDone: () => channel.sink.close(),
    );
  }
}
EOF
cat > lib/features/backtest/domain/cancel/backtest_cancel_guard2.dart << 'EOF'
class BacktestCancelGuard2 {
  bool _cancelled = false;

  void cancel() => _cancelled = true;
  bool get isCancelled => _cancelled;
}
EOF
cat > lib/core/webview/webview_controller_cleanup_fix.dart << 'EOF'
import 'package:webview_flutter/webview_flutter.dart';

class WebViewControllerCleanupFix {
  void disposeController(WebViewController? ctrl) {
    ctrl = null;
  }
}
EOF
cat > lib/features/settings/domain/chart_settings_lock_fix.dart << 'EOF'
class ChartSettingsLockFix {
  bool _updating = false;

  Future<void> runSafe(Future<void> Function() fn) async {
    if (_updating) return;
    _updating = true;
    await fn();
    _updating = false;
  }
}
EOF
cat > lib/core/network/retry/network_bounce_handler_fix.dart << 'EOF'
import 'dart:async';

class NetworkBounceHandlerFix {
  Timer? _bounceTimer;

  void onNetworkChange(bool isOnline, void Function() onReconnect) {
    _bounceTimer?.cancel();
    if (isOnline) {
      _bounceTimer = Timer(Duration(seconds: 1), onReconnect);
    }
  }
}
EOF
cat > lib/core/storage/transaction/transactional_write_fix.dart << 'EOF'
import 'dart:io';

class TransactionalStorage {
  static Future<void> safeWrite(String path, String data) async {
    final temp = File(path + ".tmp");
    await temp.writeAsString(data);
    final original = File(path);
    await temp.rename(original.path);
  }
}
EOF
cat > lib/core/bloc/subscription_manager/subscription_manager.dart << 'EOF'
import 'dart:async';

/// A manager that keeps only one active subscription at a time.
/// Cancels previous one automatically when a new one is added.
class SubscriptionManager {
  StreamSubscription<dynamic>? _current;

  /// Replace the current subscription with a new one,
  /// canceling the previous if it exists.
  void replace(StreamSubscription<dynamic> newSub) {
    _current?.cancel();
    _current = newSub;
  }

  /// Cancel and clear the current subscription.
  Future<void> dispose() async {
    if (_current != null) {
      await _current!.cancel();
      _current = null;
    }
  }
}
EOF
cat > lib/core/filters/candle_outlier_filter.dart << 'EOF'
import '../../core/models/candle_entity.dart';

class CandleOutlierFilter {
  final double maxAllowedRangePercentage;

  CandleOutlierFilter({this.maxAllowedRangePercentage = 50});

  /// Filters out candles whose range deviates too much compared to neighbors.
  bool isValid(CandleEntity candle) {
    if (candle.open == 0 || candle.high == 0 || candle.low == 0) {
      return false;
    }
    final range = candle.high - candle.low;
    final avgPrice = (candle.high + candle.low) / 2.0;
    final pct = (range / avgPrice) * 100.0;
    return pct <= maxAllowedRangePercentage;
  }
}
EOF
cat > lib/core/queue/execution_queue.dart << 'EOF'
import 'dart:async';

/// A simple sequential queue for async tasks.
/// Ensures tasks run one at a time in order.
class ExecutionQueue {
  final _taskController = StreamController<Future Function()>();

  ExecutionQueue() {
    _taskController.stream.asyncMap((task) => task()).listen((_) {});
  }

  /// Add a function that returns a Future to the queue.
  void schedule(Future Function() task) {
    _taskController.add(task);
  }

  /// Close the queue.
  Future<void> dispose() async {
    await _taskController.close();
  }
}
EOF
cat > lib/features/backtest/domain/backtest_network_bounce_guard.dart << 'EOF'
import '../../../core/network/retry/retry_with_backoff.dart';

class BacktestNetworkBounceGuard {
  final int maxRetries;

  BacktestNetworkBounceGuard({this.maxRetries = 5});

  Future<T> safeFetch<T>(Future<T> Function() fetchFn) {
    return retryWithBackoff(fetchFn, retries: maxRetries);
  }
}
EOF
cat > lib/features/trading/data/sl_tp_storage_fix.dart << 'EOF'
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
EOF
cat > lib/core/sync/timestamp_aligner.dart << 'EOF'
class TimestampAligner {
  static double alignWeightedAverage(
      double currentValue,
      DateTime currentTimestamp,
      double latestValue,
      DateTime latestTimestamp) {
    final dt = latestTimestamp.difference(currentTimestamp).inMilliseconds;
    final w1 = dt <= 0 ? 1.0 : 1 / (1 + dt);
    final w2 = 1 - w1;
    return (currentValue * w1) + (latestValue * w2);
  }
}
EOF
cat > lib/features/chart/domain/drawing/trendline_mapping_fix.dart << 'EOF'
class TrendlineMappingFix {
  static double mapPriceToY({
    required double price,
    required double minPrice,
    required double maxPrice,
    required double height,
  }) {
    final range = maxPrice - minPrice;
    return (maxPrice - price) / (range == 0 ? 1 : range) * height;
  }

  static double mapTimeToX({
    required DateTime time,
    required DateTime start,
    required DateTime end,
    required double width,
  }) {
    final total = end.difference(start).inMilliseconds;
    final delta = time.difference(start).inMilliseconds;
    return width * (total == 0 ? 0 : delta / total);
  }
}
EOF
cat > lib/core/buffer/ring_buffer.dart << 'EOF'
class RingBuffer<T> {
  final int capacity;
  final List<T> _buffer = [];
  int _index = 0;

  RingBuffer(this.capacity);

  void add(T item) {
    if (_buffer.length < capacity) {
      _buffer.add(item);
    } else {
      _buffer[_index] = item;
      _index = (_index + 1) % capacity;
    }
  }

  List<T> toList() => List.unmodifiable(_buffer);
}
EOF
cat > lib/core/widgets/keep_alive_chart.dart << 'EOF'
import 'package:flutter/widgets.dart';

class KeepAliveChart extends StatefulWidget {
  final Widget child;

  KeepAliveChart({required this.child});

  @override
  _KeepAliveChartState createState() => _KeepAliveChartState();
}

class _KeepAliveChartState extends State<KeepAliveChart>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
EOF
cat > lib/core/lifecycle/resume_load_coordinator_fix.dart << 'EOF'
class ResumeLoadCoordinatorFix {
  bool _historyDone = false;

  void markHistoryDone() => _historyDone = true;

  bool canStartWS() => _historyDone;
}
EOF
cat > lib/features/chart/presentation/bloc/chart_bloc_with_subscription_fix.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/subscription_manager/subscription_manager.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final SubscriptionManager _subsManager = SubscriptionManager();

  ChartBloc() : super(ChartInitial()) {
    on<StartLiveFeed>((event, emit) {
      final sub = event.stream.listen((data) {
        add(LiveDataArrived(data));
      });
      _subsManager.replace(sub);
    });

    on<LiveDataArrived>((event, emit) {
      emit(ChartUpdated(event.data));
    });
  }

  @override
  Future<void> close() async {
    await _subsManager.dispose();
    return super.close();
  }
}
EOF
cat > lib/features/market/data/repository/candle_repository_with_filter.dart << 'EOF'
import '../../../../core/filters/candle_outlier_filter.dart';
import '../../../../core/models/candle_entity.dart';

class CandleRepositoryWithFilter {
  final CandleOutlierFilter filter = CandleOutlierFilter();

  Future<List<CandleEntity>> fetchCandles(String symbol, String timeframe) async {
    // مثال استرجاع من API
    final raw = await getRawCandlesFromApi(symbol, timeframe);

    // التصفية
    final cleaned = raw.where((c) => filter.isValid(c)).toList();

    return cleaned;
  }

  Future<List<CandleEntity>> getRawCandlesFromApi(String symbol, String timeframe) async {
    // Placeholder
    return [];
  }
}
EOF
cat > lib/core/network/ws/smart/ws_smart_manager.dart << 'EOF'
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../network_observer.dart';

/// Smart WS Manager: handles connect/disconnect cleanly,
/// auto‑reconnect, disposals on app pause, and prevents leaks.
class WSSmartManager {
  WebSocketChannel? _channel;
  final String url;
  final NetworkObserver _observer;
  Timer? _reconnectTimer;

  bool _connected = false;

  WSSmartManager(this.url, this._observer) {
    _observer.stream.listen((state) {
      if (state == NetState.offline) {
        _disconnect();
      } else {
        _scheduleReconnect();
      }
    });
  }

  void connect(void Function(dynamic) onData) {
    _disconnect(); // always clean before new
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen(onData,
        onError: (_) => _scheduleReconnect(),
        onDone: () => _scheduleReconnect());
    _connected = true;
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (_connected) return;
      connect((_) {});
    });
  }

  void _disconnect() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _connected = false;
  }

  void dispose() {
    _disconnect();
  }
}
EOF
cat > lib/features/market/presentation/bloc/ws/ws_manager_bloc_fix.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/ws/smart/ws_smart_manager.dart';
import '../../../../core/network/network_observer.dart';

class WSBloc extends Cubit<void> {
  final WSSmartManager manager;

  WSBloc(this.manager) : super(null);

  void start(String symbol) {
    manager.connect((data) {
      // dispatch into ChartBloc/OrderBookBloc
    });
  }

  @override
  Future<void> close() async {
    manager.dispose(); // clean
    return super.close();
  }
}
EOF
cat > lib/core/data/sanitizer/data_sanitizer.dart << 'EOF'
class DataSanitizer {
  static bool isValidNumber(dynamic v) {
    if (v == null) return false;
    if (v is num) return true;
    return num.tryParse(v.toString()) != null;
  }

  static double safeDouble(dynamic v, {double fallback = 0.0}) {
    return isValidNumber(v) ? double.parse(v.toString()) : fallback;
  }

  static bool isValidMap(Map? m) => m != null && m.isNotEmpty;
}
EOF
cat > lib/core/network/rest/parsers/safe_api_parser.dart << 'EOF'
import '../../../../core/data/sanitizer/data_sanitizer.dart';

class SafeApiParser {
  static Map<String, dynamic> parseCandle(Map<String, dynamic>? json) {
    if (json == null) return {};
    return {
      'time': json['time'] ?? '',
      'open': DataSanitizer.safeDouble(json['open']),
      'high': DataSanitizer.safeDouble(json['high']),
      'low': DataSanitizer.safeDouble(json['low']),
      'close': DataSanitizer.safeDouble(json['close']),
      'volume': DataSanitizer.safeDouble(json['volume']),
    };
  }
}
EOF
cat > lib/core/network/ws/parsers/safe_ws_parser.dart << 'EOF'
import '../../../../core/data/sanitizer/data_sanitizer.dart';

Map<String, dynamic>? safeWS(Map<String, dynamic>? data) {
  if (data == null) return null;
  if (!DataSanitizer.isValidNumber(data['price'])) return null;
  return data;
}
EOF
cat > lib/features/replay/domain/controller/replay_controller.dart << 'EOF'
import 'dart:async';

class ReplayController {
  final List<StreamSubscription> _subs = [];
  bool _isPlaying = false;

  void play(Stream stream, void Function(dynamic) onData) {
    stop();      // توقف أي تشغيل سابق
    _isPlaying = true;
    final sub = stream.listen((data) {
      if (!_isPlaying) return;
      onData(data);
    });
    _subs.add(sub);
  }

  void stop() {
    _isPlaying = false;
    for (final s in _subs) {
      s.cancel();
    }
    _subs.clear();
  }

  void dispose() => stop();
}
EOF
cat > lib/features/replay/presentation/bloc/replay_bloc_fix.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/controller/replay_controller.dart';

class ReplayBlocFix extends Bloc<ReplayEvent, ReplayState> {
  final ReplayController _ctrl = ReplayController();

  ReplayBlocFix(): super(ReplayIdle()) {
    on<StartReplay>((evt, emit) {
      _ctrl.play(evt.stream, (data) => add(ReplayTick(data)));
      emit(ReplayPlaying());
    });

    on<StopReplay>((_, emit) {
      _ctrl.stop();
      emit(ReplayStopped());
    });
  }

  @override
  Future<void> close() async {
    _ctrl.dispose();
    return super.close();
  }
}
EOF
cat > lib/features/backtest/domain/engine/backtest_engine_fix.dart << 'EOF'
import 'dart:async';

class BacktestEngineFix {
  bool _cancel = false;
  final StreamController<double> equityStream = StreamController.broadcast();

  void cancel() => _cancel = true;

  Future<void> run(List dataset) async {
    double equity = 0.0;

    for (final data in dataset) {
      if (_cancel) break;

      // update indicators safely
      final signals = computeSignals(data);

      // execute trades
      for (final sig in signals) {
        equity += executeTrade(sig);
      }

      equityStream.add(equity);

      // yield control to avoid blocking
      await Future.delayed(Duration(milliseconds: 1));
    }
  }

  void dispose() {
    equityStream.close();
  }

  List computeSignals(dynamic data) => [];
  double executeTrade(dynamic sig) => 0.0;
}
EOF
cat > lib/features/settings/domain/controllers/chart_settings_controller_fix.dart << 'EOF'
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ChartSettingsControllerFix {
  final List<Map<String, dynamic>> _undoStack = [];
  final List<Map<String, dynamic>> _redoStack = [];

  Future<void> save(Map<String, dynamic> cfg) async {
    final prefs = await SharedPreferences.getInstance();
    final backup = await load();
    if (backup != null) _undoStack.add(backup);

    await prefs.setString('chart_settings', cfg.toString());
  }

  Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString('chart_settings');
    if (str == null) return null;
    return Map<String, dynamic>.from({});
  }

  Future<void> undo() async {
    if (_undoStack.isEmpty) return;
    final last = _undoStack.removeLast();
    _redoStack.add(last);
    await save(last);
  }

  Future<void> redo() async {
    if (_redoStack.isEmpty) return;
    final last = _redoStack.removeLast();
    _undoStack.add(last);
    await save(last);
  }
}
EOF
cat > lib/core/sync/event_sync_controller.dart << 'EOF'
import 'dart:async';

/// Ensures only one update type is processed at a time.
/// Other events wait in queue.
class EventSyncController {
  final _queue = StreamController<Function()>();

  EventSyncController() {
    _queue.stream.asyncMap((task) => Future(() => task())).listen((_) {});
  }

  /// add an event to execution queue
  void addToQueue(void Function() task) {
    _queue.add(task);
  }

  Future<void> close() async {
    await _queue.close();
  }
}
EOF
cat > lib/features/market/presentation/bloc/chart_bloc_sync_fix.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/sync/event_sync_controller.dart';

class ChartBlocSyncFix extends Bloc<ChartEvent, ChartState> {
  final EventSyncController _sync = EventSyncController();

  ChartBlocSyncFix() : super(ChartInitial()) {
    on<NewLiveCandle>((event, emit) {
      _sync.addToQueue(() {
        // process candle update
        emit(ChartUpdated(event.candle));
      });
    });

    on<ZoomPanChanged>((event, emit) {
      _sync.addToQueue(() {
        // process zoom/pan update
        emit(ChartZoomed(event.range));
      });
    });
  }

  @override
  Future<void> close() async {
    await _sync.close();
    return super.close();
  }
}
EOF
cat > lib/core/network/error/network_error_handler.dart << 'EOF'
import 'dart:io';

enum NetworkErrorType {
  noConnection,
  timeout,
  serverError,
  unknown
}

class NetworkErrorHandler {
  static NetworkErrorType classify(error) {
    if (error is SocketException) {
      return NetworkErrorType.noConnection;
    } else if (error is TimeoutException) {
      return NetworkErrorType.timeout;
    } else if (error.toString().contains('500')) {
      return NetworkErrorType.serverError;
    }
    return NetworkErrorType.unknown;
  }

  static String message(NetworkErrorType type) {
    switch (type) {
      case NetworkErrorType.noConnection:
        return "لا يوجد اتصال بالإنترنت.";
      case NetworkErrorType.timeout:
        return "انتهت مهلة الاتصال.";
      case NetworkErrorType.serverError:
        return "هناك خطأ في الخادم.";
      case NetworkErrorType.unknown:
      default:
        return "حدث خطأ غير متوقع في الشبكة.";
    }
  }
}
EOF
cat > lib/features/market/data/repository/market_repository_error_fix.dart << 'EOF'
import '../../../../core/network/error/network_error_handler.dart';
import '../../../../core/network/rest_error.dart';

Future<List<CandleEntity>> safeFetchHistory(...) async {
  try {
    return await _fetchHistory(...);
  } catch (e) {
    final type = NetworkErrorHandler.classify(e);
    final message = NetworkErrorHandler.message(type);
    throw RestError(message);
  }
}
EOF
cat > lib/core/utils/debounce.dart << 'EOF'
import 'dart:async';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer(this.delay);

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
EOF
cat > lib/features/market/presentation/bloc/zoom_debounce_fix.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/debounce.dart';

class ZoomBloc extends Bloc<ZoomEvent, ZoomState> {
  final Debouncer _debouncer = Debouncer(Duration(milliseconds: 200));

  ZoomBloc(): super(ZoomIdle()) {
    on<ZoomChanged>((event, emit) {
      _debouncer(() {
        emit(ZoomUpdated(event.range));
      });
    });
  }
}
EOF
cat > lib/core/mode/app_mode_guard.dart << 'EOF'
enum AppMode { live, backtest }

class AppModeGuard {
  AppMode _current = AppMode.live;

  AppMode get current => _current;

  bool canEnterBacktest() => _current != AppMode.backtest;
  bool canEnterLive() => _current != AppMode.live;

  void enterBacktest() => _current = AppMode.backtest;
  void enterLive() => _current = AppMode.live;
}
EOF
cat > lib/features/backtest/presentation/bloc/backtest_mode_guard_fix.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/mode/app_mode_guard.dart';

class BacktestModeBloc extends Bloc<BacktestEvent, BacktestState> {
  final AppModeGuard _guard;

  BacktestModeBloc(this._guard) : super(BacktestIdle());

  void startBacktest(...) {
    if (!_guard.canEnterBacktest()) return; // لا إعادة Backtest أثناء live
    _guard.enterBacktest();
    // start backtest
  }

  void stopBacktest() {
    _guard.enterLive();
    // stop backtest
  }
}
EOF
cat > lib/core/persistence/persistent_state_manager.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PersistentStateManager {
  static Future<void> save(String key, Map<String, dynamic> state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(state));
  }

  static Future<Map<String, dynamic>?> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(key);
    return str == null ? null : jsonDecode(str);
  }

  static Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
EOF
cat > lib/core/lifecycle/app_lifecycle_manager.dart << 'EOF'
import 'package:flutter/widgets.dart';
import '../persistence/persistent_state_manager.dart';

class AppLifecycleManager extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // مثال: استعادة حال Chart
      PersistentStateManager.load("chart_state")?.then((data) {
        // dispatch to ChartBloc
      });
    }
  }
}
EOF
cat > lib/core/persistence/persistent_state_manager.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PersistentStateManager {
  static Future<void> save(String key, Map<String, dynamic> state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(state));
  }
  static Future<Map<String, dynamic>?> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(key);
    return str == null ? null : jsonDecode(str);
  }
}
EOF
cat > lib/core/time/time_normalizer.dart << 'EOF'
class TimeNormalizer {
  static DateTime toUtc(dynamic input) {
    if (input is String) return DateTime.parse(input).toUtc();
    if (input is DateTime) return input.toUtc();
    return DateTime.now().toUtc();
  }
}
EOF
cat > lib/core/time/session_filter.dart << 'EOF'
class SessionFilter {
  static bool isWithinMarketHours(DateTime utc) {
    final weekday = utc.weekday;
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) return false;
    return true;
  }
}
EOF
cat > lib/core/bloc/mixins/safe_dispose_mixin.dart << 'EOF'
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin SafeDisposeMixin on BlocBase {
  final List<StreamSubscription> _subs = [];

  void addSub(StreamSubscription sub) => _subs.add(sub);

  @override
  Future<void> close() async {
    for (final s in _subs) await s.cancel();
    _subs.clear();
    return super.close();
  }
}
EOF
cat > lib/core/state/shared/price_volume_state.dart << 'EOF'
import 'package:flutter/foundation.dart';

class PriceVolumeState with ChangeNotifier {
  double _price = 0, _volume = 0;

  double get price => _price;
  double get volume => _volume;

  void update(double p, double v) {
    _price = p;
    _volume = v;
    notifyListeners();
  }
}
EOF
cat > lib/core/network/rest/parsers/safe_map_parser.dart << 'EOF'
T? parseSafe<T>(Map<String, dynamic>? json, String key) {
  if (json == null) return null;
  final val = json[key];
  if (val == null) return null;
  return val is T ? val : null;
}
EOF
cat > lib/core/webview/webview_error_guard.dart << 'EOF'
import 'package:webview_flutter/webview_flutter.dart';

class WebViewErrorGuard {
  static void guard(WebViewController ctrl) {
    ctrl.setJavaScriptMode(JavaScriptMode.unrestricted);
    ctrl.addJavaScriptChannel(
      'ErrorGuard',
      onMessageReceived: (msg) {
        // ترسل أي خطأ أو تحذير
      },
    );
  }
}
EOF
cat > lib/features/backtest/domain/strategy/strategy_freeze_guard.dart << 'EOF'
class StrategyFreezeGuard {
  bool _frozen = false;

  void freeze() => _frozen = true;
  void unfreeze() => _frozen = false;

  bool get isFrozen => _frozen;
}
EOF
cat > lib/features/settings/data/undo_redo_storage.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UndoRedoStorage {
  static Future<void> save(String key, List<Map<String, dynamic>> states) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(states));
  }
  static Future<List<Map<String, dynamic>>?> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(key);
    if (str == null) return null;
    return (jsonDecode(str) as List).cast<Map<String, dynamic>>();
  }
}
EOF
cat > lib/core/compute/backtest_chunked_runner.dart << 'EOF'
import 'dart:isolate';

class BacktestChunkedRunner {
  static Future<void> run(List dataset, void Function(dynamic) onResult) async {
    await Isolate.run(() async {
      for (final chunk in dataset) {
        onResult(chunk);
      }
    });
  }
}
EOF
cat > lib/features/alerts/domain/alert_rate_manager.dart << 'EOF'
class AlertRateManager {
  DateTime? _lastTime;

  bool canNotify(Duration gap) {
    final now = DateTime.now();
    if (_lastTime == null || now.difference(_lastTime!) >= gap) {
      _lastTime = now;
      return true;
    }
    return false;
  }

  void reset() => _lastTime = null;
}
EOF
cat > lib/core/sync/signal_sync_controller.dart << 'EOF'
import 'dart:async';

/// Ensures that indicator values are updated before evaluating signals.
class SignalSyncController {
  final _queue = StreamController<Function()>();

  SignalSyncController() {
    _queue.stream.asyncMap((task) => Future(() => task())).listen((_) {});
  }

  void addTask(Function() task) {
    _queue.add(task);
  }

  Future<void> dispose() async {
    await _queue.close();
  }
}
EOF
cat > lib/features/strategy/domain/signal_evaluator_sync_fix.dart << 'EOF'
import '../../../../core/sync/signal_sync_controller.dart';

class StrategyEvaluatorSyncFix {
  final SignalSyncController _sync = SignalSyncController();

  void evaluate(Map<String, double> indicators, Function applySignal) {
    _sync.addTask(() {
      if (!_sync.isClosed) {
        applySignal(indicators);
      }
    });
  }

  Future<void> dispose() => _sync.dispose();
}
EOF
cat > lib/core/cache/persistent_history_cache.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PersistentHistoryCache {
  static const _keyPrefix = "history_cache_";

  static Future<void> save(String key, List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyPrefix + key, jsonEncode(data));
  }

  static Future<List<Map<String, dynamic>>?> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keyPrefix + key);
    if (str == null) return null;
    return (jsonDecode(str) as List).cast<Map<String, dynamic>>();
  }

  static Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyPrefix + key);
  }
}
EOF
cat > lib/core/chart/chart_controller_manager.dart << 'EOF'
import 'package:flutter/animation.dart';

class ChartControllerManager {
  final List<AnimationController> _controllers = [];

  void register(AnimationController c) {
    _controllers.add(c);
  }

  void disposeAll() {
    for (final c in _controllers) {
      c.dispose();
    }
    _controllers.clear();
  }
}
EOF
cat > lib/core/filters/range_filter_fix.dart << 'EOF'
import '../../core/models/candle_entity.dart';

class RangeFilterFix {
  List<CandleEntity> filterRange(
      List<CandleEntity> data, DateTime from, DateTime to) {
    return data.where((c) =>
        !c.timeUtc.isBefore(from) &&
        !c.timeUtc.isAfter(to)).toList();
  }
}
EOF
cat > lib/features/trading/domain/order_safe_guard.dart << 'EOF'
import 'order.dart';

class OrderSafeGuard {
  static bool isValid(Order? order) {
    if (order == null) return false;
    if (order.symbol.isEmpty) return false;
    if (order.lots <= 0) return false;
    return true;
  }
}
EOF
cat > lib/core/network/retry/retry_limiter.dart << 'EOF'
import 'dart:async';

class RetryLimiter {
  final int maxAttempts;
  final Duration baseDelay;

  RetryLimiter({this.maxAttempts = 3, this.baseDelay = const Duration(milliseconds: 500)});

  Future<T?> run<T>(Future<T> Function() fn) async {
    int attempts = 0;
    while (attempts < maxAttempts) {
      try {
        return await fn();
      } catch (e) {
        attempts++;
        await Future.delayed(baseDelay * attempts);
      }
    }
    return null;
  }
}
EOF
cat > lib/core/bloc/guards/async_dispose_guard.dart << 'EOF'
import 'dart:async';

class AsyncDisposeGuard {
  bool _disposing = false;
  final List<Future<void>> _pending = [];

  void track(Future<void> future) {
    if (!_disposing) _pending.add(future);
  }

  Future<void> dispose() async {
    _disposing = true;
    await Future.wait(_pending);
    _pending.clear();
  }
}
EOF
cat > lib/core/widgets/fix/repaint_boundary_chart.dart << 'EOF'
import 'package:flutter/widgets.dart';

class RepaintBoundaryChart extends StatelessWidget {
  final Widget child;

  RepaintBoundaryChart({required this.child});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: child);
  }
}
EOF
cat > lib/core/chart/update/batch_update_manager.dart << 'EOF'
import 'dart:async';

class BatchUpdateManager {
  final Duration delay;
  Timer? _timer;
  List<dynamic> _pending = [];

  BatchUpdateManager({this.delay = const Duration(milliseconds: 50)});

  void add(dynamic data, void Function(List<dynamic>) callback) {
    _pending.add(data);
    _timer?.cancel();
    _timer = Timer(delay, () {
      callback(_pending);
      _pending.clear();
    });
  }
}
EOF
cat > lib/core/market/symbol_normalizer.dart << 'EOF'
class SymbolNormalizer {
  /// يحوّل أي صيغة رمزية لـ "CONCAT" (بدون underscore)
  static String normalize(String sym) {
    return sym.replaceAll("_", "").toUpperCase();
  }

  /// يفصّل الصيغة إلى زوج/سوق
  static String formatWithUnderscore(String sym) {
    final n = normalize(sym);
    // مثال: XAUUSD → XAU_USD
    if (n.length == 6) {
      return "${n.substring(0, 3)}_${n.substring(3)}";
    }
    return sym;
  }
}
EOF
cat > lib/core/sync/compute_guard.dart << 'EOF'
import 'dart:async';

class ComputeGuard {
  bool _busy = false;

  Future<void> run(Future<void> Function() fn) async {
    while (_busy) {
      await Future.delayed(Duration(milliseconds: 5));
    }
    _busy = true;
    await fn();
    _busy = false;
  }
}
EOF
cat > lib/features/indicators/domain/indicator_engine_compute_fix.dart << 'EOF'
import '../../../../core/sync/compute_guard.dart';
import '../../../core/models/candle_entity.dart';

class IndicatorEngineComputeFix {
  final ComputeGuard _guard = ComputeGuard();

  Future<Map<String, double>> computeSafe(
      List<CandleEntity> snapshot,
      Future<Map<String, double>> Function(List<CandleEntity>) computeFn) async {
    Map<String, double> result = {};
    await _guard.run(() async {
      result = await computeFn(snapshot);
    });
    return result;
  }
}
EOF
cat > lib/core/webview/guard/webview_js_ready_guard.dart << 'EOF'
import 'package:webview_flutter/webview_flutter.dart';

class WebViewJSReadyGuard {
  static Future<void> evaluateWhenReady(
      WebViewController ctrl, String script) async {
    final ready = await ctrl
        .runJavascriptReturningResult("document.readyState === 'complete'");
    if (ready == '"complete"') {
      await ctrl.runJavascript(script);
    } else {
      ctrl.runJavascript(
          "document.addEventListener('DOMContentLoaded', function() { $script });");
    }
  }
}
EOF
cat > lib/core/network/rest/guard/safe_rest_response.dart << 'EOF'
import 'dart:convert';
import 'package:http/http.dart' as http;

class SafeRestResponse {
  static Map<String, dynamic>? parse(http.Response res) {
    if (res.statusCode != 200) return null;
    try {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
EOF
cat > lib/core/bloc/mixins/stream_controller_manager.dart << 'EOF'
import 'dart:async';

mixin StreamControllerManager {
  final List<StreamController> _controllers = [];

  StreamController<T> createController<T>({bool broadcast = false}) {
    final c = broadcast
        ? StreamController<T>.broadcast()
        : StreamController<T>();
    _controllers.add(c);
    return c;
  }

  Future<void> disposeControllers() async {
    for (final c in _controllers) {
      await c.close();
    }
    _controllers.clear();
  }
}
EOF
cat > lib/features/indicators/domain/gap/gap_aware_indicator.dart << 'EOF'
import '../../../../core/models/candle_entity.dart';

class GapAwareIndicator {
  static List<CandleEntity> fillGaps(
      List<CandleEntity> data, Duration interval) {
    if (data.isEmpty) return data;
    final List<CandleEntity> filled = [];
    for (int i = 0; i < data.length - 1; i++) {
      filled.add(data[i]);
      final diff = data[i + 1].timeUtc
          .difference(data[i].timeUtc)
          .inMilliseconds;
      if (diff > interval.inMilliseconds) {
        // Gap exists
        final count = (diff / interval.inMilliseconds).floor() - 1;
        for (int j = 1; j <= count; j++) {
          filled.add(CandleEntity(
            timeUtc: data[i].timeUtc
                .add(Duration(milliseconds: interval.inMilliseconds * j)),
            open: data[i].close,
            high: data[i].close,
            low: data[i].close,
            close: data[i].close,
            volume: 0,
          ));
        }
      }
    }
    filled.add(data.last);
    return filled;
  }
}
EOF
cat > lib/core/navigation/router_bloc_cleanup.dart << 'EOF'
import 'package:flutter/widgets.dart';

class RouterBlocCleanup extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPop(Route route, Route? previousRoute) {
    if (route is PageRoute) {
      // dispatch cleanup event to relevant Blocs
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (previousRoute is PageRoute) {
      // dispatch cleanup event
    }
  }
}
EOF
cat > lib/core/compute/isolate_task_manager.dart << 'EOF'
import 'dart:isolate';

class IsolateTaskManager {
  final List<Isolate> _isolates = [];

  Future<Isolate> spawn(Function entry) async {
    final iso = await Isolate.spawn(entry, null);
    _isolates.add(iso);
    return iso;
  }

  void killAll() {
    for (final iso in _isolates) {
      iso.kill(priority: Isolate.immediate);
    }
    _isolates.clear();
  }
}
EOF
cat > lib/core/filters/price_spike_filter.dart << 'EOF'
class PriceSpikeFilter {
  static bool isSpike(double prev, double curr, double thresholdPct) {
    final diff = (curr - prev).abs();
    final pct = (diff / prev) * 100.0;
    return pct > thresholdPct;
  }
}
EOF
cat > lib/core/localization/app_localizations.dart << 'EOF'
import 'dart:ui';

class AppLocalizations {
  static String networkError() => "Network error occurred.";
  static String unknownError() => "Unknown error.";
  static String priceInvalid() => "Invalid price data.";
  // إضافة المزيد حسب الحاجة
}
EOF
cat > lib/core/utils/settings_debouncer.dart << 'EOF'
import 'dart:async';

class SettingsDebouncer {
  final Duration delay;
  Timer? _timer;

  SettingsDebouncer({this.delay = const Duration(milliseconds: 300)});

  void save(void Function() saveFn) {
    _timer?.cancel();
    _timer = Timer(delay, saveFn);
  }
}
EOF
cat > lib/core/mode/mode_stream_manager.dart << 'EOF'
import 'dart:async';

class ModeStreamManager {
  final List<StreamSubscription> _streams = [];

  void register(StreamSubscription sub) => _streams.add(sub);

  Future<void> clearAll() async {
    for (final s in _streams) {
      await s.cancel();
    }
    _streams.clear();
  }
}
EOF
cat > lib/core/sync/rest_ws_sync_coordinator.dart << 'EOF'
import 'dart:async';

class RestWsSyncCoordinator {
  bool _historyLoaded = false;
  final List<Function()> _pendingConnectWs = [];

  void historyLoaded() {
    _historyLoaded = true;
    while (_pendingConnectWs.isNotEmpty) {
      final action = _pendingConnectWs.removeAt(0);
      action();
    }
  }

  void connectWsWhenReady(Function() connectFn) {
    if (_historyLoaded) {
      connectFn();
    } else {
      _pendingConnectWs.add(connectFn);
    }
  }
}
EOF
cat > lib/features/backtest/domain/check/preflight_check.dart << 'EOF'
import '../../../core/models/candle_entity.dart';

class BacktestPreflightCheck {
  bool validate(List<CandleEntity> history, int minCandles) {
    if (history.length < minCandles) return false;
    // أي شروط إضافية حسب الاستراتيجية
    return true;
  }
}
EOF
cat > lib/core/widgets/animation_controller_guard.dart << 'EOF'
import 'package:flutter/animation.dart';

class AnimationControllerGuard {
  final List<AnimationController> _controllers = [];

  void register(AnimationController c) => _controllers.add(c);

  void disposeAll() {
    for (final c in _controllers) {
      c.dispose();
    }
    _controllers.clear();
  }
}
EOF
cat > lib/core/network/rest/parsers/json_safe_helpers.dart << 'EOF'
T safeParse<T>(dynamic value, T fallback) {
  try {
    if (value == null) return fallback;
    if (value is T) return value;
    if (T == double) return double.tryParse(value.toString()) as T? ?? fallback;
    if (T == int) return int.tryParse(value.toString()) as T? ?? fallback;
    return fallback;
  } catch (_) {
    return fallback;
  }
}
EOF
cat > lib/core/network/ws/backoff/ws_backoff_manager.dart << 'EOF'
import 'dart:async';

class WsBackoffManager {
  int _attempts = 0;
  Timer? _timer;

  void scheduleReconnect(Function() reconnect) {
    _timer?.cancel();
    _attempts++;
    final wait = Duration(seconds: 2 * _attempts);
    _timer = Timer(wait, reconnect);
  }

  void reset() => _attempts = 0;
}
EOF
cat > lib/core/storage/shared_prefs_cleaner.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsCleaner {
  static Future<void> cleanAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
EOF
cat > lib/core/widgets/keep_alive_responsive.dart << 'EOF'
import 'package:flutter/widgets.dart';

class KeepAliveResponsive extends StatefulWidget {
  final Widget child;
  KeepAliveResponsive({required this.child});

  @override
  _KeepAliveResponsiveState createState() => _KeepAliveResponsiveState();
}

class _KeepAliveResponsiveState extends State<KeepAliveResponsive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
EOF
cat > lib/core/navigation/bloc_auto_dispose_route.dart << 'EOF'
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocAutoDisposeRoute<T> extends MaterialPageRoute<T> {
  final BlocProvider _provider;

  BlocAutoDisposeRoute({required Widget child, required BlocProvider provider})
      : _provider = provider,
        super(builder: (_) => child);

  @override
  void dispose() {
    _provider.close();
    super.dispose();
  }
}
EOF
cat > lib/core/network/rest/timeout/timeout_handler.dart << 'EOF'
import 'package:http/http.dart' as http;

class TimeoutHandler {
  final Duration timeout;

  TimeoutHandler(this.timeout);

  Future<http.Response?> run(Future<http.Response> Function() fn) async {
    try {
      return await fn().timeout(timeout);
    } catch (_) {
      return null;
    }
  }
}
EOF
cat > lib/core/bloc/mixins/side_effect_queue.dart << 'EOF'
mixin SideEffectQueue<E> on BlocBase<E> {
  final List<E> _effects = [];

  void addEffect(E effect) => _effects.add(effect);

  List<E> consumeEffects() {
    final copy = List<E>.from(_effects);
    _effects.clear();
    return copy;
  }
}
EOF
cat > lib/core/widgets/mixins/safe_widget_dispose.dart << 'EOF'
import 'dart:async';
import 'package:flutter/widgets.dart';

mixin SafeWidgetDispose<T extends StatefulWidget> on State<T> {
  final List<StreamSubscription> _subs = [];
  final List<AnimationController> _controllers = [];

  void trackSub(StreamSubscription sub) => _subs.add(sub);

  void trackController(AnimationController controller) =>
      _controllers.add(controller);

  @override
  void dispose() {
    for (final sub in _subs) sub.cancel();
    _subs.clear();
    for (final controller in _controllers) controller.dispose();
    _controllers.clear();
    super.dispose();
  }
}
EOF
cat > lib/core/ui/theme_notifier.dart << 'EOF'
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  void setMode(ThemeMode value) {
    _mode = value;
    notifyListeners();
  }
}
EOF
cat > lib/core/time/iso_date_normalizer.dart << 'EOF'
class IsoDateNormalizer {
  static String normalize(dynamic value) {
    try {
      return DateTime.parse(value.toString()).toUtc().toIso8601String();
    } catch (_) {
      return DateTime.now().toUtc().toIso8601String();
    }
  }
}
EOF
cat > lib/core/chart/data/chart_data_stitcher.dart << 'EOF'
import '../../../../core/models/candle_entity.dart';

class ChartDataStitcher {
  List<CandleEntity> merge(
      List<CandleEntity> history, List<CandleEntity> live) {
    final Map<int, CandleEntity> map = {};
    for (final c in history) {
      map[c.timeUtc.millisecondsSinceEpoch] = c;
    }
    for (final c in live) {
      map[c.timeUtc.millisecondsSinceEpoch] = c;
    }
    final keys = map.keys.toList()..sort();
    return keys.map((k) => map[k]!).toList();
  }
}
EOF
cat > lib/features/market_depth/domain/order_book_sync.dart << 'EOF'
import 'dart:async';

class OrderBookSync {
  final _queue = StreamController<Function()>();

  OrderBookSync() {
    _queue.stream.asyncMap((task) => Future(() => task())).listen((_) {});
  }

  void process(Function() updateFn) => _queue.add(updateFn);

  Future<void> dispose() async => _queue.close();
}
EOF
cat > lib/features/trading/domain/execution/slippage_guard.dart << 'EOF'
class SlippageGuard {
  final double maxSlippage; 

  SlippageGuard(this.maxSlippage);

  double apply(double price, double slippagePct) {
    final change = price * (slippagePct / 100);
    return price + change.clamp(-maxSlippage, maxSlippage);
  }
}
EOF
cat > lib/core/network/ws/security/ws_certificate_pinning.dart << 'EOF'
import 'dart:io';
import 'package:web_socket_channel/io.dart';

class WsCertPinning {
  static IOWebSocketChannel connectPinned(
      String url, SecurityContext context) {
    return IOWebSocketChannel.connect(
      url,
      customClient: HttpClient(context: context),
    );
  }
}
EOF
cat > lib/core/security/secure_storage_manager.dart << 'EOF'
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveToken(String key, String token) =>
      _storage.write(key: key, value: token);

  static Future<String?> readToken(String key) =>
      _storage.read(key: key);

  static Future<void> deleteToken(String key) =>
      _storage.delete(key: key);
}
EOF
cat > lib/core/network/rest/throttle/rest_throttle.dart << 'EOF'
import 'dart:async';

class RestThrottle {
  final Duration interval;
  DateTime _last = DateTime.fromMillisecondsSinceEpoch(0);

  RestThrottle(this.interval);

  bool canFetch() {
    if (DateTime.now().difference(_last) >= interval) {
      _last = DateTime.now();
      return true;
    }
    return false;
  }
}
EOF
cat > lib/core/state/paging/paging_guard.dart << 'EOF'
class PagingGuard {
  final Set<int> loadedPages = {};

  bool canLoad(int page) {
    if (loadedPages.contains(page)) return false;
    loadedPages.add(page);
    return true;
  }
}
EOF
cat > lib/core/network/ws/manager/ws_switch_manager.dart << 'EOF'
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WsSwitchManager {
  WebSocketChannel? _currentChannel;
  StreamSubscription? _currentSub;

  void switchTo(String url, void Function(dynamic) onData) {
    // الغاء القديم
    _currentSub?.cancel();
    _currentChannel?.sink.close();

    // فتح جديد
    _currentChannel = WebSocketChannel.connect(Uri.parse(url));
    _currentSub = _currentChannel!.stream.listen(onData);
  }

  Future<void> dispose() async {
    await _currentSub?.cancel();
    _currentChannel?.sink.close();
    _currentChannel = null;
    _currentSub = null;
  }
}
EOF
cat > lib/core/chart/gap/gap_fill_manager.dart << 'EOF'
import '../../../../core/models/candle_entity.dart';

class GapFillManager {
  static List<CandleEntity> fill(
      List<CandleEntity> data, Duration interval) {
    final List<CandleEntity> filled = [];
    if (data.isEmpty) return filled;

    for (int i = 0; i < data.length - 1; i++) {
      final current = data[i];
      final next = data[i + 1];
      filled.add(current);

      final gap = next.timeUtc
          .difference(current.timeUtc)
          .inMilliseconds;
      final step = interval.inMilliseconds;

      if (gap > step) {
        final missing = (gap / step).floor() - 1;
        for (int j = 1; j <= missing; j++) {
          final t = current.timeUtc.add(Duration(milliseconds: step * j));
          filled.add(CandleEntity(
            timeUtc: t,
            open: current.close,
            high: current.close,
            low: current.close,
            close: current.close,
            volume: 0,
          ));
        }
      }
    }
    filled.add(data.last);
    return filled;
  }
}
EOF
cat > lib/core/bloc/mixins/stream_controller_guard.dart << 'EOF'
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin StreamControllerGuard on BlocBase {
  final List<StreamController> _controllers = [];

  StreamController<T> createController<T>({bool broadcast = false}) {
    final c = broadcast
        ? StreamController<T>.broadcast()
        : StreamController<T>();
    _controllers.add(c);
    return c;
  }

  @override
  Future<void> close() async {
    for (final c in _controllers) {
      await c.close();
    }
    _controllers.clear();
    return super.close();
  }
}
EOF
cat > lib/features/market/presentation/bloc/chart/chart_state_reset.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartStateReset extends ChartEvent {}

class ChartBlocStateResetFix extends Bloc<ChartEvent, ChartState> {
  ChartBlocStateResetFix(): super(ChartIdle()) {
    on<ChartStateReset>((_, emit) {
      emit(ChartIdle()); // إعادة الحالة
    });
  }
}
EOF
cat > lib/features/market_depth/presentation/bloc/order_book_reset_fix.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBookReset extends OrderBookEvent {}

class OrderBookBlocResetFix extends Bloc<OrderBookEvent, OrderBookState> {
  OrderBookBlocResetFix(): super(OrderBookInitial()) {
    on<OrderBookReset>((_, emit) {
      emit(OrderBookInitial(bids: [], asks: []));
    });

    on<SubscribeUpdates>((event, emit) {
      add(OrderBookReset()); // تنظيف
      // بعد ذلك اشترك في Stream جديد
    });
  }
}
EOF
cat > lib/core/cache/history_cache_guard.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryCacheGuard {
  static Future<void> save(
      String symbol, String timeframe, List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "$symbol-$timeframe";
    prefs.setString(key, jsonEncode(data));
  }

  static Future<List<Map<String, dynamic>>?> load(
      String symbol, String timeframe) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "$symbol-$timeframe";
    final str = prefs.getString(key);
    if (str == null) return null;
    return (jsonDecode(str) as List).cast<Map<String, dynamic>>();
  }
}
EOF
cat > lib/features/trading/domain/execution/execution_queue.dart << 'EOF'
import 'dart:async';

class ExecutionQueue {
  final _queue = StreamController<Function()>();

  ExecutionQueue() {
    _queue.stream.asyncMap((task) => Future(() => task())).listen((_) {});
  }

  void schedule(Function() exec) => _queue.add(exec);

  Future<void> dispose() => _queue.close();
}
EOF
cat > lib/core/security/token_refresh_guard.dart << 'EOF'
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenRefreshGuard {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> refresh(String oldToken) async {
    try {
      // logic to refresh via REST
      final newToken = oldToken + "_refreshed"; 
      await _storage.write(key: "apiToken", value: newToken);
      return newToken;
    } catch (_) {
      return null;
    }
  }
}
EOF
cat > lib/features/watchlist/domain/watchlist_clean_guard.dart << 'EOF'
class WatchlistCleanGuard {
  static void clean(String symbol, Map cache) {
    cache.remove(symbol);
  }
}
EOF
cat > lib/core/compute/history_fetch_isolate.dart << 'EOF'
import 'dart:isolate';

class HistoryFetchIsolate {
  static Future<List<dynamic>> run(fetchFn) =>
      Isolate.run(() => fetchFn());
}
EOF
cat > lib/core/network/manager/network_mode_coordinator.dart << 'EOF'
import 'dart:async';
import '../network_observer.dart';

class NetworkModeCoordinator {
  bool _isOffline = false;
  final List<Function()> _onReconnectTasks = [];

  void updateState(NetState state) {
    if (state == NetState.offline) {
      _isOffline = true;
    } else {
      if (_isOffline) {
        _isOffline = false;
        _runReconnectTasks();
      }
    }
  }

  void scheduleOnReconnect(Function() task) {
    _onReconnectTasks.add(task);
  }

  void _runReconnectTasks() {
    for (final t in _onReconnectTasks) {
      t();
    }
    _onReconnectTasks.clear();
  }
}
EOF
cat > lib/features/chart/data/storage/chart_view_state_storage.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChartViewStateStorage {
  static const _key = "chart_view_state";

  static Future<void> save(Map<String, dynamic> state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(state));
  }

  static Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_key);
    return str == null ? null : jsonDecode(str);
  }
}
EOF
cat > lib/features/indicators/render/batch_indicator_renderer.dart << 'EOF'
import 'dart:ui';

class BatchIndicatorRenderer {
  void draw(Canvas canvas, Size size, List<Function(Canvas, Size)> draws) {
    for (final drawFn in draws) {
      drawFn(canvas, size);
    }
  }
}
EOF
cat > lib/core/network/rest/guard/rest_fetch_guard.dart << 'EOF'
class RestFetchGuard {
  final Map<String, dynamic> _cache = {};

  bool shouldFetch(String key) => !_cache.containsKey(key);

  void save(String key, dynamic value) => _cache[key] = value;

  dynamic get(String key) => _cache[key];
}
EOF
cat > lib/core/ui/fonts/text_style_manager.dart << 'EOF'
import 'package:flutter/material.dart';

class TextStyleManager {
  static TextStyle headline(BuildContext ctx) =>
      Theme.of(ctx).textTheme.headline6!;

  static TextStyle body(BuildContext ctx) =>
      Theme.of(ctx).textTheme.bodyText2!;
}
EOF
cat > lib/core/state/empty/empty_state.dart << 'EOF'
abstract class EmptyState {}

class LoadingState {}

class HasDataState<T> {
  final T data;
  HasDataState(this.data);
}

class NoDataState extends EmptyState {}
EOF
cat > lib/core/notifications/notification_service.dart << 'EOF'
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _flutterNotif = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _flutterNotif.initialize(settings);
  }

  Future<void> show(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      "channel_id",
      "channel_name",
      importance: Importance.max,
    );
    await _flutterNotif.show(0, title, body, NotificationDetails(android: androidDetails));
  }
}
EOF
cat > lib/core/state/paging/paging_tracker.dart << 'EOF'
class PagingTracker {
  final Set<int> _loadedPages = {};

  bool canLoad(int page) {
    if (_loadedPages.contains(page)) return false;
    _loadedPages.add(page);
    return true;
  }
}
EOF
cat > lib/core/storage/transactional_file_saver.dart << 'EOF'
import 'dart:io';

class TransactionalFileSaver {
  static Future<void> safeWrite(String path, String data) async {
    final temp = File(path + ".tmp");
    await temp.writeAsString(data);
    final original = File(path);
    await temp.rename(original.path);
  }
}
EOF
cat > lib/core/state/guard/state_transition_locker.dart << 'EOF'
class StateTransitionLocker {
  bool _processing = false;

  Future<void> safeTransition(Future<void> Function() fn) async {
    if (_processing) return;
    _processing = true;
    await fn();
    _processing = false;
  }
}
EOF
cat > lib/features/trading/domain/execution/execution_snapshot_guard.dart << 'EOF'
import '../../../../../core/state/shared/price_volume_state.dart';

class ExecutionSnapshotGuard {
  final PriceVolumeState _stateHolder;

  ExecutionSnapshotGuard(this._stateHolder);

  Map<String, double> snapshot() {
    return {
      "price": _stateHolder.price,
      "volume": _stateHolder.volume,
    };
  }
}
EOF
cat > lib/features/backtest/domain/engine/backtest_completion_guard.dart << 'EOF'
class BacktestCompletionGuard {
  bool _done = false;

  void markDone() => _done = true;
  bool get isDone => _done;

  void reset() => _done = false;
}
EOF
cat > lib/core/network/ws/parsers/safe_depth_parser.dart << 'EOF'
Map<String, dynamic>? parseSafeDepth(Map<String, dynamic>? data) {
  if (data == null) return null;
  if (!data.containsKey('bids') || !data.containsKey('asks')) return null;
  return {
    'bids': data['bids'] ?? [],
    'asks': data['asks'] ?? [],
  };
}
EOF
cat > lib/core/storage/file_write_safe.dart << 'EOF'
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
EOF
cat > lib/core/sync/indicator_throttler.dart << 'EOF'
import 'dart:async';

class IndicatorThrottler {
  final Duration delay;
  Timer? _timer;
  List<dynamic> _pending = [];

  IndicatorThrottler({this.delay = const Duration(milliseconds: 50)});

  void add(dynamic data, void Function(List<dynamic>) compute) {
    _pending.add(data);
    _timer?.cancel();
    _timer = Timer(delay, () {
      compute(_pending);
      _pending.clear();
    });
  }
}
EOF
cat > lib/core/network/ws/registry/ws_subscription_registry.dart << 'EOF'
import 'dart:async';

class WsSubscriptionRegistry {
  final List<StreamSubscription> _subs = [];

  void register(StreamSubscription sub) => _subs.add(sub);

  Future<void> clearAll() async {
    for (final sub in _subs) {
      await sub.cancel();
    }
    _subs.clear();
  }
}
EOF
cat > lib/core/startup/loading_coordinator.dart << 'EOF'
class LoadingCoordinator {
  bool _done = false;

  void markDone() => _done = true;
  bool get isDone => _done;
}
EOF
cat > lib/features/trading/presentation/bloc/orders_update_guard.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersUpdateGuardBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersUpdateGuardBloc(): super(OrdersIdle()) {
    on<OrderExecuted>((evt, emit) {
      // immediate update after execution
      emit(OrdersUpdated(evt.updatedList));
    });
  }
}
EOF
cat > lib/core/chart/filter/chart_filter_fix.dart << 'EOF'
import '../../core/models/candle_entity.dart';

class ChartFilterFix {
  static List<CandleEntity> applyRange(
      List<CandleEntity> data, double minPrice, double maxPrice) {
    return data.where((c) =>
        c.high >= minPrice && c.low <= maxPrice).toList();
  }
}
EOF
cat > lib/core/models/factories/candle_factory.dart << 'EOF'
import '../candle_entity.dart';

class CandleFactory {
  static CandleEntity fromJson(Map<String, dynamic>? json) {
    return CandleEntity(
      timeUtc: DateTime.tryParse(json?['time'] ?? '') ?? DateTime.now().toUtc(),
      open: (json?['open'] as num?)?.toDouble() ?? 0.0,
      high: (json?['high'] as num?)?.toDouble() ?? 0.0,
      low: (json?['low'] as num?)?.toDouble() ?? 0.0,
      close: (json?['close'] as num?)?.toDouble() ?? 0.0,
      volume: (json?['volume'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
EOF
cat > lib/features/chart/domain/drawing/draw_tool_mapping_fix.dart << 'EOF'
import 'package:flutter/material.dart';

class DrawToolMappingFix {
  static Offset toScreen(
      {required DateTime time,
      required double price,
      required DateTime start,
      required DateTime end,
      required double minPrice,
      required double maxPrice,
      required Size size}) {
    final px = (time.millisecondsSinceEpoch - start.millisecondsSinceEpoch) /
        (end.millisecondsSinceEpoch - start.millisecondsSinceEpoch);
    final py = (price - minPrice) / (maxPrice - minPrice);

    return Offset(px * size.width, (1 - py) * size.height);
  }

  static Map<String, dynamic> fromScreen(Offset point, Size size,
      DateTime start, DateTime end, double minPrice, double maxPrice) {
    final px = point.dx / size.width;
    final py = 1 - (point.dy / size.height);

    final time = DateTime.fromMillisecondsSinceEpoch(
        start.millisecondsSinceEpoch +
            (end.millisecondsSinceEpoch - start.millisecondsSinceEpoch) *
                px.toInt());
    final price = minPrice + (maxPrice - minPrice) * py;
    return {"time": time, "price": price};
  }
}
EOF
cat > lib/features/trading/domain/simulation/sim_order_ring_buffer.dart << 'EOF'
class SimOrderRingBuffer<T> {
  final int capacity;
  final List<T> _vals = [];
  int _idx = 0;

  SimOrderRingBuffer(this.capacity);

  void add(T val) {
    if (_vals.length < capacity) {
      _vals.add(val);
    } else {
      _vals[_idx] = val;
      _idx = (_idx + 1) % capacity;
    }
  }

  List<T> list() => List.unmodifiable(_vals);
}
EOF
cat > lib/core/network/ws/smart/ws_smart_reconnect_fix.dart << 'EOF'
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WSSmartReconnectFix {
  WebSocketChannel? _chan;
  final String url;
  Timer? _retry;
  int _fails = 0;

  WSSmartReconnectFix(this.url);

  void connect(void Function(dynamic) onData) {
    _chan?.sink.close();
    _chan = WebSocketChannel.connect(Uri.parse(url));
    _chan!.stream.listen(onData, onError: (_) => scheduleReconnect(onData),
        onDone: () => scheduleReconnect(onData));
    _fails = 0;
  }

  void scheduleReconnect(void Function(dynamic) onData) {
    _retry?.cancel();
    _fails++;
    final delay = Duration(seconds: 2 * _fails);
    _retry = Timer(delay, () => connect(onData));
  }

  void dispose() {
    _retry?.cancel();
    _chan?.sink.close();
  }
}
EOF
cat > lib/core/bloc/mixins/event_guard.dart << 'EOF'
mixin EventGuard<T> {
  bool isValidEvent(T event) {
    if (event == null) return false;
    return true;
  }
}
EOF
cat > lib/core/models/adapters/candle_entity_adapter.dart << 'EOF'
import 'package:hive/hive.dart';
import '../candle_entity.dart';

class CandleEntityAdapter extends TypeAdapter<CandleEntity> {
  @override
  final typeId = 1;

  @override
  CandleEntity read(BinaryReader reader) {
    return CandleEntity(
      timeUtc: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      open: reader.readDouble(),
      high: reader.readDouble(),
      low: reader.readDouble(),
      close: reader.readDouble(),
      volume: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, CandleEntity obj) {
    writer.writeInt(obj.timeUtc.millisecondsSinceEpoch);
    writer.writeDouble(obj.open);
    writer.writeDouble(obj.high);
    writer.writeDouble(obj.low);
    writer.writeDouble(obj.close);
    writer.writeDouble(obj.volume);
  }
}
EOF
cat > lib/core/bloc/bloc_observer.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // debugPrint('Bloc Event: $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // debugPrint('Bloc Change: $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // debugPrint('Bloc Error: $error');
  }
}
EOF
cat > lib/core/di/dependency_injection.dart << 'EOF'
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final injector = GetIt.instance;

Future<void> setupDependencies() async {
  // Storage
  injector.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  // Hive Boxes
  await Hive.openBox('app_settings');
  await Hive.openBox('history_cache');

  // Add other deps as needed e.g.
  // injector.registerSingleton<ApiService>(ApiService());
}
EOF
cat > lib/core/di/hive_init.dart << 'EOF'
import 'package:hive_flutter/hive_flutter.dart';

import '../models/adapters/candle_entity_adapter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(CandleEntityAdapter());
}
EOF
cat > lib/core/navigation/app_router.dart << 'EOF'
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/chart/presentation/pages/chart_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/trading/presentation/pages/trading_page.dart';
import '../../features/backtest/presentation/pages/backtest_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      name: 'chart',
      path: '/chart',
      builder: (context, state) => ChartPage(),
    ),
    GoRoute(
      name: 'settings',
      path: '/settings',
      builder: (context, state) => SettingsPage(),
    ),
    GoRoute(
      name: 'trading',
      path: '/trading',
      builder: (context, state) => TradingPage(),
    ),
    GoRoute(
      name: 'backtest',
      path: '/backtest',
      builder: (context, state) => BacktestPage(),
    ),
  ],
);
EOF
cat > lib/core/ui/theme_setup.dart << 'EOF'
import 'package:flutter/material.dart';

final lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
);

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.blueGrey,
);
EOF
cat > lib/core/startup/loading_coordinator.dart << 'EOF'
class LoadingCoordinator {
  bool isDone = false;

  void complete() {
    isDone = true;
  }
}
EOF
cat > lib/features/home/presentation/pages/home_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => context.go('/chart'),
                child: Text("Open Chart")),
            ElevatedButton(
                onPressed: () => context.go('/settings'),
                child: Text("Settings")),
            ElevatedButton(
                onPressed: () => context.go('/trading'),
                child: Text("Trading")),
            ElevatedButton(
                onPressed: () => context.go('/backtest'),
                child: Text("Backtest")),
          ],
        ),
      ),
    );
  }
}
EOF
cat > lib/features/chart/presentation/pages/chart_page.dart << 'EOF'
import 'package:flutter/material.dart';

class ChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chart Screen"),
      ),
      body: Center(child: Text("Chart Functionality Placeholder")),
    );
  }
}
EOF
cat > lib/features/settings/presentation/pages/settings_page.dart << 'EOF'
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(child: Text("Settings Placeholder")),
    );
  }
}
EOF
cat > lib/features/trading/presentation/pages/trading_page.dart << 'EOF'
import 'package:flutter/material.dart';

class TradingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trading"),
      ),
      body: Center(child: Text("Trading Functionality Placeholder")),
    );
  }
}
EOF
cat > lib/features/backtest/presentation/pages/backtest_page.dart << 'EOF'
import 'package:flutter/material.dart';

class BacktestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backtest"),
      ),
      body: Center(child: Text("Backtest Placeholder")),
    );
  }
}
EOF
cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/bloc/bloc_observer.dart';
import 'core/di/dependency_injection.dart';
import 'core/di/hive_init.dart';
import 'core/navigation/app_router.dart';
import 'core/ui/theme_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bloc Observer
  Bloc.observer = AppBlocObserver();

  // Setup Dependencies
  await initHive();
  await setupDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Trading App',
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
EOF
cat > lib/core/network/oanda/oanda_config.dart << 'EOF'
class OandaConfig {
  static const String restBaseUrl = "https://api-fxpractice.oanda.com/v3";
  static const String streamBaseUrl = "https://stream-fxpractice.oanda.com/v3";
  static const String tokenKey = "oanda_token";
  static const String accountKey = "oanda_account";
}
EOF
cat > lib/core/security/secure_storage_manager.dart << 'EOF'
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveOandaToken(String token) =>
      _storage.write(key: OandaConfig.tokenKey, value: token);

  static Future<String?> readOandaToken() =>
      _storage.read(key: OandaConfig.tokenKey);

  static Future<void> saveOandaAccount(String id) =>
      _storage.write(key: OandaConfig.accountKey, value: id);

  static Future<String?> readOandaAccount() =>
      _storage.read(key: OandaConfig.accountKey);
}
EOF
cat > lib/core/network/oanda/client/oanda_rest_client.dart << 'EOF'
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../oanda_config.dart';
import '../../../core/security/secure_storage_manager.dart';

class OandaRestClient {
  Future<http.Response> _call(String url) async {
    final token = await SecureStorageManager.readOandaToken();
    final headers = {
      "Authorization": "Bearer \$token",
      "Content-Type": "application/json",
    };
    return http.get(Uri.parse(url), headers: headers);
  }

  Future<List<String>> fetchInstruments() async {
    final accountId = await SecureStorageManager.readOandaAccount();
    final url =
        "\${OandaConfig.restBaseUrl}/accounts/\$accountId/instruments";
    final res = await _call(url);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final list = json["instruments"] as List;
      return list.map((i) => i["name"].toString()).toList();
    }
    throw Exception("OANDA fetchInstruments failed: \${res.body}");
  }

  Future<List<Map<String, dynamic>>> fetchCandles(
      String symbol, String granularity) async {
    final accountId = await SecureStorageManager.readOandaAccount();
    final url =
        "\${OandaConfig.restBaseUrl}/instruments/\$symbol/candles?granularity=\$granularity&count=500";
    final res = await _call(url);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final candles = json["candles"] as List;
      return candles.map((c) => c as Map<String, dynamic>).toList();
    }
    throw Exception("OANDA fetchCandles failed: \${res.body}");
  }
}
EOF
cat > lib/core/network/oanda/stream/oanda_stream_client.dart << 'EOF'
import 'package:web_socket_channel/web_socket_channel.dart';
import '../oanda_config.dart';
import '../../../core/security/secure_storage_manager.dart';

class OandaStreamClient {
  WebSocketChannel? _channel;

  void connect(String symbol, Function(dynamic

// ========================================

// ==== Code Block 1706 ====
cat > lib/core/network/oanda/stream/oanda_ws_client.dart << 'EOF'
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../oanda_config.dart';
import '../../../core/security/secure_storage_manager.dart';

class OandaWSClient {
  WebSocketChannel? _channel;
  StreamSubscription? _subs;

  void connect(String symbol, void Function(dynamic) onData,
      {void Function()? onDone, void Function(dynamic)? onError}) async {
    final token = await SecureStorageManager.readOandaToken();
    final url =
        "\${OandaConfig.streamBaseUrl}/accounts/\${await SecureStorageManager.readOandaAccount()}/pricing/stream?instruments=\$symbol";
    _channel = WebSocketChannel.connect(
      Uri.parse(url),
      headers: {"Authorization": "Bearer \$token"},
    );

    _subs = _channel!.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
    );
  }

  void disconnect() {
    _subs?.cancel();
    _channel?.sink.close();
  }
}
EOF
cat > lib/features/market/data/oanda_market_repository.dart << 'EOF'
import '../../../../core/network/oanda/client/oanda_rest_client.dart';
import '../../../../core/network/oanda/stream/oanda_ws_client.dart';

class OandaMarketRepository {
  final OandaRestClient _rest = OandaRestClient();
  final OandaWSClient _ws = OandaWSClient();

  Future<List<String>> getInstruments() => _rest.fetchInstruments();

  Future<List<Map<String, dynamic>>> getCandles(
          String symbol, String timeframe) =>
      _rest.fetchCandles(symbol, timeframe);

  void subscribePricing(String symbol, void Function(dynamic) onData) {
    _ws.connect(symbol, onData);
  }

  void unsubscribe() {
    _ws.disconnect();
  }
}
EOF
cat > lib/features/market/presentation/bloc/oanda/oanda_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/oanda_market_repository.dart';

part 'oanda_event.dart';
part 'oanda_state.dart';

class OandaBloc extends Bloc<OandaEvent, OandaState> {
  final OandaMarketRepository repo;

  OandaBloc(this.repo) : super(OandaInitial()) {
    on<LoadInstruments>((_, emit) async {
      emit(OandaLoading());
      try {
        final list = await repo.getInstruments();
        emit(OandaLoaded(list));
      } catch (e) {
        emit(OandaError(e.toString()));
      }
    });
  }
}
EOF
cat > lib/features/market/presentation/bloc/oanda/oanda_event.dart << 'EOF'
part of 'oanda_bloc.dart';

abstract class OandaEvent {}
class LoadInstruments extends OandaEvent {}
EOF
cat > lib/features/market/presentation/bloc/oanda/oanda_state.dart << 'EOF'
part of 'oanda_bloc.dart';

abstract class OandaState {}
class OandaInitial extends OandaState {}
class OandaLoading extends OandaState {}
class OandaLoaded extends OandaState {
  final List<String> instruments;
  OandaLoaded(this.instruments);
}
class OandaError extends OandaState {
  final String message;
  OandaError(this.message);
}
EOF
cat > lib/features/chart/presentation/bloc/candles_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../market/data/oanda_market_repository.dart';

part 'candles_event.dart';
part 'candles_state.dart';

class CandlesBloc extends Bloc<CandlesEvent, CandlesState> {
  final OandaMarketRepository repo;

  CandlesBloc(this.repo) : super(CandlesInitial()) {
    on<LoadCandles>((event, emit) async {
      emit(CandlesLoading());
      try {
        final data = await repo.getCandles(event.symbol, event.timeframe);
        emit(CandlesLoaded(data));
      } catch (e) {
        emit(CandlesError(e.toString()));
      }
    });
  }
}
EOF
cat > lib/features/chart/presentation/bloc/candles_event.dart << 'EOF'
part of 'candles_bloc.dart';

abstract class CandlesEvent {}
class LoadCandles extends CandlesEvent {
  final String symbol;
  final String timeframe;
  LoadCandles(this.symbol, this.timeframe);
}
EOF
cat > lib/features/chart/presentation/bloc/candles_state.dart << 'EOF'
part of 'candles_bloc.dart';

abstract class CandlesState {}
class CandlesInitial extends CandlesState {}
class CandlesLoading extends CandlesState {}
class CandlesLoaded extends CandlesState {
  final List<Map<String, dynamic>> raw;
  CandlesLoaded(this.raw);
}
class CandlesError extends CandlesState {
  final String message;
  CandlesError(this.message);
}
EOF
cat > lib/features/settings/presentation/pages/settings_page.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../../core/security/secure_storage_manager.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _tokenCtrl = TextEditingController();
  final _accCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    SecureStorageManager.readOandaToken().then((t) {
      if (t != null) _tokenCtrl.text = t;
    });
    SecureStorageManager.readOandaAccount().then((a) {
      if (a != null) _accCtrl.text = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OANDA Settings")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: _tokenCtrl,
            decoration: InputDecoration(labelText: "API Token"),
          ),
          TextField(
            controller: _accCtrl,
            decoration: InputDecoration(labelText: "Account ID"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await SecureStorageManager.saveOandaToken(_tokenCtrl.text);
              await SecureStorageManager.saveOandaAccount(_accCtrl.text);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Saved OANDA Credentials")));
            },
            child: Text("Save"),
          ),
        ]),
      ),
    );
  }
}
EOF
cat > lib/features/home/presentation/pages/home_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/market/presentation/bloc/oanda/oanda_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () =>
                  context.go('/settings'),
              child: Text("Settings")),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () =>
                context.read<OandaBloc>().add(LoadInstruments()),
            child: Text("Fetch OANDA Instruments"),
          ),
          Expanded(
            child: BlocBuilder<OandaBloc, OandaState>(
              builder: (context, state) {
                if (state is OandaLoading)
                  return Center(child: CircularProgressIndicator());
                if (state is OandaLoaded)
                  return ListView.builder(
                    itemCount: state.instruments.length,
                    itemBuilder: (context, i) => ListTile(
                      title: Text(state.instruments[i]),
                      onTap: () => context.go('/chart',
                          extra: state.instruments[i]),
                    ),
                  );
                if (state is OandaError)
                  return Center(child: Text(state.message));
                return Center(child: Text("No Data"));
              },
            ),
          )
        ],
      ),
    );
  }
}
EOF
cat > lib/features/chart/presentation/pages/chart_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/bloc/candles_bloc.dart';

class ChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String symbol =
        ModalRoute.of(context)?.settings.arguments as String? ?? "";
    return Scaffold(
      appBar: AppBar(title: Text("Chart: \$symbol")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context
                .read<CandlesBloc>()
                .add(LoadCandles(symbol, "M1")),
            child: Text("Load 1m Candles"),
          ),
          Expanded(
            child: BlocBuilder<CandlesBloc, CandlesState>(
              builder: (context, state) {
                if (state is CandlesLoading)
                  return Center(child: CircularProgressIndicator());
                if (state is CandlesLoaded) {
                  return ListView.builder(
                    itemCount: state.raw.length,
                    itemBuilder: (ctx, i) {
                      final c = state.raw[i];
                      return ListTile(
                        title: Text(
                            "\${c["time"]} O: \${c["open"]} C: \${c["close"]}"),
                      );
                    },
                  );
                }
                if (state is CandlesError)
                  return Center(child: Text(state.message));
                return Center(child: Text("No Data"));
              },
            ),
          )
        ],
      ),
    );
  }
}
EOF
cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/bloc/bloc_observer.dart';
import 'core/di/dependency_injection.dart';
import 'core/di/hive_init.dart';
import 'core/navigation/app_router.dart';
import 'core/ui/theme_setup.dart';

import 'features/market/presentation/bloc/oanda/oanda_bloc.dart';
import 'features/market/data/oanda_market_repository.dart';
import 'features/chart/presentation/bloc/candles_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  await initHive();
  await setupDependencies();

  final repo = OandaMarketRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OandaBloc(repo)),
        BlocProvider(create: (_) => CandlesBloc(repo)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Trading App',
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
EOF
cat > assets/lightweight_charts/chart.html << 'EOF'
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <script src="lightweight-charts.standalone.production.js"></script>
    <style>
      html, body { margin:0; padding:0; overflow:hidden; }
      #chart { width:100%; height:100%; }
    </style>
  </head>
  <body>
    <div id="chart"></div>
    <script>
      const chart = LightweightCharts.createChart(document.getElementById('chart'), {
        layout: { backgroundColor: 'white', textColor: 'black' },
      });

      const candleSeries = chart.addCandlestickSeries({
        upColor: '#26a69a', downColor: '#ef5350',
        wickUpColor: '#26a69a', wickDownColor: '#ef5350'
      });

      function setCandles(data) {
        candleSeries.setData(data);
      }

      function updateLastCandle(candle) {
        candleSeries.update(candle);
      }
    </script>
  </body>
</html>
EOF
cat > lib/features/chart/presentation/widgets/chart_webview.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartWebView extends StatefulWidget {
  final List<Map<String, dynamic>> initialCandles;
  ChartWebView({required this.initialCandles});

  @override
  _ChartWebViewState createState() => _ChartWebViewState();
}

class _ChartWebViewState extends State<ChartWebView> {
  late WebViewController _ctrl;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'about:blank',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) async {
        _ctrl = controller;
        await controller.loadFlutterAsset("assets/lightweight_charts/chart.html");
        _setInitialData();
      },
    );
  }

  void _setInitialData() {
    final data = widget.initialCandles.map((c) {
      return {
        "time": c["time"],
        "open": c["open"],
        "high": c["high"],
        "low": c["low"],
        "close": c["close"]
      };
    }).toList();
    final js = "setCandles(${data.toString()});";
    _ctrl.runJavascript(js);
  }

  void updateLive(Map<String, dynamic> candle) {
    final js = "updateLastCandle(${candle.toString()});";
    _ctrl.runJavascript(js);
  }
}
EOF
cat > lib/features/chart/presentation/bloc/live_chart/live_chart_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';

part 'live_chart_event.dart';
part 'live_chart_state.dart';

class LiveChartBloc extends Bloc<LiveChartEvent, LiveChartState> {
  LiveChartBloc(): super(LiveChartInitial());

  on<LoadLiveCandles>((event, emit) {
    emit(LiveChartLoaded(event.candles));
  });

  on<UpdateLiveCandle>((event, emit) {
    emit(LiveCandleUpdated(event.candle));
  });
}
EOF
cat > lib/features/chart/presentation/bloc/live_chart/live_chart_event.dart << 'EOF'
part of 'live_chart_bloc.dart';

abstract class LiveChartEvent {}
class LoadLiveCandles extends LiveChartEvent {
  final List<Map<String, dynamic>> candles;
  LoadLiveCandles(this.candles);
}
class UpdateLiveCandle extends LiveChartEvent {
  final Map<String, dynamic> candle;
  UpdateLiveCandle(this.candle);
}
EOF
cat > lib/features/chart/presentation/bloc/live_chart/live_chart_state.dart << 'EOF'
part of 'live_chart_bloc.dart';

abstract class LiveChartState {}
class LiveChartInitial extends LiveChartState {}
class LiveChartLoaded extends LiveChartState {
  final List<Map<String, dynamic>> candles;
  LiveChartLoaded(this.candles);
}
class LiveCandleUpdated extends LiveChartState {
  final Map<String, dynamic> candle;
  LiveCandleUpdated(this.candle);
}
EOF
cat > lib/features/chart/presentation/pages/chart_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/live_chart/live_chart_bloc.dart';
import '../widgets/chart_webview.dart';

class ChartPage extends StatelessWidget {
  final String symbol;
  ChartPage({required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chart: \$symbol")),
      body: BlocBuilder<LiveChartBloc, LiveChartState>(
        builder: (context, state) {
          if (state is LiveChartLoaded) {
            return ChartWebView(initialCandles: state.candles);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
EOF
cat > lib/features/indicators/domain/ema_calculator.dart << 'EOF'
class EmaCalculator {
  final int period;
  late double _multiplier;
  double? _prevEma;

  EmaCalculator(this.period) {
    _multiplier = 2.0 / (period + 1);
  }

  double calculate(double price) {
    if (_prevEma == null) {
      _prevEma = price;
    } else {
      _prevEma = (price - _prevEma!) * _multiplier + _prevEma!;
    }
    return _prevEma!;
  }

  void reset() {
    _prevEma = null;
  }
}
EOF
cat > lib/features/indicators/domain/rsi_calculator.dart << 'EOF'
class RsiCalculator {
  final int period;
  final List<double> _gains = [];
  final List<double> _losses = [];

  RsiCalculator(this.period);

  double? calculate(double prevClose, double close) {
    final diff = close - prevClose;
    final gain = diff > 0 ? diff : 0;
    final loss = diff < 0 ? -diff : 0;

    _gains.add(gain);
    _losses.add(loss);

    if (_gains.length > period) {
      _gains.removeAt(0);
      _losses.removeAt(0);
    }

    if (_gains.length < period) return null;

    final avgGain =
        _gains.reduce((a, b) => a + b) / _gains.length;
    final avgLoss =
        _losses.reduce((a, b) => a + b) / _losses.length;

    final rs = avgLoss == 0 ? 100 : avgGain / avgLoss;
    return 100 - (100 / (1 + rs));
  }

  void reset() {
    _gains.clear();
    _losses.clear();
  }
}
EOF
cat > lib/features/indicators/presentation/bloc/indicators_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';

part 'indicators_event.dart';
part 'indicators_state.dart';

class IndicatorsBloc
    extends Bloc<IndicatorsEvent, IndicatorsState> {
  IndicatorsBloc() : super(IndicatorsInitial()) {
    on<CalculateIndicators>((event, emit) {
      emit(IndicatorsCalculating());
      final emaShort = event.emaShort;
      final emaLong = event.emaLong;
      final rsi = event.rsi;
      emit(IndicatorsLoaded(
        emaShort: emaShort,
        emaLong: emaLong,
        rsi: rsi,
      ));
    });
  }
}
EOF
cat > lib/features/indicators/presentation/bloc/indicators_event.dart << 'EOF'
part of 'indicators_bloc.dart';

abstract class IndicatorsEvent {}

class CalculateIndicators extends IndicatorsEvent {
  final List<double> emaShort;
  final List<double> emaLong;
  final List<double> rsi;

  CalculateIndicators({
    required this.emaShort,
    required this.emaLong,
    required this.rsi,
  });
}
EOF
cat > lib/features/indicators/presentation/bloc/indicators_state.dart << 'EOF'
part of 'indicators_bloc.dart';

abstract class IndicatorsState {}

class IndicatorsInitial extends IndicatorsState {}

class IndicatorsCalculating extends IndicatorsState {}

class IndicatorsLoaded extends IndicatorsState {
  final List<double> emaShort;
  final List<double> emaLong;
  final List<double> rsi;

  IndicatorsLoaded({
    required this.emaShort,
    required this.emaLong,
    required this.rsi,
  });
}
EOF
cat > assets/lightweight_charts/chart.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <script src="lightweight-charts.standalone.production.js"></script>
  <style>
    html, body, #chart {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      overflow: hidden;
    }
  </style>
</head>
<body>
  <div id="chart"></div>

  <script>
    const chart = LightweightCharts.createChart(document.getElementById('chart'), {
      layout: { backgroundColor: '#ffffff', textColor: '#000000' },
      rightPriceScale: { borderColor: '#ccc' },
      timeScale: { borderColor: '#ccc' },
    });

    const candleSeries = chart.addCandlestickSeries({
      upColor: '#26a69a', downColor: '#ef5350',
      wickUpColor: '#26a69a', wickDownColor: '#ef5350',
    });

    const emaShortSeries = chart.addLineSeries({
      color: '#2962FF', lineWidth: 2
    });

    const emaLongSeries = chart.addLineSeries({
      color: '#FF6D00', lineWidth: 2
    });

    const rsiChart = LightweightCharts.createChart(document.body, {
      width: document.body.clientWidth,
      height: 150,
    });
    const rsiSeries = rsiChart.addLineSeries({ color: '#8E24AA', lineWidth: 2 });

    window.setCandles = function(data) {
      candleSeries.setData(data);
    }

    window.updateLastCandle = function(candle) {
      candleSeries.update(candle);
    }

    window.setEmaShort = function(data) {
      emaShortSeries.setData(data);
    }

    window.setEmaLong = function(data) {
      emaLongSeries.setData(data);
    }

    window.setRsi = function(data) {
      rsiSeries.setData(data);
    }
  </script>
</body>
</html>
EOF
cat > lib/features/chart/presentation/widgets/chart_webview.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartWebView extends StatefulWidget {
  final List<Map<String, dynamic>> candles;
  final List<Map<String, dynamic>> emaShort;
  final List<Map<String, dynamic>> emaLong;
  final List<Map<String, dynamic>> rsi;

  ChartWebView({
    required this.candles,
    required this.emaShort,
    required this.emaLong,
    required this.rsi,
  });

  @override
  _ChartWebViewState createState() => _ChartWebViewState();
}

class _ChartWebViewState extends State<ChartWebView> {
  late WebViewController _ctrl;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'about:blank',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) async {
        _ctrl = controller;
        await controller.loadFlutterAsset("assets/lightweight_charts/chart.html");
        _setInitialData();
      },
    );
  }

  void _setInitialData() {
    _runJs("setCandles(${widget.candles});");
    _runJs("setEmaShort(${widget.emaShort});");
    _runJs("setEmaLong(${widget.emaLong});");
    _runJs("setRsi(${widget.rsi});");
  }

  void updateLastCandle(Map<String, dynamic> candle) {
    _runJs("updateLastCandle($candle);");
  }

  void _runJs(String script) {
    _ctrl.runJavascript(script);
  }
}
EOF
cat > lib/features/chart/presentation/bloc/live_chart/live_chart_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';

part 'live_chart_event.dart';
part 'live_chart_state.dart';

class LiveChartBloc extends Bloc<LiveChartEvent, LiveChartState> {
  LiveChartBloc() : super(LiveChartInitial());

  on<LoadLiveCandles>((event, emit) {
    emit(LiveChartLoaded(
      candles: event.candles,
      emaShort: event.emaShort,
      emaLong: event.emaLong,
      rsi: event.rsi,
    ));
  });

  on<UpdateLiveCandle>((event, emit) {
    final state = this.state;
    if (state is LiveChartLoaded) {
      final updatedCandles = List.from(state.candles);
      if (updatedCandles.isNotEmpty) {
        updatedCandles.removeLast();
      }
      updatedCandles.add(event.candle);

      emit(LiveChartLoaded(
        candles: updatedCandles,
        emaShort: event.emaShort,
        emaLong: event.emaLong,
        rsi: event.rsi,
      ));
    }
  });
}
EOF
cat > lib/features/chart/presentation/bloc/live_chart/live_chart_event.dart << 'EOF'
part of 'live_chart_bloc.dart';

abstract class LiveChartEvent {}

class LoadLiveCandles extends LiveChartEvent {
  final List<Map<String, dynamic>> candles;
  final List<Map<String, dynamic>> emaShort;
  final List<Map<String, dynamic>> emaLong;
  final List<Map<String, dynamic>> rsi;

  LoadLiveCandles({
    required this.candles,
    required this.emaShort,
    required this.emaLong,
    required this.rsi,
  });
}

class UpdateLiveCandle extends LiveChartEvent {
  final Map<String, dynamic> candle;
  final List<Map<String, dynamic>> emaShort;
  final List<Map<String, dynamic>> emaLong;
  final List<Map<String, dynamic>> rsi;

  UpdateLiveCandle({
    required this.candle,
    required this.emaShort,
    required this.emaLong,
    required this.rsi,
  });
}
EOF
cat > lib/features/chart/presentation/bloc/live_chart/live_chart_state.dart << 'EOF'
part of 'live_chart_bloc.dart';

abstract class LiveChartState {}

class LiveChartInitial extends LiveChartState {}

class LiveChartLoaded extends LiveChartState {
  final List<Map<String, dynamic>> candles;
  final List<Map<String, dynamic>> emaShort;
  final List<Map<String, dynamic>> emaLong;
  final List<Map<String, dynamic>> rsi;

  LiveChartLoaded({
    required this.candles,
    required this.emaShort,
    required this.emaLong,
    required this.rsi,
  });
}
EOF
cat > lib/features/chart/presentation/pages/chart_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/chart_webview.dart';
import '../../presentation/bloc/live_chart/live_chart_bloc.dart';

class ChartPage extends StatelessWidget {
  final String symbol;
  ChartPage({required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chart: \$symbol")),
      body: BlocBuilder<LiveChartBloc, LiveChartState>(
        builder: (context, state) {
          if (state is LiveChartLoaded) {
            return ChartWebView(
              candles: state.candles,
              emaShort: state.emaShort,
              emaLong: state.emaLong,
              rsi: state.rsi,
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
EOF
cat > lib/features/market/domain/aggregator/candle_aggregator.dart << 'EOF'
import 'dart:collection';

class LiveCandle {
  final int time; // unix seconds
  double open;
  double high;
  double low;
  double close;

  LiveCandle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  Map<String, dynamic> toMap() {
    return {
      "time": time,
      "open": open,
      "high": high,
      "low": low,
      "close": close,
    };
  }
}

class CandleAggregator {
  LiveCandle? _currentCandle;
  final Duration timeframe;
  final Queue<Map<String, dynamic>> _pendingTicks = Queue();

  CandleAggregator(this.timeframe);

  /// يحوّل Timestamp إلى بداية الشمعة الصحيحة
  int _alignTime(int unixSeconds) {
    final bucket = timeframe.inSeconds;
    return (unixSeconds ~/ bucket) * bucket;
  }

  /// يستقبل Tick ويحدّث الشمعة أو ينشئ واحدة جديدة
  LiveCandle processTick(Map<String, dynamic> tick) {
    final int ts = tick["time"] as int;
    final double price = tick["price"] as double;
    final alignedTime = _alignTime(ts);

    // إذا لا توجد شمعة حالية -> أنشئها
    if (_currentCandle == null) {
      _currentCandle = LiveCandle(
        time: alignedTime,
        open: price,
        high: price,
        low: price,
        close: price,
      );
      return _currentCandle!;
    }

    // إذا تغيّر إطار الزمن -> أغلق القديمة وابدأ جديدة
    if (_currentCandle!.time != alignedTime) {
      final closed = _currentCandle!;
      _currentCandle = LiveCandle(
        time: alignedTime,
        open: price,
        high: price,
        low: price,
        close: price,
      );
      return closed; // نعيد الشمعة المغلقة أولًا
    }

    // تحديث الشمعة الحالية
    _currentCandle!.high =
        price > _currentCandle!.high ? price : _currentCandle!.high;
    _currentCandle!.low =
        price < _currentCandle!.low ? price : _currentCandle!.low;
    _currentCandle!.close = price;

    return _currentCandle!;
  }

  /// عند انقطاع الاتصال ثم عودته: نخزن Ticks المتأخرة
  void bufferTick(Map<String, dynamic> tick) {
    _pendingTicks.add(tick);
  }

  /// ملء الفجوات بعد إعادة الاتصال
  List<LiveCandle> flushBufferedTicks() {
    final List<LiveCandle> candles = [];
    while (_pendingTicks.isNotEmpty) {
      candles.add(processTick(_pendingTicks.removeFirst()));
    }
    return candles;
  }
}
EOF
cat > lib/core/network/oanda/stream/oanda_ws_client.dart << 'EOF'
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../oanda_config.dart';
import '../../../core/security/secure_storage_manager.dart';

class OandaWSClient {
  WebSocketChannel? _channel;
  StreamSubscription? _subs;
  bool _manuallyClosed = false;

  Future<void> connect(
    String symbol,
    void Function(dynamic) onData, {
    void Function()? onDone,
    void Function(dynamic)? onError,
  }) async {
    _manuallyClosed = false;
    final token = await SecureStorageManager.readOandaToken();
    final account =
        await SecureStorageManager.readOandaAccount();

    final url =
        "\${OandaConfig.streamBaseUrl}/accounts/\$account/pricing/stream?instruments=\$symbol";

    _channel = WebSocketChannel.connect(
      Uri.parse(url),
      headers: {"Authorization": "Bearer \$token"},
    );

    _subs = _channel!.stream.listen(
      onData,
      onError: (e) {
        onError?.call(e);
        if (!_manuallyClosed) {
          // إعادة الاتصال بعد 2 ثانية
          Future.delayed(Duration(seconds: 2), () {
            connect(symbol, onData,
                onDone: onDone, onError: onError);
          });
        }
      },
      onDone: () {
        onDone?.call();
        if (!_manuallyClosed) {
          Future.delayed(Duration(seconds: 2), () {
            connect(symbol, onData,
                onDone: onDone, onError: onError);
          });
        }
      },
    );
  }

  void disconnect() {
    _manuallyClosed = true;
    _subs?.cancel();
    _channel?.sink.close();
  }
}
EOF
cat > lib/features/market/domain/timeframes/timeframe.dart << 'EOF'
enum Timeframe {
  m1,
  m5,
  m15,
  h1,
}

extension TimeframeExt on Timeframe {
  Duration get duration {
    switch (this) {
      case Timeframe.m1:
        return Duration(minutes: 1);
      case Timeframe.m5:
        return Duration(minutes: 5);
      case Timeframe.m15:
        return Duration(minutes: 15);
      case Timeframe.h1:
        return Duration(hours: 1);
    }
  }

  String get oandaName {
    switch (this) {
      case Timeframe.m1:
        return "M1";
      case Timeframe.m5:
        return "M5";
      case Timeframe.m15:
        return "M15";
      case Timeframe.h1:
        return "H1";
    }
  }
}
EOF
cat > lib/features/trading/data/oanda_trade_client.dart << 'EOF'
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/oanda/oanda_config.dart';
import '../../../core/security/secure_storage_manager.dart';

class OandaTradeClient {
  Future<http.Response> _post(String url, dynamic body) async {
    final token = await SecureStorageManager.readOandaToken();
    final headers = {
      "Authorization": "Bearer \$token",
      "Content-Type": "application/json",
    };
    return http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
  }

  Future<bool> marketOrder({
    required String instrument,
    required int units,
    double? stopLoss,
    double? takeProfit,
  }) async {
    final accountId = await SecureStorageManager.readOandaAccount();
    final url =
        "\${OandaConfig.restBaseUrl}/accounts/\$accountId/orders";
    final order = {
      "order": {
        "instrument": instrument,
        "units": units.toString(),
        "type": "MARKET",
        if (stopLoss != null)
          "stopLossOnFill": {"price": stopLoss.toString()},
        if (takeProfit != null)
          "takeProfitOnFill": {"price": takeProfit.toString()},
      }
    };

    final res = await _post(url, order);
    return res.statusCode == 201;
  }

  Future<bool> limitOrder({
    required String instrument,
    required int units,
    required double price,
  }) async {
    final accountId = await SecureStorageManager.readOandaAccount();
    final url =
        "\${OandaConfig.restBaseUrl}/accounts/\$accountId/orders";
    final order = {
      "order": {
        "instrument": instrument,
        "units": units.toString(),
        "price": price.toString(),
        "type": "LIMIT",
      }
    };

    final res = await _post(url, order);
    return res.statusCode == 201;
  }
}
EOF
cat > lib/features/trading/presentation/bloc/trading_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/oanda_trade_client.dart';

part 'trading_event.dart';
part 'trading_state.dart';

class TradingBloc extends Bloc<TradingEvent, TradingState> {
  final OandaTradeClient _client = OandaTradeClient();

  TradingBloc() : super(TradingInitial()) {
    on<PlaceMarketOrder>((event, emit) async {
      emit(TradingLoading());
      final success = await _client.marketOrder(
        instrument: event.symbol,
        units: event.units,
        stopLoss: event.stopLoss,
        takeProfit: event.takeProfit,
      );
      emit(success ? TradingSuccess() : TradingFailure());
    });

    on<PlaceLimitOrder>((event, emit) async {
      emit(TradingLoading());
      final success =
          await _client.limitOrder(instrument: event.symbol, units: event.units, price: event.price);
      emit(success ? TradingSuccess() : TradingFailure());
    });
  }
}
EOF
cat > lib/features/trading/presentation/bloc/trading_event.dart << 'EOF'
part of 'trading_bloc.dart';

abstract class TradingEvent {}

class PlaceMarketOrder extends TradingEvent {
  final String symbol;
  final int units;
  final double? stopLoss;
  final double? takeProfit;

  PlaceMarketOrder({
    required this.symbol,
    required this.units,
    this.stopLoss,
    this.takeProfit,
  });
}

class PlaceLimitOrder extends TradingEvent {
  final String symbol;
  final int units;
  final double price;

  PlaceLimitOrder({
    required this.symbol,
    required this.units,
    required this.price,
  });
}
EOF
cat > lib/features/trading/presentation/bloc/trading_state.dart << 'EOF'
part of 'trading_bloc.dart';

abstract class TradingState {}

class TradingInitial extends TradingState {}

class TradingLoading extends TradingState {}

class TradingSuccess extends TradingState {}

class TradingFailure extends TradingState {}
EOF
cat > lib/core/security/refresh/token_refresh_guard.dart << 'EOF'
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../oanda/oanda_config.dart';

class TokenRefreshGuard {
  final _storage = FlutterSecureStorage();

  Future<String?> refresh(String oldToken) async {
    try {
      final res = await http.post(
        Uri.parse("\${OandaConfig.restBaseUrl}/oauth2/token"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': oldToken,
        },
      );
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        final newToken = json['access_token'];
        await _storage.write(key: OandaConfig.tokenKey, value: newToken);
        return newToken;
      }
    } catch (_) {}
    return null;
  }
}
EOF
cat > lib/core/network/security/certificate_pinning.dart << 'EOF'
import 'dart:io';
import 'package:http/io_client.dart';

class CertificatePinning {
  static HttpClient getPinnedHttpClient() {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      // ضع الـ SHA256 Pins الخاصة بـ OANDA هنا
      return cert.sha256 == "SHA256_PIN_OF_OANDA";
    };
    return client;
  }

  static IOClient getIOClient() => IOClient(getPinnedHttpClient());
}
EOF
cat > lib/core/network/retry/retry_limiter.dart << 'EOF'
import 'dart:async';

class RetryLimiter {
  final int maxAttempts;
  final Duration baseDelay;

  RetryLimiter({this.maxAttempts = 3, this.baseDelay = const Duration(seconds: 1)});

  Future<T?> run<T>(Future<T> Function() fn) async {
    int attempts = 0;

    while (attempts < maxAttempts) {
      try {
        return await fn();
      } catch (e) {
        attempts++;
        await Future.delayed(baseDelay * attempts);
      }
    }
    return null;
  }
}
EOF
cat > lib/core/logging/audit_logger.dart << 'EOF'
import 'package:hive/hive.dart';
import 'dart:convert';

class AuditLogger {
  static const _box = "audit_logs";

  static Future<void> init() async {
    await Hive.openBox(_box);
  }

  static void log(String event, dynamic payload) {
    final box = Hive.box(_box);
    box.add({
      "timestamp": DateTime.now().toIso8601String(),
      "event": event,
      "payload": jsonEncode(payload),
    });
  }

  static List<dynamic> getAllLogs() {
    final box = Hive.box(_box);
    return box.values.toList();
  }
}
EOF
cat > lib/core/ui/styles/app_theme.dart << 'EOF'
import 'package:flutter/material.dart';

final ThemeData kLightTheme = ThemeData(
  primarySwatch: Colors.indigo,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.indigo,
    titleTextStyle: TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
  ),
);

final ThemeData kDarkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.indigo,
);
EOF
cat > lib/features/home/presentation/pages/home_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/logging/audit_logger.dart';
import '../../../../features/market/presentation/bloc/oanda/oanda_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: ElevatedButton(
            child: Text("Fetch OANDA Instruments"),
            onPressed: () => context.read<OandaBloc>().add(LoadInstruments()),
          ),
        ),

        Expanded(child: BlocBuilder<OandaBloc, OandaState>(
          builder: (context, state) {
            if (state is OandaLoading)
              return Center(child: CircularProgressIndicator());
            if (state is OandaLoaded)
              return ListView.builder(
                itemCount: state.instruments.length,
                itemBuilder: (c, i) => ListTile(
                  title: Text(state.instruments[i]),
                  onTap: () {
                    AuditLogger.log("InstrumentSelected", state.instruments[i]);
                    Navigator.pushNamed(context, "/chart", arguments: state.instruments[i]);
                  },
                ),
              );
            if (state is OandaError)
              return Center(child: Text("Error: \${state.message}"));
            return Center(child: Text("No Data Loaded"));
          },
        )),

        Divider(),
        Padding(
          padding: EdgeInsets.all(8),
          child: ElevatedButton(
            child: Text("Settings"),
            onPressed: () => Navigator.pushNamed(context, "/settings"),
          ),
        ),
      ]),
    );
  }
}
EOF
cat > lib/features/trading/presentation/widgets/market_order_dialog.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/trading_bloc.dart';

class MarketOrderDialog extends StatefulWidget {
  final String symbol;
  MarketOrderDialog({required this.symbol});

  @override
  _MarketOrderDialogState createState() => _MarketOrderDialogState();
}

class _MarketOrderDialogState extends State<MarketOrderDialog> {
  final _unitsCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Market Order: \${widget.symbol}"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: _unitsCtrl,
          decoration: InputDecoration(labelText: "Units"),
          keyboardType: TextInputType.number,
        ),
      ]),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: Text("Place"),
          onPressed: () {
            final units = int.tryParse(_unitsCtrl.text) ?? 0;
            context.read<TradingBloc>().add(
                  PlaceMarketOrder(symbol: widget.symbol, units: units),
                );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
EOF
cat > lib/core/ui/widgets/error_widget.dart << 'EOF'
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  AppErrorWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.error, size: 42, color: Colors.red),
        SizedBox(height: 10),
        Text(message),
      ]),
    );
  }
}
EOF
cat > lib/core/storage/app_preferences.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("dark_mode", isDark);
  }

  static Future<bool> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("dark_mode") ?? false;
  }
}
EOF
cat > lib/core/settings/server_mode.dart << 'EOF'
enum ServerMode { sandbox, live }

extension ServerModeExt on ServerMode {
  String get name => this == ServerMode.sandbox ? "SANDBOX" : "LIVE";
}
EOF
cat > lib/core/settings/mode_storage.dart << 'EOF'
import 'package:shared_preferences/shared_preferences.dart';
import 'server_mode.dart';

class ModeStorage {
  static Future<void> save(ServerMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("server_mode", mode.name);
  }

  static Future<ServerMode> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString("server_mode") ?? "SANDBOX";
    return stored == "LIVE" ? ServerMode.live : ServerMode.sandbox;
  }
}
EOF
cat > lib/core/logging/ui/logs_page.dart << 'EOF'
import 'package:flutter/material.dart';
import '../audit_logger.dart';

class LogsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logs = AuditLogger.getAllLogs();
    return Scaffold(
      appBar: AppBar(title: Text("System Logs")),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (c, i) {
          final item = logs[i];
          return ListTile(
            title: Text(item["event"]),
            subtitle: Text(item["payload"]),
            trailing: Text(item["timestamp"]),
          );
        },
      ),
    );
  }
}
EOF
cat > test/unit/indicator_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/features/indicators/domain/ema_calculator.dart';
import 'package:my_app/features/indicators/domain/rsi_calculator.dart';

void main() {
  test('EMA calculator works correctly', () {
    final ema = EmaCalculator(5);
    final values = [1, 2, 3, 4, 5];
    final result = values.map((v) => ema.calculate(v)).toList();
    expect(result.isNotEmpty, true);
  });

  test('RSI calculator returns a number between 0 and 100', () {
    final rsi = RsiCalculator(5);
    double prev = 1, curr = 2;
    final val = rsi.calculate(prev, curr);
    expect(val != null && val! >= 0 && val <= 100, true);
  });
}
EOF
cat > test/integration/navigation_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Home -> Settings navigation", (tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text("Dashboard"), findsOneWidget);
    await tester.tap(find.text("Settings"));
    await tester.pumpAndSettle();
    expect(find.text("OANDA Settings"), findsOneWidget);
  });
}
EOF
cat > test/widget/chart_widget_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/features/chart/presentation/widgets/chart_webview.dart';

void main() {
  testWidgets("ChartWebView widget builds", (tester) async {
    final mockData = [
      {"time": 1, "open": 1, "high": 1, "low": 1, "close": 1}
    ];
    await tester.pumpWidget(ChartWebView(
      candles: mockData,
      emaShort: [],
      emaLong: [],
      rsi: [],
    ));
    await tester.pumpAndSettle();
    expect(find.byType(ChartWebView), findsOneWidget);
  });
}
EOF
cat > lib/flavors/flavors.dart << 'EOF'
enum Flavor { dev, staging, prod }
EOF
cat > .github/workflows/flutter_ci.yml << 'EOF'
name: Flutter CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: 'stable'
EOF
cat > docs/PRODUCTION_SETUP.md << 'EOF'
# Production Setup

This document explains how to configure the application for production:

1. **API Keys**
   - Store OANDA API token in a secure vault.
   - Set environment variable `OANDA_API_KEY`.

2. **Certificate Pinning**
   - Update certificate SHA256 pins in certificate_pinning.dart.

3. **Flavors**
   - Build using `--flavor prod` for production builds.

4. **Security**
   - Ensure SSL pinning is enabled.
EOF
cat > scripts/release_android.sh << 'EOF'
#!/usr/bin/env bash
EOF
cat > lib/core/network/rest/rest_client.dart << 'EOF'
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/core/settings/server_mode.dart';
import 'package:my_app/core/settings/mode_storage.dart';
import '../security/certificate_pinning.dart';
import '../retry/retry_limiter.dart';
import '../../logging/audit_logger.dart';

class RestClient {
  final RetryLimiter _retry = RetryLimiter();

  Future<String> _baseUrl() async {
    final mode = await ModeStorage.load();
    return mode == ServerMode.live
        ? "https://api-fxtrade.oanda.com/v3"
        : "https://api-fxpractice.oanda.com/v3";
  }

  http.Client get _client => CertificatePinning.getIOClient();

  Future<dynamic> get(String path,
      {Map<String, String>? headers}) async {
    final url = "\${await _baseUrl()}\$path";
    AuditLogger.log("REST GET", {"url": url, "headers": headers});

    final res = await _retry.run(() => _client.get(
          Uri.parse(url),
          headers: headers,
        ));

    if (res == null) {
      throw Exception("REST GET Failed: No response");
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      AuditLogger.log("REST ERROR", {
        "url": url,
        "status": res.statusCode,
        "body": res.body
      });
      throw Exception(
          "REST GET Error: \${res.statusCode} \${res.body}");
    }

    return jsonDecode(res.body);
  }

  Future<dynamic> post(String path,
      {Map<String, String>? headers, Object? body}) async {
    final url = "\${await _baseUrl()}\$path";
    AuditLogger.log("REST POST", {"url": url, "body": body});

    final res = await _retry.run(() =>
        _client.post(Uri.parse(url),
            headers: headers, body: jsonEncode(body)));

    if (res == null) {
      throw Exception("REST POST Failed: No response");
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      AuditLogger.log("REST ERROR", {
        "url": url,
        "status": res.statusCode,
        "body": res.body
      });
      throw Exception(
          "REST POST Error: \${res.statusCode} \${res.body}");
    }

    return jsonDecode(res.body);
  }
}
EOF
cat > lib/core/network/ws/transport/ws_transport.dart << 'EOF'
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../security/secure_storage_manager.dart';
import '../../../settings/mode_storage.dart';
import '../../../settings/server_mode.dart';
import '../../../logging/audit_logger.dart';

enum WsConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error
}

class WsTransport {
  WebSocketChannel? _channel;
  StreamSubscription? _sub;
  Timer? _pingTimer;

  final _stateController = StreamController<WsConnectionState>.broadcast();
  Stream<WsConnectionState> get stateStream => _stateController.stream;

  bool _manuallyClosed = false;
  int _reconnectAttempts = 0;

  Future<String> _baseUrl() async {
    final mode = await ModeStorage.load();
    return mode == ServerMode.live
        ? "wss://stream-fxtrade.oanda.com/v3"
        : "wss://stream-fxpractice.oanda.com/v3";
  }

  Future<void> connect({
    required String accountId,
    required String instrument,
    required Function(dynamic) onData,
  }) async {
    _manuallyClosed = false;
    _stateController.add(WsConnectionState.connecting);

    final token = await SecureStorageManager.readOandaToken();
    final base = await _baseUrl();
    final url =
        "\$base/accounts/\$accountId/pricing/stream?instruments=\$instrument";

    try {
      AuditLogger.log("WS_CONNECT", {"url": url});

      _channel = WebSocketChannel.connect(
        Uri.parse(url),
        headers: {"Authorization": "Bearer \$token"},
      );

      _stateController.add(WsConnectionState.connected);
      _reconnectAttempts = 0;

      _startPing();

      _sub = _channel!.stream.listen(
        (data) {
          onData(data);
        },
        onError: (e) {
          AuditLogger.log("WS_ERROR", {"error": e.toString()});
          _stateController.add(WsConnectionState.error);
          _attemptReconnect(accountId, instrument, onData);
        },
        onDone: () {
          if (!_manuallyClosed) {
            _stateController.add(WsConnectionState.reconnecting);
            _attemptReconnect(accountId, instrument, onData);
          }
        },
        cancelOnError: true,
      );
    } catch (e) {
      AuditLogger.log("WS_CONNECT_FAIL", {"error": e.toString()});
      _stateController.add(WsConnectionState.error);
      _attemptReconnect(accountId, instrument, onData);
    }
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(Duration(seconds: 20), (_) {
      try {
        _channel?.sink.add('{"type":"ping"}');
      } catch (_) {}
    });
  }

  void _attemptReconnect(
      String accountId, String instrument, Function(dynamic) onData) {
    if (_manuallyClosed) return;

    _reconnectAttempts++;
    final delay = Duration(
        seconds: (_reconnectAttempts * 2).clamp(2, 30));

    Future.delayed(delay, () {
      connect(
          accountId: accountId,
          instrument: instrument,
          onData: onData);
    });
  }

  void disconnect() {
    _manuallyClosed = true;
    _pingTimer?.cancel();
    _sub?.cancel();
    _channel?.sink.close();
    _stateController.add(WsConnectionState.disconnected);
  }
}
EOF
cat > lib/core/network/ws/pipeline/ws_pipeline.dart << 'EOF'
import 'dart:async';
import 'dart:collection';

class WsPipeline {
  final int maxBufferSize;
  final Queue<dynamic> _buffer = Queue();
  final StreamController<dynamic> _out =
      StreamController.broadcast();

  Stream<dynamic> get stream => _out.stream;

  WsPipeline({this.maxBufferSize = 5000});

  void push(dynamic event) {
    if (_buffer.length >= maxBufferSize) {
      _buffer.removeFirst(); // منع Overflow
    }
    _buffer.add(event);
    _drain();
  }

  void _drain() {
    while (_buffer.isNotEmpty) {
      _out.add(_buffer.removeFirst());
    }
  }

  void dispose() {
    _out.close();
  }
}
EOF
cat > lib/features/market/domain/streaming/live_stream_adapter.dart << 'EOF'
import 'dart:convert';
import '../../../core/network/ws/transport/ws_transport.dart';
import '../../../core/network/ws/pipeline/ws_pipeline.dart';
import '../aggregator/candle_aggregator.dart';
import '../timeframes/timeframe.dart';

class LiveStreamAdapter {
  final WsTransport _transport = WsTransport();
  final WsPipeline _pipeline = WsPipeline();
  late CandleAggregator _aggregator;

  Stream<Map<String, dynamic>> get candleStream =>
      _pipeline.stream.map((e) => e as Map<String, dynamic>);

  void start({
    required String accountId,
    required String symbol,
    required Timeframe timeframe,
  }) {
    _aggregator = CandleAggregator(timeframe.duration);

    _transport.connect(
      accountId: accountId,
      instrument: symbol,
      onData: (raw) {
        final decoded = jsonDecode(raw);

        if (decoded["type"] == "PRICE") {
          final tick = {
            "time": decoded["time"] is String
                ? DateTime.parse(decoded["time"])
                        .millisecondsSinceEpoch ~/
                    1000
                : decoded["time"],
            "price": double.parse(decoded["bids"][0]["price"]),
          };

          final candle = _aggregator.processTick(tick);
          _pipeline.push(candle.toMap());
        }
      },
    );
  }

  void stop() {
    _transport.disconnect();
    _pipeline.dispose();
  }
}
EOF
cat > lib/features/market/presentation/bloc/stream/stream_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/streaming/live_stream_adapter.dart';
import '../../../domain/timeframes/timeframe.dart';

part 'stream_event.dart';
part 'stream_state.dart';

class StreamBloc extends Bloc<StreamEvent, StreamState> {
  final LiveStreamAdapter _adapter = LiveStreamAdapter();

  StreamBloc() : super(StreamInitial()) {
    on<StartStream>((event, emit) {
      emit(StreamConnecting());

      _adapter.start(
        accountId: event.accountId,
        symbol: event.symbol,
        timeframe: event.timeframe,
      );

      _adapter.candleStream.listen((candle) {
        add(StreamTickReceived(candle));
      });

      emit(StreamConnected());
    });

    on<StreamTickReceived>((event, emit) {
      emit(StreamCandle(event.candle));
    });

    on<StopStream>((event, emit) {
      _adapter.stop();
      emit(StreamStopped());
    });
  }
}
EOF
cat > lib/features/market/presentation/bloc/stream/stream_event.dart << 'EOF'
part of 'stream_bloc.dart';

abstract class StreamEvent {}

class StartStream extends StreamEvent {
  final String accountId;
  final String symbol;
  final Timeframe timeframe;

  StartStream({
    required this.accountId,
    required this.symbol,
    required this.timeframe,
  });
}

class StreamTickReceived extends StreamEvent {
  final Map<String, dynamic> candle;
  StreamTickReceived(this.candle);
}

class StopStream extends StreamEvent {}
EOF
cat > lib/features/market/presentation/bloc/stream/stream_state.dart << 'EOF'
part of 'stream_bloc.dart';

abstract class StreamState {}

class StreamInitial extends StreamState {}

class StreamConnecting extends StreamState {}

class StreamConnected extends StreamState {}

class StreamCandle extends StreamState {
  final Map<String, dynamic> candle;
  StreamCandle(this.candle);
}

class StreamStopped extends StreamState {}
EOF
cat > lib/features/market/domain/models/candle.dart << 'EOF'
import 'package:equatable/equatable.dart';

class Candle extends Equatable {
  final int time; // Unix seconds (موحد في كل التطبيق)
  final double open;
  final double high;
  final double low;
  final double close;
  final double? volume;

  const Candle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume,
  });

  /// Factory آمن من JSON (REST)
  factory Candle.fromRestJson(Map<String, dynamic> json) {
    final candle = json["mid"] ?? json["bid"] ?? json;

    return Candle(
      time: _toUnixSeconds(candle["time"]),
      open: _toDouble(candle["o"]),
      high: _toDouble(candle["h"]),
      low: _toDouble(candle["l"]),
      close: _toDouble(candle["c"]),
      volume: candle["volume"] != null ? _toDouble(candle["volume"]) : null,
    );
  }

  /// Factory آمن من Tick (WebSocket)
  factory Candle.fromTick({
    required int time,
    required double price,
  }) {
    return Candle(
      time: time,
      open: price,
      high: price,
      low: price,
      close: price,
      volume: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "time": time,
      "open": open,
      "high": high,
      "low": low,
      "close": close,
      if (volume != null) "volume": volume,
    };
  }

  Candle copyWith({
    int? time,
    double? open,
    double? high,
    double? low,
    double? close,
    double? volume,
  }) {
    return Candle(
      time: time ?? this.time,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      volume: volume ?? this.volume,
    );
  }

  static int _toUnixSeconds(dynamic v) {
    if (v is int) return v;
    if (v is String) {
      return DateTime.parse(v).millisecondsSinceEpoch ~/ 1000;
    }
    throw FormatException("Invalid time format: \$v");
  }

  static double _toDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.parse(v);
    throw FormatException("Invalid price format: \$v");
  }

  @override
  List<Object?> get props => [time, open, high, low, close, volume];
}
EOF
cat > lib/features/market/domain/models/tick.dart << 'EOF'
import 'package:equatable/equatable.dart';

class Tick extends Equatable {
  final int time; // Unix seconds
  final double bid;
  final double ask;

  const Tick({
    required this.time,
    required this.bid,
    required this.ask,
  });

  factory Tick.fromOandaWs(Map<String, dynamic> json) {
    if (json["type"] != "PRICE") {
      throw FormatException("Not a PRICE message");
    }

    final time = _toUnix(json["time"]);
    final bid = _toDouble(json["bids"][0]["price"]);
    final ask = _toDouble(json["asks"][0]["price"]);

    return Tick(time: time, bid: bid, ask: ask);
  }

  Map<String, dynamic> toMap() {
    return {
      "time": time,
      "bid": bid,
      "ask": ask,
    };
  }

  static int _toUnix(dynamic v) {
    if (v is int) return v;
    if (v is String) {
      return DateTime.parse(v).millisecondsSinceEpoch ~/ 1000;
    }
    throw FormatException("Invalid time: \$v");
  }

  static double _toDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.parse(v);
    throw FormatException("Invalid price: \$v");
  }

  @override
  List<Object?> get props => [time, bid, ask];
}
EOF
cat > lib/features/market/domain/models/instrument.dart << 'EOF'
import 'package:equatable/equatable.dart';

class Instrument extends Equatable {
  final String name;      // مثال: "XAU_USD"
  final String display;   // مثال: "XAUUSD"
  final int displayPrecision;
  final int tradeUnitsPrecision;

  const Instrument({
    required this.name,
    required this.display,
    required this.displayPrecision,
    required this.tradeUnitsPrecision,
  });

  factory Instrument.fromRest(Map<String, dynamic> json) {
    final name = json["name"] as String;
    return Instrument(
      name: name,
      display: name.replaceAll("_", ""),
      displayPrecision: json["displayPrecision"] as int,
      tradeUnitsPrecision: json["tradeUnitsPrecision"] as int,
    );
  }

  @override
  List<Object?> get props =>
      [name, display, displayPrecision, tradeUnitsPrecision];
}
EOF
cat > lib/features/trading/domain/models/order.dart << 'EOF'
import 'package:equatable/equatable.dart';

enum OrderType { market, limit, stop }

class Order extends Equatable {
  final String instrument;
  final OrderType type;
  final int units;
  final double? price;
  final double? stopLoss;
  final double? takeProfit;

  const Order({
    required this.instrument,
    required this.type,
    required this.units,
    this.price,
    this.stopLoss,
    this.takeProfit,
  });

  Map<String, dynamic> toOandaPayload() {
    final base = {
      "instrument": instrument,
      "units": units.toString(),
      "type": type.name.toUpperCase(),
    };

    if (type == OrderType.limit && price != null) {
      base["price"] = price.toString();
    }

    if (stopLoss != null) {
      base["stopLossOnFill"] = {"price": stopLoss.toString()};
    }

    if (takeProfit != null) {
      base["takeProfitOnFill"] = {"price": takeProfit.toString()};
    }

    return {"order": base};
  }

  @override
  List<Object?> get props =>
      [instrument, type, units, price, stopLoss, takeProfit];
}
EOF
cat > lib/features/market/data/market_repository.dart << 'EOF'
import '../../domain/models/candle.dart';
import '../../domain/models/instrument.dart';
import '../../../core/network/rest/rest_client.dart';

class MarketRepository {
  final RestClient _client = RestClient();

  Future<List<Candle>> getHistoricalCandles(
      String accountId, String instrument, String granularity,
      {int count = 500}) async {
    final data = await _client.get(
        "/accounts/\$accountId/instruments/\$instrument/candles?granularity=\$granularity&count=\$count");

    final List list = data["candles"];
    return list.map((e) => Candle.fromRestJson(e)).toList();
  }

  Future<List<Instrument>> getInstruments(String accountId) async {
    final data =
        await _client.get("/accounts/\$accountId/instruments");

    final List list = data["instruments"];
    return list.map((e) => Instrument.fromRest(e)).toList();
  }
}
EOF
cat > lib/core/network/security/pinning/pin_store.dart << 'EOF'
class PinStore {
  /// **استبدل القيم التالية بالقيم الحقيقية المستخرجة بالأعلى**
  static const List<String> sandboxRestPins = [
    "REPLACE_WITH_SANDBOX_REST_SHA256_BASE64",
  ];

  static const List<String> sandboxStreamPins = [
    "REPLACE_WITH_SANDBOX_STREAM_SHA256_BASE64",
  ];

  static const List<String> liveRestPins = [
    "REPLACE_WITH_LIVE_REST_SHA256_BASE64",
  ];

  static const List<String> liveStreamPins = [
    "REPLACE_WITH_LIVE_STREAM_SHA256_BASE64",
  ];
}
EOF
cat > lib/core/network/security/http_pinning_client.dart << 'EOF'
import 'dart:io';
import 'package:http/io_client.dart';
import '../pinning/pin_store.dart';
import '../../settings/mode_storage.dart';
import '../../settings/server_mode.dart';

class HttpPinningClient {
  static Future<IOClient> create() async {
    final mode = await ModeStorage.load();
    final pins = mode == ServerMode.live
        ? [...PinStore.liveRestPins, ...PinStore.liveStreamPins]
        : [...PinStore.sandboxRestPins, ...PinStore.sandboxStreamPins];

    final httpClient = HttpClient()
      ..badCertificateCallback = (cert, host, port) {
        final sha256 = cert.sha256;
        return pins.contains(sha256);
      };

    return IOClient(httpClient);
  }
}
EOF
cat > lib/core/network/security/pinning/ws_pinned_io.dart << 'EOF'
import 'dart:io';
import 'package:web_socket_channel/io.dart';
import '../pinning/pin_store.dart';
import '../../settings/mode_storage.dart';
import '../../settings/server_mode.dart';

class WsPinningFactory {
  static Future<IOWebSocketChannel> connectWithPinning(
      Uri uri, Map<String, dynamic> headers) async {
    final mode = await ModeStorage.load();
    final pins = mode == ServerMode.live
        ? PinStore.liveStreamPins
        : PinStore.sandboxStreamPins;

    final client = HttpClient()
      ..badCertificateCallback = (cert, host, port) {
        return pins.contains(cert.sha256);
      };

    return IOWebSocketChannel.connect(
      uri,
      customClient: client,
      headers: headers.cast<String, dynamic>(),
    );
  }
}
EOF
cat > test/pinning/pin_fail_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:my_app/core/network/security/pinning/pin_store.dart';

void main() {
  test("Cert pin lists not empty", () {
    expect(PinStore.sandboxRestPins.isNotEmpty, true);
    expect(PinStore.sandboxStreamPins.isNotEmpty, true);
    expect(PinStore.liveRestPins.isNotEmpty, true);
    expect(PinStore.liveStreamPins.isNotEmpty, true);
  });
}
EOF
cat > lib/core/network/retry/retry_policy.dart << 'EOF'
import 'dart:async';

enum RetryErrorType {
  timeout,
  server,
  client,
  unknown,
}

class RetryPolicy {
  final int maxAttempts;
  final Duration baseDelay;
  final bool enableJitter;

  RetryPolicy({
    this.maxAttempts = 5,
    this.baseDelay = const Duration(seconds: 1),
    this.enableJitter = true,
  });

  Duration _jitter(Duration d) {
    if (!enableJitter) return d;
    final millis = d.inMilliseconds;
    final jitter = (millis * 0.5).toInt();
    return Duration(milliseconds: millis + jitter);
  }

  Future<T> execute<T>(
    Future<T> Function() action, {
    required void Function(int attempt, Duration delay, RetryErrorType type) onRetry,
  }) async {
    int attempts = 0;
    Duration delay = baseDelay;

    while (true) {
      try {
        return await action();
      } catch (e) {
        attempts++;
        if (attempts >= maxAttempts) rethrow;

        final errorType = _classifyError(e);

        // Logging retry attempt
        onRetry(attempts, delay, errorType);

        await Future.delayed(_jitter(delay));

        // Exponential backoff
        delay = Duration(seconds: delay.inSeconds * 2);
      }
    }
  }

  RetryErrorType _classifyError(Object error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains("timeout")) return RetryErrorType.timeout;
    if (msg.contains("5")) return RetryErrorType.server;
    if (msg.contains("4")) return RetryErrorType.client;
    return RetryErrorType.unknown;
  }
}
EOF
cat > lib/core/network/rest/rest_client.dart << 'EOF'
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../retry/retry_policy.dart';
import '../security/http_pinning_client.dart';
import '../../logging/audit_logger.dart';

class RestClient {
  final RetryPolicy _retry = RetryPolicy();

  Future<String> _baseUrl() =>
      ModeStorage.load().then((mode) => mode == ServerMode.live
          ? "https://api-fxtrade.oanda.com/v3"
          : "https://api-fxpractice.oanda.com/v3");

  Future<dynamic> get(String path,
      {Map<String, String>? headers}) async {
    final url = "\${await _baseUrl()}\$path";
    http.Client client = await HttpPinningClient.create();

    return _retry.execute(() => client.get(Uri.parse(url), headers: headers)
        .then((res) {
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw Exception(
            "REST GET \${res.statusCode}: \${res.body}");
      }
      return jsonDecode(res.body);
    }), onRetry: (attempt, delay, type) {
      AuditLogger.log("REST_RETRY", {
        "url": url,
        "attempt": attempt,
        "delay": delay.inString(),
        "type": type.toString(),
      });
    });
  }

  Future<dynamic> post(String path,
      {Map<String, String>? headers, Object? body}) async {
    final url = "\${await _baseUrl()}\$path";
    http.Client client = await HttpPinningClient.create();

    return _retry.execute(() => client
        .post(Uri.parse(url),
            headers: headers, body: jsonEncode(body))
        .then((res) {
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw Exception(
            "REST POST \${res.statusCode}: \${res.body}");
      }
      return jsonDecode(res.body);
    }), onRetry: (attempt, delay, type) {
      AuditLogger.log("REST_RETRY", {
        "url": url,
        "attempt": attempt,
        "delay": delay.inString(),
        "type": type.toString(),
      });
    });
  }
}
EOF
cat > lib/core/network/rest/rest_timeout.dart << 'EOF'
import 'dart:async';

extension HttpTimeout<T> on Future<T> {
  Future<T> withTimeout(Duration timeout) {
    return this.timeout(timeout, onTimeout: () {
      throw Exception("Request Timeout after \$timeout");
    });
  }
}
EOF
cat > lib/core/network/ws/transport/ws_transport_retry.dart << 'EOF'
import 'package:flutter/foundation.dart';
import '../ws_transport.dart';
import '../../retry/retry_policy.dart';

class WsTransportRetry {
  final RetryPolicy _retry = RetryPolicy(maxAttempts: 4);

  Future<void> connectWithRetry({
    required String accountId,
    required String instrument,
    required Function(dynamic) onData,
    required WsTransport transport,
  }) async {
    await _retry.execute(() {
      return transport.connect(
        accountId: accountId,
        instrument: instrument,
        onData: onData,
      );
    }, onRetry: (attempt, delay, type) {
      debugPrint("WS RETRY \$attempt delay=\$delay type=\$type");
    });
  }
}
EOF
cat > lib/core/storage/hive_adapters/candle_adapter.dart << 'EOF'
import 'package:hive/hive.dart';
import '../../features/market/domain/models/candle.dart';

part 'candle_adapter.g.dart';

@HiveType(typeId: 1)
class HiveCandle {
  @HiveField(0)
  final int time;

  @HiveField(1)
  final double open;

  @HiveField(2)
  final double high;

  @HiveField(3)
  final double low;

  @HiveField(4)
  final double close;

  HiveCandle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}

// Adapter Serializer
class HiveCandleAdapter extends TypeAdapter<HiveCandle> {
  @override
  final typeId = 1;

  @override
  HiveCandle read(BinaryReader reader) {
    return HiveCandle(
      time: reader.readInt(),
      open: reader.readDouble(),
      high: reader.readDouble(),
      low: reader.readDouble(),
      close: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveCandle obj) {
    writer.writeInt(obj.time);
    writer.writeDouble(obj.open);
    writer.writeDouble(obj.high);
    writer.writeDouble(obj.low);
    writer.writeDouble(obj.close);
  }
}
EOF
cat > lib/core/storage/cache/cache_strategy.dart << 'EOF'
abstract class CacheStrategy<T> {
  Future<T?> read(String key);
  Future<void> write(String key, T value);
  Future<void> delete(String key);
  bool shouldInvalidate(String key);
}
EOF
cat > lib/core/storage/cache/ttl_cache.dart << 'EOF'
import 'dart:convert';
import 'package:hive/hive.dart';
import 'cache_strategy.dart';

class TtlCache<T> implements CacheStrategy<T> {
  final Box _box;
  final Duration ttl;

  TtlCache(this._box, {required this.ttl});

  @override
  Future<void> write(String key, T value) async {
    final wrapper = {
      "ts": DateTime.now().millisecondsSinceEpoch,
      "data": value,
    };
    await _box.put(key, wrapper);
  }

  @override
  Future<T?> read(String key) async {
    final stored = _box.get(key);
    if (stored == null) return null;
    final ts = stored["ts"] as int;
    final diff =
        DateTime.now().millisecondsSinceEpoch - ts;
    if (Duration(milliseconds: diff) > ttl) {
      await _box.delete(key);
      return null;
    }
    return stored["data"] as T;
  }

  @override
  Future<void> delete(String key) async => _box.delete(key);

  @override
  bool shouldInvalidate(String key) {
    return !_box.containsKey(key);
  }
}
EOF
cat > lib/core/storage/cache/cache_manager.dart << 'EOF'
import 'package:hive/hive.dart';
import 'cache_strategy.dart';
import 'ttl_cache.dart';

class CacheManager {
  static final _inst = CacheManager._();
  CacheManager._();

  static CacheManager get instance => _inst;

  late CacheStrategy _symbolsCache;
  late CacheStrategy _instrumentsCache;

  Future<void> init() async {
    final symBox = Hive.box("cache_symbols");
    _symbolsCache = TtlCache(symBox, ttl: Duration(minutes: 10));

    final insBox = Hive.box("cache_instruments");
    _instrumentsCache = TtlCache(insBox, ttl: Duration(minutes: 30));
  }

  Future<List<String>?> getSymbols(String key) =>
      _symbolsCache.read(key);

  Future<void> setSymbols(String key, List<String> val) =>
      _symbolsCache.write(key, val);

  Future<void> deleteSymbols(String key) =>
      _symbolsCache.delete(key);

  Future<List<dynamic>?> getInstruments(String key) =>
      _instrumentsCache.read(key);

  Future<void> setInstruments(String key, List<dynamic> val) =>
      _instrumentsCache.write(key, val);

  Future<void> deleteInstruments(String key) =>
      _instrumentsCache.delete(key);
}
EOF
cat > lib/features/market/data/market_repository.dart << 'EOF'
import '../../domain/models/candle.dart';
import '../../domain/models/instrument.dart';
import '../../../core/network/rest/rest_client.dart';
import '../../../core/storage/cache/cache_manager.dart';

class MarketRepository {
  final RestClient _client = RestClient();
  final CacheManager _cache = CacheManager.instance;

  Future<List<Instrument>> getInstrumentsCached(
      String accountId) async {
    final key = "instruments_\$accountId";
    final fromCache = await _cache.getInstruments(key);
    if (fromCache != null) {
      return fromCache.cast<Instrument>();
    }

    final data =
        await _client.get("/accounts/\$accountId/instruments");
    final list = (data["instruments"] as List)
        .map((e) => Instrument.fromRest(e))
        .toList();

    await _cache.setInstruments(key, list);
    return list;
  }

  Future<List<Candle>> getCandlesCached(
      String accountId, String instrument, String granularity) async {
    final key = "candles_\$accountId_\$instrument_\$granularity";
    final fromCache = await _cache.getSymbols(key);
    if (fromCache != null) {
      return fromCache.cast<Candle>();
    }

    final raw = await _client.get(
        "/accounts/\$accountId/instruments/\$instrument/candles?granularity=\$granularity&count=500");
    final list = (raw["candles"] as List)
        .map((e) => Candle.fromRestJson(e))
        .toList();

    await _cache.setSymbols(key, list);
    return list;
  }
}
EOF
cat > lib/core/storage/watchlist.dart << 'EOF'
import 'package:hive/hive.dart';

class WatchlistManager {
  final Box _box = Hive.box("watchlist_box");

  List<String> getAll() =>
      _box.values.cast<String>().toList();

  Future<void> add(String symbol) async {
    if (!_box.values.contains(symbol)) {
      await _box.add(symbol);
    }
  }

  Future<void> remove(String symbol) async {
    final key = _box.keys
        .firstWhere((k) => _box.get(k) == symbol);
    await _box.delete(key);
  }
}
EOF
cat > lib/core/bloc/base_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseEvent {}

abstract class BaseState {}

abstract class BaseEffect {}

abstract class BaseBloc<E extends BaseEvent, S extends BaseState>
    extends Bloc<E, S> {
  BaseBloc(S initialState) : super(initialState);

  void emitSafe(S state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
EOF
cat > lib/core/bloc/subscriptions/subscription_manager.dart << 'EOF'
import 'dart:async';

class SubscriptionManager {
  final List<StreamSubscription> _subs = [];

  void add(StreamSubscription sub) {
    _subs.add(sub);
  }

  Future<void> cancelAll() async {
    for (final s in _subs) {
      await s.cancel();
    }
    _subs.clear();
  }
}
EOF
cat > lib/features/market/presentation/bloc/market/market_state.dart << 'EOF'
import 'package:equatable/equatable.dart';
import '../../../domain/models/candle.dart';

abstract class MarketState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MarketIdle extends MarketState {}

class MarketLoadingHistory extends MarketState {}

class MarketHistoryReady extends MarketState {
  final List<Candle> candles;
  MarketHistoryReady(this.candles);

  @override
  List<Object?> get props => [candles];
}

class MarketStreaming extends MarketState {}

class MarketError extends MarketState {
  final String message;
  MarketError(this.message);

  @override
  List<Object?> get props => [message];
}
EOF
cat > lib/core/error/failure.dart << 'EOF'
abstract class Failure {
  final String message;
  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(String m) : super(m);
}

class AuthFailure extends Failure {
  AuthFailure(String m) : super(m);
}

class ParsingFailure extends Failure {
  ParsingFailure(String m) : super(m);
}

class UnknownFailure extends Failure {
  UnknownFailure(String m) : super(m);
}
EOF
cat > lib/features/market/presentation/bloc/market/market_effect.dart << 'EOF'
abstract class MarketEffect {}

class ShowToast extends MarketEffect {
  final String message;
  ShowToast(this.message);
}

class NavigateToSettings extends MarketEffect {}

class NotifyTradeOpened extends MarketEffect {
  final String symbol;
  NotifyTradeOpened(this.symbol);
}
EOF
cat > lib/core/bloc/stream_handler.dart << 'EOF'
import 'dart:async';

class StreamHandler<T> {
  StreamSubscription? _sub;

  void listen(Stream<T> stream, void Function(T) onData) {
    _sub = stream.listen(onData);
  }

  Future<void> cancel() async {
    await _sub?.cancel();
  }
}
EOF
cat > lib/features/market/presentation/bloc/market/market_event.dart << 'EOF'
abstract class MarketEvent {}

class LoadHistory extends MarketEvent {
  final String accountId;
  final String symbol;
  final String timeframe;

  LoadHistory(this.accountId, this.symbol, this.timeframe);
}

class StartStreaming extends MarketEvent {}

class StopStreaming extends MarketEvent {}
EOF
cat > lib/features/market/presentation/bloc/market/market_bloc.dart << 'EOF'
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'market_event.dart';
import 'market_state.dart';
import 'market_effect.dart';
import '../../../domain/models/candle.dart';
import '../../../data/market_repository.dart';
import '../../../domain/streaming/live_stream_adapter.dart';
import '../../../../core/bloc/subscriptions/subscription_manager.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final MarketRepository _repo;
  final LiveStreamAdapter _stream;
  final SubscriptionManager _subs = SubscriptionManager();

  MarketBloc(this._repo, this._stream) : super(MarketIdle()) {
    on<LoadHistory>(_onLoadHistory);
    on<StartStreaming>(_onStartStreaming);
    on<StopStreaming>(_onStopStreaming);
  }

  Future<void> _onLoadHistory(
      LoadHistory e, Emitter<MarketState> emit) async {
    emit(MarketLoadingHistory());

    try {
      final candles = await _repo.getCandlesCached(
        e.accountId,
        e.symbol,
        e.timeframe,
      );

      emit(MarketHistoryReady(candles));
    } catch (err) {
      emit(MarketError("Failed to load history"));
    }
  }

  void _onStartStreaming(
      StartStreaming e, Emitter<MarketState> emit) {
    emit(MarketStreaming());

    final sub = _stream.candleStream.listen((candleMap) {
      final candle = Candle(
        time: candleMap["time"],
        open: candleMap["open"],
        high: candleMap["high"],
        low: candleMap["low"],
        close: candleMap["close"],
      );

      add(_MarketTick(candle));
    });

    _subs.add(sub);
  }

  void _onStopStreaming(
      StopStreaming e, Emitter<MarketState> emit) async {
    await _subs.cancelAll();
    emit(MarketIdle());
  }
}

class _MarketTick extends MarketEvent {
  final Candle candle;
  _MarketTick(this.candle);
}
EOF
cat > lib/features/market/presentation/bloc/stream/stream_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/streaming/live_stream_adapter.dart';
import '../../../../core/bloc/subscriptions/subscription_manager.dart';

abstract class StreamEvent {}

class ConnectStream extends StreamEvent {
  final String accountId;
  final String symbol;
  ConnectStream(this.accountId, this.symbol);
}

class DisconnectStream extends StreamEvent {}

abstract class StreamState {}

class StreamIdle extends StreamState {}

class StreamConnecting extends StreamState {}

class StreamConnected extends StreamState {}

class StreamError extends StreamState {
  final String message;
  StreamError(this.message);
}

class StreamBloc extends Bloc<StreamEvent, StreamState> {
  final LiveStreamAdapter _adapter;
  final SubscriptionManager _subs = SubscriptionManager();

  StreamBloc(this._adapter) : super(StreamIdle()) {
    on<ConnectStream>(_onConnect);
    on<DisconnectStream>(_onDisconnect);
  }

  void _onConnect(
      ConnectStream e, Emitter<StreamState> emit) {
    emit(StreamConnecting());

    _adapter.start(
      accountId: e.accountId,
      symbol: e.symbol,
      timeframe: Timeframe.m1,
    );

    emit(StreamConnected());
  }

  void _onDisconnect(
      DisconnectStream e, Emitter<StreamState> emit) async {
    _adapter.stop();
    await _subs.cancelAll();
    emit(StreamIdle());
  }
}
EOF
cat > lib/core/bloc/root/root_event.dart << 'EOF'
abstract class RootEvent {}

class InitApp extends RootEvent {}

class TerminateApp extends RootEvent {}

class ConnectionStatusChanged extends RootEvent {
  final bool connected;
  ConnectionStatusChanged(this.connected);
}

class GlobalErrorOccurred extends RootEvent {
  final String message;
  GlobalErrorOccurred(this.message);
}
EOF
cat > lib/core/bloc/root/root_state.dart << 'EOF'
abstract class RootState {}

class AppUninitialized extends RootState {}

class AppReady extends RootState {}

class AppTerminated extends RootState {}

class AppErrorState extends RootState {
  final String message;
  AppErrorState(this.message);
}

class ConnectivityState extends RootState {
  final bool online;
  ConnectivityState(this.online);
}
EOF
cat > lib/core/bloc/root/root_bloc.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'root_event.dart';
import 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc() : super(AppUninitialized()) {
    on<InitApp>((event, emit) {
      emit(AppReady());
    });

    on<ConnectionStatusChanged>((event, emit) {
      emit(ConnectivityState(event.connected));
    });

    on<GlobalErrorOccurred>((event, emit) {
      emit(AppErrorState(event.message));
    });

    on<TerminateApp>((event, emit) {
      // يمكن إضافة Cleanup هنا
      emit(AppTerminated());
    });
  }
}
EOF
cat > lib/core/bloc/providers/app_bloc_providers.dart << 'EOF'
import 'package:flutter_bloc/flutter_bloc.dart';

import '../root/root_bloc.dart';
import '../../features/market/presentation/bloc/market/market_bloc.dart';
import '../../features/market/presentation/bloc/stream/stream_bloc.dart';
import '../../features/trading/presentation/bloc/trading_bloc.dart';

class AppBlocProviders {
  static List<BlocProvider> all(
    dynamic marketRepo,
    dynamic streamAdapter,
  ) {
    return [
      BlocProvider<RootBloc>(create: (_) => RootBloc()),
      BlocProvider<MarketBloc>(
          create: (_) => MarketBloc(marketRepo, streamAdapter)),
      BlocProvider<StreamBloc>(
          create: (_) => StreamBloc(streamAdapter)),
      BlocProvider<TradingBloc>(create: (_) => TradingBloc()),
    ];
  }
}
EOF
cat > lib/features/trading/presentation/bloc/trading_extension.dart << 'EOF'
extension TradingBlocStreamLink on TradingBloc {
  void bindMarketStream(Stream<Map<String, dynamic>> stream) {
    stream.listen((candle) {
      add(CheckStrategySignal(candle)); // حدث فحص استراتيجية
    });
  }
}
EOF
cat > lib/core/ui/theme/app_themes.dart << 'EOF'
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  useMaterial3: true,
);
EOF
cat > lib/core/ui/widgets/base_scaffold.dart << 'EOF'
import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const BaseScaffold({
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: body,
        ),
      ),
    );
  }
}
EOF
cat > lib/core/navigation/app_router.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/widgets/error_screen.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/chart/presentation/pages/chart_page.dart';
import '../../features/trading/presentation/pages/trading_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => ErrorScreen(state.error.toString()),
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (c, s) => MaterialPage(child: HomePage()),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (c, s) => MaterialPage(child: SettingsPage()),
    ),
    GoRoute(
      path: '/chart',
      pageBuilder: (c, s) {
        final symbol = s.queryParams['symbol'] ?? "";
        return MaterialPage(child: ChartPage(symbol: symbol));
      },
    ),
    GoRoute(
      path: '/trading',
      pageBuilder: (c, s) => MaterialPage(child: TradingPage()),
    ),
  ],
);
EOF
cat > lib/core/ui/widgets/loading_widget.dart << 'EOF'
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String message;
  const LoadingWidget({this.message = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
EOF
cat > lib/core/ui/widgets/error_screen.dart << 'EOF'
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  const ErrorScreen(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error, size: 64, color: Colors.red),
          SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text("Retry"),
            onPressed: () => Navigator.pop(context),
          ),
        ]),
      ),
    );
  }
}
EOF
cat > lib/core/ui/widgets/shimmer_placeholder.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerPlaceholder({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey,
      ),
    );
  }
}
EOF
cat > lib/features/chart/presentation/pages/chart_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/ui/widgets/loading_widget.dart';
import '../widgets/chart_webview.dart';
import '../../presentation/bloc/live_chart/live_chart_bloc.dart';

class ChartPage extends StatefulWidget {
  final String symbol;
  const ChartPage({required this.symbol});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  String _timeframe = "M1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chart: \${widget.symbol}"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (tf) {
              setState(() => _timeframe = tf);
              context.read<LiveChartBloc>().add(LoadLiveCandlesRequest(
                    widget.symbol,
                    tf,
                  ));
            },
            itemBuilder: (c) => [
              "M1",
              "M5",
              "M15",
              "H1",
            ].map((tf) => PopupMenuItem(
                  value: tf,
                  child: Text(tf),
                )).toList(),
          ),
        ],
      ),
      body: BlocBuilder<LiveChartBloc, LiveChartState>(
        builder: (c, state) {
          if (state is LiveChartLoading)
            return LoadingWidget(message: "Loading Candles...");
          if (state is LiveChartLoaded)
            return ChartWebView(
              candles: state.candles,
              emaShort: state.emaShort,
              emaLong: state.emaLong,
              rsi: state.rsi,
            );
          return ErrorScreen("Failed to load chart");
        },
      ),
    );
  }
}
EOF
cat > lib/core/ui/widgets/add_to_watchlist_sheet.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../../core/storage/watchlist.dart';

class AddToWatchlistSheet extends StatelessWidget {
  final String symbol;
  const AddToWatchlistSheet(this.symbol);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text("Add \${symbol} to Watchlist?"),
        SizedBox(height: 10),
        ElevatedButton(
          child: Text("Add"),
          onPressed: () {
            WatchlistManager().add(symbol);
            Navigator.pop(context);
          },
        ),
      ]),
    );
  }
}
EOF
cat > lib/features/settings/presentation/pages/theme_switch.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../../core/storage/app_preferences.dart';

class ThemeSwitch extends StatefulWidget {
  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    AppPreferences.loadThemeMode().then((d) {
      setState(() => _isDark = d);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text("Dark Mode"),
      value: _isDark,
      onChanged: (v) {
        AppPreferences.saveThemeMode(v);
        setState(() => _isDark = v);
      },
    );
  }
}
EOF
cat > lib/core/ui/widgets/responsive_widget.dart << 'EOF'
import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

  const ResponsiveWidget({
    required this.mobile,
    required this.tablet,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) return tablet;
          return mobile;
        },
      );
}
EOF
cat > test/unit/models/candle_tick_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/features/market/domain/models/candle.dart';
import 'package:my_app/features/market/domain/models/tick.dart';

void main() {
  test('Candle from REST JSON parsing', () {
    final json = {
      "time": "2025-01-01T10:00:00Z",
      "o": "1.1",
      "h": "1.2",
      "l": "1.05",
      "c": "1.15",
      "volume": "100"
    };

    final c = Candle.fromRestJson(json);
    expect(c.open, 1.1);
    expect(c.high, 1.2);
    expect(c.low, 1.05);
    expect(c.close, 1.15);
    expect(c.volume, 100);
  });

  test('Tick from OANDA WS JSON', () {
    final json = {
      "type": "PRICE",
      "time": "2025-01-01T10:00:01Z",
      "bids": [
        {"price": "1.25"}
      ],
      "asks": [
        {"price": "1.26"}
      ]
    };

    final t = Tick.fromOandaWs(json);
    expect(t.bid, 1.25);
    expect(t.ask, 1.26);
  });
}
EOF
cat > test/unit/network/rest_client_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

import 'package:my_app/core/network/rest/rest_client.dart';

void main() {
  test('REST GET success', () async {
    final mockClient = MockClient((request) async {
      return http.Response(jsonEncode({"result": "ok"}), 200);
    });

    final client = RestClient();
    final res = await client.get("/test", headers: {"x": "y"});
    expect(res["result"], "ok");
  });

  test('REST GET failure throws', () async {
    final mockClient = MockClient((request) async {
      return http.Response("Error", 500);
    });

    final client = RestClient();
    expect(() => client.get("/fail"), throwsA(isA<Exception>());
  });
}
EOF
cat > test/bloc/market_bloc_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:my_app/features/market/presentation/bloc/market/market_bloc.dart';
import 'package:my_app/features/market/presentation/bloc/market/market_state.dart';
import 'package:my_app/features/market/presentation/bloc/market/market_event.dart';
import 'package:my_app/features/market/data/market_repository.dart';
import 'package:my_app/core/network/rest/rest_client.dart';
import 'package:my_app/features/market/domain/streaming/live_stream_adapter.dart';

class FakeRepo extends MarketRepository {
  @override
  Future<List> getCandlesCached(
      String accountId, String instrument, String timeframe) async {
    return [];
  }
}

void main() {
  blocTest<MarketBloc, MarketState>(
    'MarketBloc load history',
    build: () => MarketBloc(FakeRepo(), LiveStreamAdapter()),
    act: (bloc) => bloc.add(LoadHistory("acc", "SYM", "M1")),
    expect: () => [isA<MarketLoadingHistory>(), isA<MarketHistoryReady>()],
  );
}
EOF
cat > test/widget/home_page_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:my_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/market/presentation/bloc/oanda/oanda_bloc.dart';

void main() {
  testWidgets("Home Page loads and shows buttons",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: HomePage()),
    );

    expect(find.text("Fetch OANDA Instruments"), findsOneWidget);
    expect(find.text("Settings"), findsOneWidget);
  });
}
EOF
cat > integration_test/app_flow_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("App Launch and Navigate", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    expect(find.text("Dashboard"), findsOneWidget);

    await tester.tap(find.text("Settings"));
    await tester.pumpAndSettle();
    expect(find.text("OANDA Settings"), findsOneWidget);
  });
}
EOF
cat > test/network/ws/ws_pipeline_test.dart << 'EOF'
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/core/network/ws/pipeline/ws_pipeline.dart';

void main() {
  test("Pipeline buffers and emits in order", () {
    final pipeline = WsPipeline(maxBufferSize: 3);
    final events = [];

    pipeline.stream.listen((data) {
      events.add(data);
    });

    pipeline.push(1);
    pipeline.push(2);
    pipeline.push(3);

    expect(events, [1, 2, 3]);
  });
}
EOF
cat > … << 'EOF'
… كود
EOF
cat > lib/core/ui/widgets/optimized_chart_webview.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OptimizedChartWebView extends StatefulWidget {
  final List<Map<String, dynamic>> candles;
  final List<Map<String, dynamic>> emaShort;
  final List<Map<String, dynamic>> emaLong;
  final List<Map<String, dynamic>> rsi;

  const OptimizedChartWebView({
    required this.candles,
    required this.emaShort,
    required this.emaLong,
    required this.rsi,
    Key? key,
  }) : super(key: key);

  @override
  _OptimizedChartWebViewState createState() => _OptimizedChartWebViewState();
}

class _OptimizedChartWebViewState extends State<OptimizedChartWebView> {
  late final WebViewController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = WebViewController();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _ctrl);
  }
}
EOF
cat > android/app/build.gradle << 'EOF'
android {
    flavorDimensions "env"
    productFlavors {
        dev {
            dimension "env"
            applicationIdSuffix ".dev"
        }
        staging {
            dimension "env"
        }
        prod {
            dimension "env"
        }
    }
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            signingConfig signingConfigs.release
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
EOF
cat > android/app/build.gradle << 'EOF'
android {
    buildTypes {
        release {
            dartObfuscate true
            minifyEnabled true
            shrinkResources true
        }
    }
}
EOF
cat > android/key.properties << 'EOF'
storePassword=YOUR_STORE_PASS
keyPassword=YOUR_KEY_PASS
keyAlias=myapp
storeFile=../myapp.keystore
EOF
cat > android/app/proguard-rules.pro << 'EOF'
# ProGuard rules here
EOF
cat > lib/core/firebase/firebase_init.dart << 'EOF'
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
}
EOF
cat > lib/core/logging/performance_logger.dart << 'EOF'
import 'dart:developer';

class PerformanceLogger {
  static void start(String name) => Timeline.startSync(name);
  static void end() => Timeline.finishSync();
}
EOF
cat > lib/core/error/global_error_handler.dart << 'EOF'
import 'package:flutter/material.dart';

void setupGlobalErrorHandler() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
}
EOF
cat > scripts/release_android.sh << 'EOF'
#!/usr/bin/env bash
EOF
cat > scripts/release_ios.sh << 'EOF'
#!/usr/bin/env bash
EOF

echo "✅ Batch 2 completed (No Flutter commands)"
date
