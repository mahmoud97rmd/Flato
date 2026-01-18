import 'package:logger/logger.dart';

var appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
  ),
);
