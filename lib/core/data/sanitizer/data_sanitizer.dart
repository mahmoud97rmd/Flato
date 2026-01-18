class DataSanitizer {
  static bool isValidNumber(dynamic v) {
    if (v == null) return false;
    if (v is num) return true;
    return num.tryParse(v.toString()) != null;
  }

  static double safeDouble(dynamic v, {double fallback = 0.0}) {
    return isValidNumber(v) ? double.parse(v.toString()) : fallback;
  }

  static bool isValidMap(Map? m) => m != null && m.isNotEmpty;
}
