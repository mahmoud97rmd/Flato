
  Future<Map<String, dynamic>> fetchOpenPositions() async {
    final endpoint = "/accounts/\$accountId/openPositions";
    final response = await _dio.get(endpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> closePosition(String instrument) async {
    final endpoint = "/accounts/\$accountId/positions/\$instrument/close";
    final response = await _dio.put(endpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> modifyPosition(String instrument, Map<String, dynamic> body) async {
    final endpoint = "/accounts/\$accountId/positions/\$instrument";
    final response = await _dio.put(endpoint, data: body);
    return response.data;
  }

  void setTokenExpiredCallback(Function()? callback) {
    _tokenExpiredCallback = callback;
  }

  Function()? _tokenExpiredCallback;
