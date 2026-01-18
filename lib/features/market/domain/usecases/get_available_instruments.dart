import '../repositories/market_repository.dart';

class GetAvailableInstruments {
  final MarketRepository repository;

  GetAvailableInstruments(this.repository);

  Future<List<String>> call() async {
    return await repository.fetchAvailableInstruments();
  }
}
