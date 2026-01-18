class SymbolNormalizer {
  /// يحوّل أي صيغة رمزية لـ "CONCAT" (بدون underscore)
  static String normalize(String sym) {
    return sym.replaceAll("_", "").toUpperCase();
  }

  /// يفصّل الصيغة إلى زوج/سوق
  static String formatWithUnderscore(String sym) {
    final n = normalize(sym);
    // مثال: XAUUSD → XAU_USD
    if (n.length == 6) {
      return "${n.substring(0, 3)}_${n.substring(3)}";
    }
    return sym;
  }
}
