import 'package:logger/logger.dart';

/// Logging
///
/// for more configurations, checkout https://pub.dev/packages/logger
final Logger logger = Logger(
    printer: PrettyPrinter(
  lineLength: 120,
  colors: true,
  printEmojis: true,
));
