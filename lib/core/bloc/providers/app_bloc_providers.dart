import 'package:flutter_bloc/flutter_bloc.dart';

import '../root/root_bloc.dart';
import '../../features/market/presentation/bloc/market/market_bloc.dart';
import '../../features/market/presentation/bloc/stream/stream_bloc.dart';
import '../../features/trading/presentation/bloc/trading_bloc.dart';

class AppBlocProviders {
  static List<BlocProvider> all(
    dynamic marketRepo,
    dynamic streamAdapter,
  ) {
    return [
      BlocProvider<RootBloc>(create: (_) => RootBloc()),
      BlocProvider<MarketBloc>(
          create: (_) => MarketBloc(marketRepo, streamAdapter)),
      BlocProvider<StreamBloc>(
          create: (_) => StreamBloc(streamAdapter)),
      BlocProvider<TradingBloc>(create: (_) => TradingBloc()),
    ];
  }
}
