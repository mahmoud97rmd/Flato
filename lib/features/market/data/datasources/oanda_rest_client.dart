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
