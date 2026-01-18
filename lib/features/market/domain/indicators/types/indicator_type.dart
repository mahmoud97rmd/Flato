enum IndicatorDisplayMode {
  overlay,     // رسم فوق الشارت
  subChart,    // رسم أسفل الشارت في نافذة مستقلة
}

class IndicatorType {
  final String id;
  final String label;
  final IndicatorDisplayMode mode;

  const IndicatorType({
    required this.id,
    required this.label,
    required this.mode,
  });
}

const IndicatorType EMA = IndicatorType(id: "ema", label: "EMA", mode: IndicatorDisplayMode.overlay);
const IndicatorType BOLLINGER = IndicatorType(id: "bollinger", label: "Bollinger Bands", mode: IndicatorDisplayMode.overlay);
const IndicatorType STOCH = IndicatorType(id: "stoch", label: "Stochastic", mode: IndicatorDisplayMode.subChart);
const IndicatorType RSI = IndicatorType(id: "rsi", label: "RSI", mode: IndicatorDisplayMode.subChart);
