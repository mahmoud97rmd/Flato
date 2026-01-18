import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/bloc/oanda/oanda_setup_bloc.dart';
import '../../presentation/bloc/oanda/oanda_setup_state.dart';
import '../../presentation/bloc/markets/markets_bloc.dart';
import '../../presentation/bloc/markets/markets_event.dart';
import '../../presentation/bloc/markets/markets_state.dart';
import '../../data/repositories/market_repository_impl.dart';
import '../../data/datasources/local_storage.dart';
import '../widgets/market_list_widget.dart';
import '../pages/oanda_settings_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final localStorage = LocalStorage();
    final repository = MarketRepositoryImpl(localStorage: localStorage);

    return Scaffold(
      appBar: AppBar(title: Text("Trading App")),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => MarketsBloc(
              repository: repository,
              storage: localStorage,
            )..add(LoadMarkets()),
          ),
        ],
        child: SafeArea(
          child: BlocBuilder<MarketsBloc, MarketsState>(
            builder: (context, state) {
              if (state is MarketsLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is MarketsLoaded) {
                return MarketListWidget(instruments: state.instruments);
              }
              if (state is MarketsEmpty) {
                return Center(child: Text("No markets available"));
              }
              if (state is MarketsError) {
                return Center(child: Text("Error: ${state.message}"));
              }
              return Center(child: Text("Welcome"));
            },
          ),
        ),
      ),
    );
  }
}
