import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocAutoDisposeRoute<T> extends MaterialPageRoute<T> {
  final BlocProvider _provider;

  BlocAutoDisposeRoute({required Widget child, required BlocProvider provider})
      : _provider = provider,
        super(builder: (_) => child);

  @override
  void dispose() {
    _provider.close();
    super.dispose();
  }
}
