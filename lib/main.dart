import 'package:dalal_street_client/blocs/dalal/dalal_bloc.dart';
import 'package:dalal_street_client/config/config.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/navigation/route_generator.dart';
import 'package:dalal_street_client/theme/theme.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:path_provider/path_provider.dart';

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
    // Provide DalalBloc at the root of the App
    BlocProvider(
      create: (_) => DalalBloc(),
      child: DalalApp(),
    ),
  );
}

// TODO: add proper validationMessages in all ReactiveForms
// TODO: add metadata in all forms to facilitate Autofill
// TODO: do that thing where if we hit enter while filling a form the focus will shift to the next textfield. Don't know what it's called
class DalalApp extends StatelessWidget {
  DalalApp({Key? key}) : super(key: key);

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(context) => MaterialApp(
        title: 'Dalal Street 2021',
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        themeMode: ThemeMode.dark,
        // Show snackbar and navigate to Home or Login page whenever UserState changes
        builder: (context, child) => BlocListener<DalalBloc, DalalState>(
          listener: (context, state) {
            if (state is DalalDataLoaded) {
              // Register sessionId
              getIt.registerSingleton(state.sessionId);
              // Register static company infos
              getIt.registerSingleton(state.companies);
              // Register Global Streams
              getIt.registerSingleton(state.globalStreams);

              logger.i('user logged in');
              if (state.user.isPhoneVerified) {
                //showSnackBar(context, 'Welcome ${state.user.name}');
                _navigator.pushNamedAndRemoveUntil(
                  '/home',
                  (route) => false,
                  arguments: state.user,
                );
              } else {
                showSnackBar(context, 'Verify your phone to continue');
                _navigator.pushNamedAndRemoveUntil(
                    '/enterPhone', (route) => false);
              }
            } else if (state is DalalLoggedOut) {
              // Unregister everything
              getIt.reset();

              if (!state.fromSplash) {
                // Show msg only when coming from a page other than splash
                logger.i('user logged out');
                showSnackBar(context, 'User Logged Out');
              }
              _navigator.pushNamedAndRemoveUntil('/landing', (route) => false);
            } else if (state is DalalLoginFailed) {
              // TODO: add retry button
              showSnackBar(context, failedToReachServer);
            }
          },
          child: child,
        ),
        // Routing
        initialRoute: '/splash',
        onGenerateRoute: RouteGenerator.generateRoute,
      );
}
