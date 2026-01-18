Map<String, dynamic>? safeParse(dynamic data) {
  try {
    if (data == null || data['price'] == null) return null;
    return data as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}
