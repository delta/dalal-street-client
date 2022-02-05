import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget marketStatusTile(String icon, String name, String value, bool isRed, bool isWeb) {
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
              style:  TextStyle(
                fontSize: isWeb ? 18 : 16,
                fontWeight: FontWeight.w500,
                color: isWeb ? lightGray : white
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        Text(
          '₹ ' + value,
          style: TextStyle(
              fontSize: isWeb ? 18 : 16,
              fontWeight: FontWeight.w500,
              color: !isRed ? primaryColor : heartRed),
          textAlign: TextAlign.start,
        ),
      ],
    ),
  );
}
