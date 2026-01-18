class DrawModeFlag {
  bool _active = false;
  void enable() => _active = true;
  void disable() => _active = false;
  bool get isActive => _active;
}
