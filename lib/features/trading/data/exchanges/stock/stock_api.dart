import '../../../core/network/rest_client.dart';

class StockApi {
  final RestClient client;

  StockApi(this.client);

  Future<double> fetchQuote(String symbol) async {
    final res = await client.get("/stocks/$symbol/quote");
    return double.parse(res['quote']);
  }
}
