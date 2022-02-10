import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class TertiaryButton extends StatelessWidget {
  final double height, width, fontSize;
  final VoidCallback? onPressed;
  final String title;
  final Color color;

  const TertiaryButton(
      {Key? key,
      this.height = 40,
      this.width = 100,
      this.color = primaryColor,
      this.onPressed,
      this.fontSize = 14,
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
              color: color.withOpacity(0.12),
            ),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize),
              ),
            )));
  }
}
