import 'package:flutter/widgets.dart';

class RepaintBoundaryChart extends StatelessWidget {
  final Widget child;

  RepaintBoundaryChart({required this.child});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: child);
  }
}
