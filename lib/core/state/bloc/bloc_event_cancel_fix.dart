import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin BlocEventCancelFix<Event> on Bloc<Event, dynamic> {
  final List<StreamSubscription> _evtSubs = [];

  void addCancelable(StreamSubscription sub) => _evtSubs.add(sub);

  @override
  Future<void> close() async {
    for (final s in _evtSubs) {
      await s.cancel();
    }
    _evtSubs.clear();
    return super.close();
  }
}
