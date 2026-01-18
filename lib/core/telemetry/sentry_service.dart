import 'package:sentry_flutter/sentry_flutter.dart';

class SentryService {
  static Future<void> init() async {
    await SentryFlutter.init(
      (options) => options.dsn = 'YOUR_SENTRY_DSN_HERE',
    );
  }
}
