import '../../../../../core/state/shared/price_volume_state.dart';

class ExecutionSnapshotGuard {
  final PriceVolumeState _stateHolder;

  ExecutionSnapshotGuard(this._stateHolder);

  Map<String, double> snapshot() {
    return {
      "price": _stateHolder.price,
      "volume": _stateHolder.volume,
    };
  }
}
