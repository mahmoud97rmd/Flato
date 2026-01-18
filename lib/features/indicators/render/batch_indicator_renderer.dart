import 'dart:ui';

class BatchIndicatorRenderer {
  void draw(Canvas canvas, Size size, List<Function(Canvas, Size)> draws) {
    for (final drawFn in draws) {
      drawFn(canvas, size);
    }
  }
}
