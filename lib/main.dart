import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:dalal_street_client/config.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/navigation/route_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

final GetIt getIt = GetIt.I;

void main() async {
  // Something doesnt work without this line. Dont remember what
  WidgetsFlutterBinding.ensureInitialized();

  // Provide storage directory for persisting/restoring the HydratedBloc state
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  // Read GrpcConfig from config.json and initialise ActionClient, StreamClient
  await readConfig();
  await initClients();

  // Start the app
  runApp(
    // Provide UserBloc at the root of the App
    BlocProvider(
      create: (_) => UserBloc(),
      child: DalalApp(),
    ),
  );
}

class DalalApp extends StatelessWidget {
  DalalApp({Key? key}) : super(key: key);

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(context) => MaterialApp(
        title: 'Dalal Street 2021',
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)),
        // Show snackbar and navigate to Home or Login page whenever UserState changes
        builder: (context, child) => BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserDataLoaded) {
              // Register sessionId
              getIt.registerSingleton(state.sessionId);

              print('user logged in');
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(content: Text('Welcome ${state.user.name}')));
              _navigator.pushNamedAndRemoveUntil('/home', (route) => false,
                  arguments: state.user);
            } else if (state is UserLoggedOut) {
              if (!state.fromSplash) {
                // Unregister sessionId
                getIt.unregister<String>();

                // Show msg only when comming from a page other than splash
                print('user logged out');
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                      const SnackBar(content: Text('User Logged Out')));
              }
              _navigator.pushNamedAndRemoveUntil('/login', (route) => false);
            }
          },
          child: child,
        ),
        // Routing
        initialRoute: '/splash',
        onGenerateRoute: RouteGenerator.generateRoute,
      );
}
