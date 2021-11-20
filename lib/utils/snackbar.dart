import 'package:flutter/material.dart';

/// Hides the current snackbar(if any) and shows new snackbar with [msg]
void showSnackBar(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
