class OandaConfig {
  static const bool useLive = false; // false = practice, true = live
  static String get baseUrl => useLive
      ? "https://api-fxtrade.oanda.com/v3"
      : "https://api-fxpractice.oanda.com/v3";
}
