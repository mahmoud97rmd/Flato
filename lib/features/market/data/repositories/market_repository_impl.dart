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

  @override
  Future<Map<String, dynamic>> executeOrder(OrderRequest request) async {
    final body = request.toJson();
    final res = await _restClient!.placeOrder(body);
    return res;
  }

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
