import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final double height, width, fontSize;
  final VoidCallback? onPressed;
  final String title;

  const PrimaryButton(
      {Key? key,
      this.height = 40,
      this.width = 100,
      this.onPressed,
      this.title = '',
      this.fontSize = 14})
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
              color: primaryColor,
            ),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: backgroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize),
              ),
            )));
  }
}
