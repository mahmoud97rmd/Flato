import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:dio_retry/strategies/exponential_retry_strategy.dart';

class RestRetryInterceptor {
  static void apply(Dio dio) {
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: print,
        retryDelays: ExponentialRetryStrategy().delays,
      ),
    );
  }
}
