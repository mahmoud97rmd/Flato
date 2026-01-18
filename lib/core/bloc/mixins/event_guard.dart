mixin EventGuard<T> {
  bool isValidEvent(T event) {
    if (event == null) return false;
    return true;
  }
}
