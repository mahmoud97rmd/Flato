import 'package:get_it/get_it.dart';
import '../network/http/rest_client.dart';
import '../../features/market/data/repositories/oanda_market_repository.dart';
import '../../features/market/domain/repositories/market_repository.dart';

final GetIt di = GetIt.instance;

void setupDI() {
  di.registerLazySingleton(() => RestClient());
  di.registerLazySingleton<MarketRepository>(
      () => OandaMarketRepository(di()));
}
import '../../features/market/data/stream/live_stream_adapter.dart';
import '../../features/market/data/stream/repositories/oanda_stream_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../network/ws/transport/ws_transport.dart';
import 'package:get_it/get_it.dart';

// Inside setupDI()
di.registerLazySingleton(() => WsTransport());
di.registerLazySingleton(() => LiveStreamAdapter(di()));
di.registerLazySingleton<StreamRepository>(
    () => OandaStreamRepository(di()));
