class NetworkErrorHandler {
  static String parseError(dynamic error) {
    if (error.toString().contains('SocketException')) return "انقطع الاتصال بالإنترنت.";
    if (error.toString().contains('TimeoutException')) return "انتهت مهلة الاتصال.";
    return "حدث خطأ غير متوقع. حاول لاحقاً.";
  }
}
