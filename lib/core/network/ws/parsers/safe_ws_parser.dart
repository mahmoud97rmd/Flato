import '../../../../core/data/sanitizer/data_sanitizer.dart';

Map<String, dynamic>? safeWS(Map<String, dynamic>? data) {
  if (data == null) return null;
  if (!DataSanitizer.isValidNumber(data['price'])) return null;
  return data;
}
