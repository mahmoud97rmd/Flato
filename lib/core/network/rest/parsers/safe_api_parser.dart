import '../../../../core/data/sanitizer/data_sanitizer.dart';

class SafeApiParser {
  static Map<String, dynamic> parseCandle(Map<String, dynamic>? json) {
    if (json == null) return {};
    return {
      'time': json['time'] ?? '',
      'open': DataSanitizer.safeDouble(json['open']),
      'high': DataSanitizer.safeDouble(json['high']),
      'low': DataSanitizer.safeDouble(json['low']),
      'close': DataSanitizer.safeDouble(json['close']),
      'volume': DataSanitizer.safeDouble(json['volume']),
    };
  }
}
