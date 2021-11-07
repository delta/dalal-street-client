// TODO: Need a better and simpler routing strategy

import 'package:dalal_street_client/blocs/login/login_bloc.dart';
import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:dalal_street_client/pages/auth/login_page.dart';
import 'package:dalal_street_client/pages/home_page.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => LoginBloc(context.read()),
                  child: const LoginPage(),
                ));
      case '/home':
        if (args is User) {
          return MaterialPageRoute(builder: (_) => HomePage(user: args));
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
        generateRoute(RouteSettings(name: '/home', arguments: userState.user))
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
