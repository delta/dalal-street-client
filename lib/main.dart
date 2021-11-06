import 'package:dalal_street_client/config.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'blocs/user/user_bloc.dart';
import 'pages/auth/login_page.dart';
import 'pages/home_page.dart';
import 'utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await readConfig();
  await initClients();
  runApp(DalalApp());
}

class DalalApp extends StatelessWidget {
  DalalApp({Key? key}) : super(key: key);

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => UserBloc(),
        child: MaterialApp(
          title: 'Dalal Street 2021',
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme:
                  GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)),
          builder: (context, child) => BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserLoggedIn) {
                _navigator.pushAndRemoveUntil(
                    route(HomePage(userName: state.user.name)),
                    (route) => false);
              } else {
                _navigator.pushAndRemoveUntil(
                    route(const LoginPage()), (route) => false);
              }
            },
            child: child,
          ),
          onGenerateRoute: (_) => route(const LoginPage()),
        ),
      );
}
