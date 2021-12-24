// TODO: Need a better and simpler routing strategy

import 'package:dalal_street_client/blocs/auth/login/login_cubit.dart';
import 'package:dalal_street_client/blocs/auth/register/register_cubit.dart';
import 'package:dalal_street_client/blocs/auth/verify_phone/enter_otp/enter_otp_cubit.dart';
import 'package:dalal_street_client/blocs/auth/verify_phone/enter_phone/enter_phone_cubit.dart';
import 'package:dalal_street_client/blocs/companies/companies_bloc.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/blocs/daily_challenges/daily_challenges_page_cubit.dart';
import 'package:dalal_street_client/pages/auth/check_mail_page.dart';
import 'package:dalal_street_client/pages/auth/login_page.dart';
import 'package:dalal_street_client/pages/auth/register_page.dart';
import 'package:dalal_street_client/pages/auth/verify_phone/enter_otp_page.dart';
import 'package:dalal_street_client/pages/auth/verify_phone/enter_phone_page.dart';
import 'package:dalal_street_client/pages/daily_challenges/daily_challenges_page.dart';
import 'package:dalal_street_client/pages/home_page.dart';
import 'package:dalal_street_client/pages/landing_page.dart';
import 'package:dalal_street_client/pages/splash_page.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    try {
      final page = _getPage(settings);
      return MaterialPageRoute(builder: (_) => page, settings: settings);
    } catch (e) {
      return _errorRoute(e.toString());
    }
  }

  static Widget _getPage(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/splash':
        return const SplashPage();
      case '/landing':
        return const LandingPage();

      // Auth Pages
      case '/login':
        return BlocProvider(
          create: (context) => LoginCubit(context.read()),
          child: LoginPage(),
        );
      case '/register':
        return BlocProvider(
            create: (context) => RegisterCubit(), child: RegisterPage());
      case '/checkMail':
        if (args is String) {
          return CheckMailPage(mail: args);
        }
        throw Exception('Invalid args in check mail page');
      // Verify Phone Pages
      case '/enterPhone':
        return BlocProvider(
          create: (context) => EnterPhoneCubit(context.read()),
          child: EnterPhonePage(),
        );
      case '/enterOtp':
        if (args is String) {
          return BlocProvider(
            create: (context) => EnterOtpCubit(context.read(), args),
            child: const EnterOtpPage(),
          );
        }
        throw Exception('Invalid phone args');

      // Home Pages
      case '/home':
        if (args is User) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => CompaniesBloc(),
              ),
              BlocProvider(
                create: (context) => SubscribeCubit(),
              ),
            ],
            child: HomePage(user: args),
          );
        }
        throw Exception('Invalid user args');
      case '/dailyChallenges':
        return BlocProvider(
          create: (context) => DailyChallengesPageCubit()..getChallengesConfig(),
          child: const DailyChallengesPage(),
        );
      default:
        throw Exception('Invalid Route');
    }
  }

  static Route<dynamic> _errorRoute(String msg) => MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Error Page')),
          body: Center(
            child: Text(msg),
          ),
        ),
      );
}
