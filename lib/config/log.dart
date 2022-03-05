import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Logging
///
/// for more configurations, checkout https://pub.dev/packages/logger
final Logger logger = Logger(
  filter: _filter,
  printer: PrettyPrinter(
    colors: true,
    printEmojis: true,
  ),
);

final _filter = DalalLogFilter();

/// see https://pub.dev/packages/logger#logfilter
class DalalLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    var shouldLog = false;
    assert(() {
      if (!kReleaseMode) {
        shouldLog = DevelopmentFilter().shouldLog(event);
      }
      if (event.level != Level.debug) {
        shouldLog = true;
      }
      return false;
    }());
    return shouldLog;
  }
}
