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
