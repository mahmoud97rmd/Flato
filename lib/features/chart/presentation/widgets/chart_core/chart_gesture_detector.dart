import 'package:flutter/material.dart';

class ChartGestureDetector extends StatefulWidget {
  final Widget child;
  final void Function(double scale, double dx) onInteraction;

  const ChartGestureDetector({
    required this.child,
    required this.onInteraction,
    Key? key,
  }) : super(key: key);

  @override
  _ChartGestureDetectorState createState() => _ChartGestureDetectorState();
}

class _ChartGestureDetectorState extends State<ChartGestureDetector> {
  double _lastScale = 1.0;
  Offset _lastFocal = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onScaleStart: (details) {
        _lastScale = 1.0;
        _lastFocal = details.focalPoint;
      },
      onScaleUpdate: (details) {
        final newScale = details.scale;
        final dx = details.focalPoint.dx - _lastFocal.dx;

        widget.onInteraction(newScale / _lastScale, dx);

        _lastScale = newScale;
        _lastFocal = details.focalPoint;
      },
      child: widget.child,
    );
  }
}
