class TimeCanon {
  /// يحوّل أي DateTime أو String إلى UTC موحّد
  static DateTime toUtc(dynamic t) {
    if (t is DateTime) {
      return t.toUtc();
    }
    if (t is String) {
      return DateTime.parse(t).toUtc();
    }
    throw ArgumentError("Unsupported time type: $t");
  }

  /// يقارن زمنين بعد توحيدهما
  static bool isSameInstant(dynamic a, dynamic b) {
    return toUtc(a).isAtSameMomentAs(toUtc(b));
  }

  /// يضمن أن أي Timestamp صادر عن النظام هو UTC فقط
  static String isoUtc(DateTime t) {
    return t.toUtc().toIso8601String();
  }
}
