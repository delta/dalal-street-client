import 'package:dalal_street_client/pages/auth/login_page.dart';
import 'package:dalal_street_client/pages/home_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/home':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => HomePage(userName: args));
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() => MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Error Page')),
          body: const Center(
            child: Text('Invalid Route'),
          ),
        ),
      );
}
