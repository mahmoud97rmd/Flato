import '../../../../core/sync/compute_guard.dart';
import '../../../core/models/candle_entity.dart';

class IndicatorEngineComputeFix {
  final ComputeGuard _guard = ComputeGuard();

  Future<Map<String, double>> computeSafe(
      List<CandleEntity> snapshot,
      Future<Map<String, double>> Function(List<CandleEntity>) computeFn) async {
    Map<String, double> result = {};
    await _guard.run(() async {
      result = await computeFn(snapshot);
    });
    return result;
  }
}
