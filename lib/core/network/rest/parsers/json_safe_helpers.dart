T safeParse<T>(dynamic value, T fallback) {
  try {
    if (value == null) return fallback;
    if (value is T) return value;
    if (T == double) return double.tryParse(value.toString()) as T? ?? fallback;
    if (T == int) return int.tryParse(value.toString()) as T? ?? fallback;
    return fallback;
  } catch (_) {
    return fallback;
  }
}
