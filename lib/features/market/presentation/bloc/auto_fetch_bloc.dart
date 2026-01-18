import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/markets_api.dart';
import '../../../core/models/dto/instrument_dto.dart';

class AutoFetchBloc extends Bloc<void, List<InstrumentDto>> {
  final MarketsApi marketsApi;

  AutoFetchBloc(this.marketsApi) : super([]) {
    on((_, emit) async {
      final list = await marketsApi.fetchAll();
      emit(list);
    });
  }
}
