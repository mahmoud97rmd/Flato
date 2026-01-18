enum Timeframe {
  m1,
  m5,
  m15,
  h1,
}

extension TimeframeExt on Timeframe {
  Duration get duration {
    switch (this) {
      case Timeframe.m1:
        return Duration(minutes: 1);
      case Timeframe.m5:
        return Duration(minutes: 5);
      case Timeframe.m15:
        return Duration(minutes: 15);
      case Timeframe.h1:
        return Duration(hours: 1);
    }
  }

  String get oandaName {
    switch (this) {
      case Timeframe.m1:
        return "M1";
      case Timeframe.m5:
        return "M5";
      case Timeframe.m15:
        return "M15";
      case Timeframe.h1:
        return "H1";
    }
  }
}
