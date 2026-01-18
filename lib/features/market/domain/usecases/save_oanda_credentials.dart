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
