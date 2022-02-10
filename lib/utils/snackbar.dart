import 'package:dalal_street_client/models/snackbar_props.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

enum SnackBarType { success, error, info, warning }

/// Hides the current snackbar(if any) and shows new snackbar with [msg]
void showSnackBar(BuildContext context, String msg,
    {SnackBarType type = SnackBarType.info}) {
  var snackBarProps = getSnackBarProps(type);

  Flushbar(
    title: snackBarProps.title,
    titleColor: snackBarProps.color,
    message: msg,
    icon: Icon(
      snackBarProps.icon,
      color: snackBarProps.color,
      size: 28,
    ),
    leftBarIndicatorColor: snackBarProps.color,
    duration: const Duration(seconds: 5),
    borderRadius: BorderRadius.circular(12),
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: background2,
    isDismissible: true,
    maxWidth: 400,
    padding: const EdgeInsets.all(10.0),
    margin: const EdgeInsets.all(8.0),
  ).show(context);
}

SnackBarProps getSnackBarProps(SnackBarType type) {
  late SnackBarProps snackBarProps;

  switch (type) {
    case SnackBarType.success:
      snackBarProps =
          SnackBarProps('Success', primaryColor, Icons.check_circle);

      break;
    case SnackBarType.info:
      snackBarProps = SnackBarProps('Info', blue, Icons.info_outline);
      break;
    case SnackBarType.error:
      snackBarProps = SnackBarProps('Error', red, Icons.error_outline);
      break;
    case SnackBarType.warning:
      snackBarProps = SnackBarProps('Warning', gold, Icons.warning);
      break;
  }

  return snackBarProps;
}
