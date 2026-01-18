class StrategySettings {
  int emaShort;
  int emaLong;
  int stochKPeriod;
  int stochSmoothK;
  int stochSmoothD;
  double stopLossPercent;
  double takeProfitPercent;

  StrategySettings({
    required this.emaShort,
    required this.emaLong,
    required this.stochKPeriod,
    required this.stochSmoothK,
    required this.stochSmoothD,
    required this.stopLossPercent,
    required this.takeProfitPercent,
  });

  Map<String, dynamic> toJson() => {
        "emaShort": emaShort,
        "emaLong": emaLong,
        "stochKPeriod": stochKPeriod,
        "stochSmoothK": stochSmoothK,
        "stochSmoothD": stochSmoothD,
        "stopLossPercent": stopLossPercent,
        "takeProfitPercent": takeProfitPercent,
      };

  factory StrategySettings.fromJson(Map<String, dynamic> json) {
    return StrategySettings(
      emaShort: json["emaShort"],
      emaLong: json["emaLong"],
      stochKPeriod: json["stochKPeriod"],
      stochSmoothK: json["stochSmoothK"],
      stochSmoothD: json["stochSmoothD"],
      stopLossPercent: json["stopLossPercent"],
      takeProfitPercent: json["takeProfitPercent"],
    );
  }
}
