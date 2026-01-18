import '../../../../core/settings/token_storage.dart';
import '../../domain/stream/stream_repository.dart';
import '../live_stream_adapter.dart';

class OandaStreamRepository implements StreamRepository {
  final LiveStreamAdapter _adapter;
  OandaStreamRepository(this._adapter);

  @override
  Stream<Map<String, dynamic>> ticks() => _adapter.stream;

  @override
  Future<void> start({
    required String accountId,
    required String instruments,
    required Map<String, String> headers,
  }) async {
    await _adapter.connect(
      accountId: accountId,
      instruments: instruments,
      headers: headers,
    );
  }

  @override
  void stop() {
    _adapter.disconnect();
  }
}
