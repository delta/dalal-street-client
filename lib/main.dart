import 'package:dalal_street_client/blocs/dalal/dalal_bloc.dart';
import 'package:dalal_street_client/config/config.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/navigation/nav_utils.dart';
import 'package:dalal_street_client/navigation/router.dart';
import 'package:dalal_street_client/theme/theme.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // Something doesnt work without this line. Dont remember what
  WidgetsFlutterBinding.ensureInitialized();

  // Remove # from web urls
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

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
  const DalalApp({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    final router = generateRouter(context);
    return MaterialApp.router(
      title: 'Dalal Street 2021',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      themeMode: ThemeMode.dark,
      // Routing
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
