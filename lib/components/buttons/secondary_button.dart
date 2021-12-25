import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final double height, width, fontSize;
  final VoidCallback? onPressed;
  final String title;

  const SecondaryButton(
      {Key? key,
      this.height = 40,
      this.width = 100,
      this.fontSize = 14,
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
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              color: baseColor,
            ),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize),
              ),
            )));
  }
}
