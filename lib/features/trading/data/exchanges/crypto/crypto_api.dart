import '../../../core/network/rest_client.dart';

class CryptoApi {
  final RestClient client;

  CryptoApi(this.client);

  Future<double> fetchPrice(String symbol) async {
    final res = await client.get("/crypto/$symbol/price");
    return double.parse(res['price']);
  }
}
