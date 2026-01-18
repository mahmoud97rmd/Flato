class TouchModeGuard {
  bool drawing = false;

  bool allowWebViewGesture() => !drawing;
}
