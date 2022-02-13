import 'package:dalal_street_client/blocs/dalal/dalal_bloc.dart';
import 'package:dalal_street_client/config/config.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
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

  // Read GrpcConfig from config.json and initialise ActionClient, StreamClient
  await readConfig();
  await initClients();

  // Provide storage directory for persisting the HydratedBloc state
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  // Initialize HydratedBloc storage
  HydratedBlocOverrides.runZoned(
    // Start the app
    () => runApp(
      // Provide DalalBloc at the root of the App
      BlocProvider(
        create: (_) => DalalBloc(),
        child: DalalApp(),
      ),
    ),
    storage: storage,
  );
}

// TODO: show something in UI whenever isMarketOpen changes
// TODO: add proper validationMessages in all ReactiveForms
// TODO: add metadata in all forms to facilitate Autofill
// TODO: do that thing where if we hit enter while filling a form the focus will shift to the next textfield, and submits the form on hitting enter in the last field. Don't know what it's called
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
        builder: (context, Widget? child) =>
            BlocListener<DalalBloc, DalalState>(
          listener: (context, state) {
            if (state is DalalDataLoaded) {
              // Register sessionId
              getIt.registerSingleton(state.sessionId);
              // Register Global Streams
              getIt.registerSingleton(state.globalStreams);

              logger.i('user logged in');

              _navigator.pushNamedAndRemoveUntil(
                '/home',
                (route) => false,
                arguments: state.user,
              );
            } else if (state is DalalVerificationPending) {
              // Register sessionId
              getIt.registerSingleton(state.sessionId);

              showSnackBar(context, 'Verify your phone to continue',
                  type: SnackBarType.warning);
              _navigator.pushNamedAndRemoveUntil(
                  '/enterPhone', (route) => false);
            } else if (state is DalalLoggedOut) {
              // Unregister everything
              getIt.reset();

              if (!state.fromSplash) {
                // Show msg only when coming from a page other than splash
                logger.i('user logged out');
                showSnackBar(context, 'User Logged Out',
                    type: SnackBarType.success);
              }
              _navigator.pushNamedAndRemoveUntil('/landing', (route) => false);
            } else if (state is DalalLoginFailed) {
              // Handled in SplashPage
            }
          },
          child: child,
        ),
        // Routing
        initialRoute: '/splash',
        onGenerateRoute: RouteGenerator.generateRoute,
      );
}
