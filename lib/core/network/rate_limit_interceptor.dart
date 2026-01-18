import 'package:dio/dio.dart';

class RateLimitInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 429) {
      final retryAfter = int.tryParse(err.response?.headers.value('retry-after') ?? '1') ?? 1;
      Future.delayed(Duration(seconds: retryAfter), () {
        handler.next(err);
      });
      return;
    }
    handler.next(err);
  }
}
