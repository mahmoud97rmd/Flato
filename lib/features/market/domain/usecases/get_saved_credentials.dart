import '../repositories/market_repository.dart';

class GetSavedCredentials {
  final MarketRepository repository;

  GetSavedCredentials(this.repository);

  Future<Map<String, String>> call() async {
    return await repository.getOandaCredentials();
  }
}
