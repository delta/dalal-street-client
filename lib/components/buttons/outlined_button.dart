import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class OutLinedButton extends StatelessWidget {
  final double height, width;
  final VoidCallback? onPressed;
  final String title;

  const OutLinedButton(
      {Key? key,
      this.height = 40,
      this.width = 100,
      this.onPressed,
      this.title = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(Size(width, height)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            )),
            overlayColor: MaterialStateProperty.all(secondaryColor),
            backgroundColor: MaterialStateProperty.all(backgroundColor)),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: primaryColor, fontWeight: FontWeight.w500, fontSize: 18),
        ));
  }
}
