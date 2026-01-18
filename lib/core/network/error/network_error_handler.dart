import 'dart:io';

enum NetworkErrorType {
  noConnection,
  timeout,
  serverError,
  unknown
}

class NetworkErrorHandler {
  static NetworkErrorType classify(error) {
    if (error is SocketException) {
      return NetworkErrorType.noConnection;
    } else if (error is TimeoutException) {
      return NetworkErrorType.timeout;
    } else if (error.toString().contains('500')) {
      return NetworkErrorType.serverError;
    }
    return NetworkErrorType.unknown;
  }

  static String message(NetworkErrorType type) {
    switch (type) {
      case NetworkErrorType.noConnection:
        return "لا يوجد اتصال بالإنترنت.";
      case NetworkErrorType.timeout:
        return "انتهت مهلة الاتصال.";
      case NetworkErrorType.serverError:
        return "هناك خطأ في الخادم.";
      case NetworkErrorType.unknown:
      default:
        return "حدث خطأ غير متوقع في الشبكة.";
    }
  }
}
