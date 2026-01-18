import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersUpdateGuardBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersUpdateGuardBloc(): super(OrdersIdle()) {
    on<OrderExecuted>((evt, emit) {
      // immediate update after execution
      emit(OrdersUpdated(evt.updatedList));
    });
  }
}
