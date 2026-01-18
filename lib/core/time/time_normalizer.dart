class TimeNormalizer {
  static DateTime toUtc(dynamic input) {
    if (input is String) return DateTime.parse(input).toUtc();
    if (input is DateTime) return input.toUtc();
    return DateTime.now().toUtc();
  }
}
