import 'package:dalal_street_client/blocs/user/user_bloc.dart';
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
        return _errorRoute(msg: 'Invalid user args');
      default:
        return _errorRoute();
    }
  }

  static List<Route<dynamic>> generateInitialRoute(
      String initialRoutes, UserState userState) {
    var routesList = [generateRoute(const RouteSettings(name: '/login'))];
    if (userState is UserLoggedIn) {
      routesList = [
        generateRoute(
            RouteSettings(name: '/home', arguments: userState.user.name))
      ];
    }
    return routesList;
  }

  static Route<dynamic> _errorRoute({String msg = 'Invalid Route'}) =>
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Error Page')),
          body: Center(
            child: Text(msg),
          ),
        ),
      );
}
