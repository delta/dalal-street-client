import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:dalal_street_client/config.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/navigation/route_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
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
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) => MaterialApp(
            title: 'Dalal Street 2021',
            navigatorKey: _navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                textTheme:
                    GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)),
            builder: (context, child) => BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserLoggedIn) {
                  print('user logged in');
                  _navigator.pushNamedAndRemoveUntil('/home', (route) => false,
                      arguments: state.user.name);
                } else {
                  print('user logged out');
                  _navigator.pushNamedAndRemoveUntil(
                      '/login', (route) => false);
                }
              },
              child: child,
            ),
            initialRoute: (state is UserLoggedIn) ? '/home' : '/login',
            onGenerateInitialRoutes: (initialRoute) =>
                RouteGenerator.generateInitialRoute(initialRoute, state),
            onGenerateRoute: RouteGenerator.generateRoute,
          ),
        ),
      );
}
