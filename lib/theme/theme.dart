import 'package:dalal_street_client/theme/buttons.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

/// Main app theme
final appTheme = ThemeData(
  colorScheme: colorScheme,
  scaffoldBackgroundColor: backgroundColor,
  textTheme: GoogleFonts.interTextTheme(appTextTheme),
  elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
  textButtonTheme: TextButtonThemeData(style: textButtonStyle),
  outlinedButtonTheme: OutlinedButtonThemeData(style: outlinedButtonStyle),
);

// TODO: Fill colors are not showing properly
final pinTextFieldTheme = PinTheme(
  fieldHeight: 70,
  fieldWidth: 60,
  borderWidth: 0,
  activeColor: baseColor,
  inactiveColor: baseColor,
  selectedColor: baseColor,
  activeFillColor: baseColor,
  inactiveFillColor: baseColor,
  selectedFillColor: baseColor,
  shape: PinCodeFieldShape.box,
  borderRadius: BorderRadius.circular(10),
);
