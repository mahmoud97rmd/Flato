class XAxisRange {
  final DateTime min;
  final DateTime max;

  const XAxisRange({required this.min, required this.max});

  bool contains(DateTime t) => t.isAfter(min) && t.isBefore(max);
}
