import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget marketStatusTile(String icon, String name, String value, bool isRed) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          spacing: 14,
          children: [
            SvgPicture.asset(
              icon,
              width: 18,
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: white,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        Text(
          '₹ ' + value,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: !isRed ? primaryColor : heartRed),
          textAlign: TextAlign.start,
        ),
      ],
    ),
  );
}
