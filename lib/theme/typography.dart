import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

final appTextTheme = ThemeData.dark().textTheme.copyWith(
      headline1: const TextStyle(
        fontSize: 50,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headline4: const TextStyle(
        fontSize: 36,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headline5: const TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headline6: const TextStyle(
        fontSize: 18,
        color: lightGray,
      ),
      subtitle1: const TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
      subtitle2: const TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
      bodyText1: const TextStyle(
        fontSize: 13,
        color: lightGray,
      ),
      caption: const TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    );
