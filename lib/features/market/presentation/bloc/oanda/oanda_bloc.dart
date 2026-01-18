import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/oanda_market_repository.dart';

part 'oanda_event.dart';
part 'oanda_state.dart';

class OandaBloc extends Bloc<OandaEvent, OandaState> {
  final OandaMarketRepository repo;

  OandaBloc(this.repo) : super(OandaInitial()) {
    on<LoadInstruments>((_, emit) async {
      emit(OandaLoading());
      try {
        final list = await repo.getInstruments();
        emit(OandaLoaded(list));
      } catch (e) {
        emit(OandaError(e.toString()));
      }
    });
  }
}
