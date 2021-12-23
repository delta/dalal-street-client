import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:dalal_street_client/config.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/navigation/route_generator.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/theme.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

/// Logging
final Logger logger = Logger();

/// ## Dependency Injection
///
/// ### Registering objects
/// #### Register objects to then read them from anywhere in the project
/// ```dart
/// // Most of the time getIt can differentiate between objects from thier Type
/// getIt.registerSingleton<String>(sessionId);
/// // Or like this, as type can be inferred in dart
/// getIt.registerSingleton(sessionId);
///
/// // But if you have multiple objects of same type, then mention a name
/// getIt.registerSingleton(sessionId);
/// getIt.registerSingleton(someOtherString, instanceName: 'String 2');
/// ```
///
/// ### Reading objects
/// #### Warning: Trying to read unregistered objects will throw exception
/// ```dart
/// final sessionId = getIt<String>();
/// // or
/// final String sessionId = getIt();
/// // reading objects registered with a name
/// final String string2 = getIt(instanceName: 'String 2');
/// ```
///
/// ### Unregistering objects
/// ```dart
/// // Unregister objects with thier type
/// getIt.unregister<String>();
/// getIt.unregister<User>();
/// // Can unregister with names
/// getIt.unregister(instanceName: 'String 2');
/// ```
///
/// For more complex usecases checkout [get_it](https://pub.dev/packages/get_it)
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

// TODO: add proper validationMessages in all ReactiveForms
// TODO: add metadata in all forms to facilitate Autfofill
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
        builder: (context, child) => BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserDataLoaded) {
              // Register sessionId
              getIt.registerSingleton(state.sessionId);
              // Register stockList
              getIt.registerSingleton(state.stockList);

              logger.i('user logged in');
              if (state.user.isPhoneVerified) {
                //showSnackBar(context, 'Welcome ${state.user.name}');
                _navigator.pushNamedAndRemoveUntil(
                  '/dailyChallenges',
                  (route) => false,
                  // arguments: state.user,
                );
              } else {
                showSnackBar(context, 'Verify your phone to continue');
                _navigator.pushNamedAndRemoveUntil(
                    '/enterPhone', (route) => false);
              }
            } else if (state is UserLoggedOut) {
              if (!state.fromSplash) {
                // Unregister sessionId
                getIt.unregister<String>();
                // Unregister stockList
                getIt.unregister<Map<int, Stock>>();

                // Show msg only when comming from a page other than splash
                logger.i('user logged out');
                showSnackBar(context, 'User Logged Out');
              }
              _navigator.pushNamedAndRemoveUntil('/landing', (route) => false);
            } else if (state is StockDataFailed) {
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
