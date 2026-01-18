import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseEvent {}

abstract class BaseState {}

abstract class BaseEffect {}

abstract class BaseBloc<E extends BaseEvent, S extends BaseState>
    extends Bloc<E, S> {
  BaseBloc(S initialState) : super(initialState);

  void emitSafe(S state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
