import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class TertiaryButton extends StatelessWidget {
  final double height, width;
  final VoidCallback? onPressed;
  final String title;

  const TertiaryButton(
      {Key? key,
      this.height = 40,
      this.width = 100,
      this.onPressed,
      this.title = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
              color: primaryColor.withOpacity(0.2),
            ),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            )));
  }
}
