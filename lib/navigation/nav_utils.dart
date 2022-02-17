import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Useful extensions for gorouter navigation
extension NavUtils on BuildContext {
  /// Executes `context.go()` inside `Router.neglect()`
  void webGo(String location, {Object? extra}) {
    Router.neglect(
      this,
      () => go(location, extra: extra),
    );
  }
}
