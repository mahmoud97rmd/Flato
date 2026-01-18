Map<String, dynamic>? parseSafeDepth(Map<String, dynamic>? data) {
  if (data == null) return null;
  if (!data.containsKey('bids') || !data.containsKey('asks')) return null;
  return {
    'bids': data['bids'] ?? [],
    'asks': data['asks'] ?? [],
  };
}
