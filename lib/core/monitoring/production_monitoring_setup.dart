import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// ======================================================
/// 1) Initialize Sentry (Crash Reporting + Performance)
/// ======================================================
class ProductionMonitoring {
  static Future<void> init({
    required String dsn,
    bool enablePerformance = true,
  }) async {
    await SentryFlutter.init(
      (options) {
        options.dsn = dsn;
        options.tracesSampleRate = enablePerformance ? 1.0 : 0.0;
      },
      // ensure Init before Widgets binding
      appRunner: () => runApp(MyApp()),
    );
  }
}

/// ======================================================
/// 2) Error Handler (Global)
/*
   أي خطأ غير ملتقط سيتم إرساله للسنتري تلقائيًا
*/
void setupGlobalErrorHandler() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    Sentry.captureException(
      details.exception,
      stackTrace: details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    Sentry.captureException(error, stackTrace: stack);
    return true;
  };
}
