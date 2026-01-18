import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBookReset extends OrderBookEvent {}

class OrderBookBlocResetFix extends Bloc<OrderBookEvent, OrderBookState> {
  OrderBookBlocResetFix(): super(OrderBookInitial()) {
    on<OrderBookReset>((_, emit) {
      emit(OrderBookInitial(bids: [], asks: []));
    });

    on<SubscribeUpdates>((event, emit) {
      add(OrderBookReset()); // تنظيف
      // بعد ذلك اشترك في Stream جديد
    });
  }
}
