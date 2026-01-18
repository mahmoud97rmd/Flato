import 'package:dio/dio.dart';

enum OandaErrorType { network, client, server, rateLimit, unknown }

OandaErrorType classifyError(DioError e) {
  if (e.type == DioErrorType.connectTimeout || e.type == DioErrorType.receiveTimeout) {
    return OandaErrorType.network;
  }
  final status = e.response?.statusCode ?? 0;
  if (status >= 400 && status < 500) return OandaErrorType.client;
  if (status == 429) return OandaErrorType.rateLimit;
  if (status >= 500) return OandaErrorType.server;
  return OandaErrorType.unknown;
}
