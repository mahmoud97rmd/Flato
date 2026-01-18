import '../entities/tick.dart';
import '../repositories/market_repository.dart';

class StreamTicks {
  final MarketRepository repository;

  StreamTicks(this.repository);

  Stream<TickEntity> call(String instrument) {
    return repository.streamTicks(instrument);
  }
}
