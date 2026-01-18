class TouchEventFilter {
  bool drawingMode = false;

  bool shouldHandleTouch(double x, double y) {
    return drawingMode; // فقط في وضع الرسم
  }
}
