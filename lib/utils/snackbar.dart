import 'package:dalal_street_client/models/snackbar/snackbar_props.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

/// Hides the current snackbar(if any) and shows new snackbar with [msg]
void showSnackBar(BuildContext context, String msg,
    {SnackBarType type = SnackBarType.info}) {
  var snackBarProps = getSnackBarProps(type);
  var screenWidth = MediaQuery.of(context).size.width;
  var isWeb = screenWidth > 1000;

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: baseColor,
      behavior: SnackBarBehavior.floating,
      margin: isWeb
          ? EdgeInsets.fromLTRB(screenWidth * 0.3, 10, screenWidth * 0.3, 10)
          : const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(milliseconds: 1500),
      content: SizedBox(
        child: Wrap(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    snackBarProps.icon,
                    color: snackBarProps.color,
                    size: 28,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snackBarProps.title,
                          style: TextStyle(
                              fontSize: 20,
                              color: snackBarProps.color,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        msg,
                        style: const TextStyle(color: white, fontSize: 16),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      )));
}

SnackBarProps getSnackBarProps(SnackBarType type) {
  switch (type) {
    case SnackBarType.success:
      return SnackBarProps('Success', primaryColor, Icons.check_circle);
    case SnackBarType.info:
      return SnackBarProps('Info', blue, Icons.info_outline);
    case SnackBarType.error:
      return SnackBarProps('Error', red, Icons.error_outline);
    case SnackBarType.warning:
      return SnackBarProps('Warning', gold, Icons.warning);
  }
}
