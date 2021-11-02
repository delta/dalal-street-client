import 'package:dalal_street_client/config.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await readConfig();
  await initClients();
  runApp(const DalalApp());
}

class DalalApp extends StatelessWidget {
  const DalalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Dalal Street 2021',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)),
        home: const Scaffold(
          backgroundColor: UiColors.primary,
          body: Center(
            child: Text(
              'Dalal to the moon 🥳',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      );
}
