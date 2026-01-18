T? parseSafe<T>(Map<String, dynamic>? json, String key) {
  if (json == null) return null;
  final val = json[key];
  if (val == null) return null;
  return val is T ? val : null;
}
