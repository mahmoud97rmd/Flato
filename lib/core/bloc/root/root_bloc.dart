import 'package:flutter_bloc/flutter_bloc.dart';
import 'root_event.dart';
import 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc() : super(AppUninitialized()) {
    on<InitApp>((event, emit) {
      emit(AppReady());
    });

    on<ConnectionStatusChanged>((event, emit) {
      emit(ConnectivityState(event.connected));
    });

    on<GlobalErrorOccurred>((event, emit) {
      emit(AppErrorState(event.message));
    });

    on<TerminateApp>((event, emit) {
      // يمكن إضافة Cleanup هنا
      emit(AppTerminated());
    });
  }
}
