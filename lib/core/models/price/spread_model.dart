class SpreadModel {
  final double bid;
  final double ask;

  SpreadModel({required this.bid, required this.ask});

  double get spread => ask - bid;
}
