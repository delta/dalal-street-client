import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

const buttonMinSize = Size(150, 50);

final primaryButtonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  onPrimary: baseColor,
  minimumSize: buttonMinSize,
  elevation: 0,
  textStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
);

final secondaryButtonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  primary: baseColor,
  onPrimary: Colors.white,
  minimumSize: buttonMinSize,
  elevation: 0,
  textStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
);
