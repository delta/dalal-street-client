import 'package:dalal_street_client/config.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'blocs/user/user_bloc.dart';
import 'pages/auth/login_page.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await readConfig();
  await initClients();
  runApp(const DalalApp());
}

class DalalApp extends StatelessWidget {
  const DalalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => UserBloc(),
        child: MaterialApp(
          title: 'Dalal Street 2021',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme:
                  GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)),
          home: Scaffold(
            backgroundColor: UiColors.primary,
            body: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoggedOut) {
                  return const LoginPage();
                }
                return const HomePage();
              },
            ),
          ),
        ),
      );
}
