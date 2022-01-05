import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

Container news() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      'Recent News',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: white.withOpacity(0.75),
      ),
      textAlign: TextAlign.start,
    ),
  );
}
