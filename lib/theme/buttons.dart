import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

const buttonMinSize = Size(150, 50);
const buttonTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);
final buttonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
);

final primaryButtonStyle = ElevatedButton.styleFrom(
  onPrimary: baseColor,
  textStyle: buttonTextStyle,
  minimumSize: buttonMinSize,
  elevation: 0,
  shape: buttonShape,
);

final secondaryButtonStyle = ElevatedButton.styleFrom(
  primary: baseColor,
  onPrimary: Colors.white,
  textStyle: buttonTextStyle,
  minimumSize: buttonMinSize,
  elevation: 0,
  shape: buttonShape,
);

final textButtonStyle = TextButton.styleFrom(
  textStyle: buttonTextStyle,
  minimumSize: buttonMinSize,
  shape: buttonShape,
);

final outlinedButtonStyle = OutlinedButton.styleFrom(
  textStyle: buttonTextStyle,
  minimumSize: buttonMinSize,
  elevation: 0,
  shape: buttonShape,
  side: const BorderSide(color: primaryColor, width: 2),
);
