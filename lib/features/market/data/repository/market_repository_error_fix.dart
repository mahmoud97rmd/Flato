import '../../../../core/network/error/network_error_handler.dart';
import '../../../../core/network/rest_error.dart';

Future<List<CandleEntity>> safeFetchHistory(...) async {
  try {
    return await _fetchHistory(...);
  } catch (e) {
    final type = NetworkErrorHandler.classify(e);
    final message = NetworkErrorHandler.message(type);
    throw RestError(message);
  }
}
