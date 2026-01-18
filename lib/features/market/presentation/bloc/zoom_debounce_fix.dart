import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/debounce.dart';

class ZoomBloc extends Bloc<ZoomEvent, ZoomState> {
  final Debouncer _debouncer = Debouncer(Duration(milliseconds: 200));

  ZoomBloc(): super(ZoomIdle()) {
    on<ZoomChanged>((event, emit) {
      _debouncer(() {
        emit(ZoomUpdated(event.range));
      });
    });
  }
}
