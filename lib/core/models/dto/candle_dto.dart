class CandleDto {
  final String time;
  final String open;
  final String high;
  final String low;
  final String close;
  final String volume;

  CandleDto({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory CandleDto.fromJson(Map<String, dynamic> json) {
    return CandleDto(
      time: json['time'],
      open: json['o'],
      high: json['h'],
      low: json['l'],
      close: json['c'],
      volume: json['v'],
    );
  }
}
