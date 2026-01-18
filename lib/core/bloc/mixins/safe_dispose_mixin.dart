import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin SafeDisposeMixin on BlocBase {
  final List<StreamSubscription> _subs = [];

  void addSub(StreamSubscription sub) => _subs.add(sub);

  @override
  Future<void> close() async {
    for (final s in _subs) await s.cancel();
    _subs.clear();
    return super.close();
  }
}
