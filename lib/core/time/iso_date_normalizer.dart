class IsoDateNormalizer {
  static String normalize(dynamic value) {
    try {
      return DateTime.parse(value.toString()).toUtc().toIso8601String();
    } catch (_) {
      return DateTime.now().toUtc().toIso8601String();
    }
  }
}
