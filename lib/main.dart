import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/bloc/bloc_observer.dart';
import 'core/di/dependency_injection.dart';
import 'core/di/hive_init.dart';
import 'core/navigation/app_router.dart';
import 'core/ui/theme_setup.dart';

import 'features/market/presentation/bloc/oanda/oanda_bloc.dart';
import 'features/market/data/oanda_market_repository.dart';
import 'features/chart/presentation/bloc/candles_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  await initHive();
  await setupDependencies();

  final repo = OandaMarketRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OandaBloc(repo)),
        BlocProvider(create: (_) => CandlesBloc(repo)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Trading App',
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
