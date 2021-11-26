import 'package:dalal_street_client/theme/buttons.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Main app theme
final appTheme = ThemeData(
  colorScheme: colorScheme,
  scaffoldBackgroundColor: backgroundColor,
  textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
  textButtonTheme: TextButtonThemeData(style: textButtonStyle),
);
