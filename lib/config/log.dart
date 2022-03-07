import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Logging
///
/// for more configurations, checkout https://pub.dev/packages/logger
final Logger logger = Logger(
  filter: DalalLogFilter(),
  printer: PrettyPrinter(
    colors: true,
    printEmojis: true,
  ),
);

/// Custom log filter, which gives default behaviour in debug mode, and shows
/// only non-debug logs in release mode
///
/// see https://pub.dev/packages/logger#logfilter
class DalalLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (!kReleaseMode) {
      return _defaultShouldLog(event);
    }
    if (event.level != Level.debug) {
      return true;
    }
    return false;
  }

  /// From https://pub.dev/documentation/logger/1.1.0/logger/DevelopmentFilter/shouldLog.html
  bool _defaultShouldLog(LogEvent event) {
    var shouldLog = false;
    assert(() {
      if (event.level.index >= level!.index) {
        shouldLog = true;
      }
      return true;
    }());
    return shouldLog;
  }
}
