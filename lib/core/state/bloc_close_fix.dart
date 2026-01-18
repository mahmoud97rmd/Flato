import 'package:flutter_bloc/flutter_bloc.dart';

mixin BlocCloseFix on BlocBase {
  @override
  Future<void> close() async {
    await super.close();
  }
}
