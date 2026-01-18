import 'package:logger/logger.dart';

class LoggerService {
  static final Logger _logger = Logger();

  static void d(String msg) => _logger.d(msg);
  static void e(String msg, [dynamic err]) => _logger.e(msg, err);
  static void i(String msg) => _logger.i(msg);
}
