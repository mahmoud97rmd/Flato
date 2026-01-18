import 'package:flutter/foundation.dart';

class PriceVolumeState with ChangeNotifier {
  double _price = 0, _volume = 0;

  double get price => _price;
  double get volume => _volume;

  void update(double p, double v) {
    _price = p;
    _volume = v;
    notifyListeners();
  }
}
