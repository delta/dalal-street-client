import 'package:dalal_street_client/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const DalalApp());
}

class DalalApp extends StatelessWidget {
  const DalalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dalal Street 2021',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)),
        home: const Scaffold(
          backgroundColor: UiColors.primary,
          body: Center(
            child: Text(
              "Dalal to the moon 🥳",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ));
  }
}
