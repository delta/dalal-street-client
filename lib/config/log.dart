import 'package:logger/logger.dart';

/// Logging
///
/// for more configurations, checkout https://pub.dev/packages/logger
final Logger logger = Logger(
    printer: PrettyPrinter(
  colors: true,
  printEmojis: true,
));
