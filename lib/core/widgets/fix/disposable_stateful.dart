import 'package:flutter/widgets.dart';

abstract class DisposableStateful<T extends StatefulWidget> extends State<T> {
  @override
  void dispose() {
    super.dispose();
  }

  void cleanUp() {
    dispose();
  }
}
