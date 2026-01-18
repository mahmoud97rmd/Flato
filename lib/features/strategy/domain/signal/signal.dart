enum SignalType { buy, sell, hold }

class Signal {
  final SignalType type;
  final DateTime time;

  Signal(this.type, this.time);
}
