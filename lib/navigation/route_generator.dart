// TODO: Need a better and simpler routing strategy

import 'package:dalal_street_client/blocs/auth/login/login_cubit.dart';
import 'package:dalal_street_client/blocs/auth/register/register_cubit.dart';
import 'package:dalal_street_client/blocs/auth/verify_phone/enter_otp/enter_otp_cubit.dart';
import 'package:dalal_street_client/blocs/auth/verify_phone/enter_phone/enter_phone_cubit.dart';
import 'package:dalal_street_client/pages/auth/check_mail_page.dart';
import 'package:dalal_street_client/pages/auth/login_page.dart';
import 'package:dalal_street_client/pages/auth/register_page.dart';
import 'package:dalal_street_client/pages/auth/verify_phone/enter_otp_page.dart';
import 'package:dalal_street_client/pages/auth/verify_phone/enter_phone_page.dart';
import 'package:dalal_street_client/pages/home_page.dart';
import 'package:dalal_street_client/pages/landing_page.dart';
import 'package:dalal_street_client/pages/splash_page.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case '/landing':
        return MaterialPageRoute(builder: (_) => const LandingPage());

      // Auth Pages
      case '/login':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LoginCubit(context.read()),
            child: LoginPage(),
          ),
        );
      case '/register':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => RegisterCubit(),
            child: RegisterPage(),
          ),
        );
      case '/checkMail':
        return MaterialPageRoute(builder: (_) => const CheckMailPage());
      // Verify Phone Pages
      case '/enterPhone':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => EnterPhoneCubit(context.read()),
            child: EnterPhonePage(),
          ),
        );
      case '/enterOtp':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => EnterOtpCubit(context.read(), args),
              child: const EnterOtpPage(),
            ),
          );
        }
        return _errorRoute(msg: 'Invalid phone args');

      // Home Pages
      case '/home':
        if (args is User) {
          return MaterialPageRoute(builder: (_) => HomePage(user: args));
        }
        return _errorRoute(msg: 'Invalid user args');
      default:
        return _errorRoute();
    }
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
