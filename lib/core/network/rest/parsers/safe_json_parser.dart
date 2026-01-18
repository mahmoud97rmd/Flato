T? safeJsonParse<T>(Map<String, dynamic>? json, String key) {
  if (json == null) return null;
  if (!json.containsKey(key)) return null;
  return json[key] as T;
}
