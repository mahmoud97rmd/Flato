import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:my_app/core/network/security/pinning/pin_store.dart';

void main() {
  test("Cert pin lists not empty", () {
    expect(PinStore.sandboxRestPins.isNotEmpty, true);
    expect(PinStore.sandboxStreamPins.isNotEmpty, true);
    expect(PinStore.liveRestPins.isNotEmpty, true);
    expect(PinStore.liveStreamPins.isNotEmpty, true);
  });
}
