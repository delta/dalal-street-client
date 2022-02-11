import 'package:dalal_street_client/models/snackbar/snackbar_props.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

/// Hides the current snackbar(if any) and shows new snackbar with [msg]
void showSnackBar(BuildContext context, String msg,
    {SnackBarType type = SnackBarType.info}) {
  var snackBarProps = getSnackBarProps(type);

  Flushbar(
    shouldIconPulse: false,
    title: snackBarProps.title,
    titleColor: snackBarProps.color,
    message: msg,
    icon: Icon(
      snackBarProps.icon,
      color: snackBarProps.color,
      size: 28,
    ),
    leftBarIndicatorColor: snackBarProps.color,
    duration: const Duration(seconds: 3),
    borderRadius: BorderRadius.circular(12),
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: background3,
    isDismissible: true,
    maxWidth: 400,
    padding: const EdgeInsets.all(10.0),
    margin: const EdgeInsets.all(8.0),
    flushbarPosition: FlushbarPosition.TOP,
  ).show(context);
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
