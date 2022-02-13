import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension NavUtils on BuildContext {
  void replace(String location, {Object? extra}) {
    Router.neglect(
      this,
      () => go(location, extra: extra),
    );
  }
}
