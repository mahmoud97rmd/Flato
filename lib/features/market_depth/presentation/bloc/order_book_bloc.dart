import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/order_book.dart';

abstract class OrderBookEvent {}
class OrderBookUpdate extends OrderBookEvent {
  final OrderBook book;
  OrderBookUpdate(this.book);
}

abstract class OrderBookState {}
class OrderBookInitial extends OrderBookState {}
class OrderBookLoaded extends OrderBookState {
  final OrderBook book;
  OrderBookLoaded(this.book);
}

class OrderBookBloc extends Bloc<OrderBookEvent, OrderBookState> {
  OrderBookBloc(): super(OrderBookInitial()) {
    on<OrderBookUpdate>((evt, emit) => emit(OrderBookLoaded(evt.book)));
  }
}
