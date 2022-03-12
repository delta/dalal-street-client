import 'package:dalal_street_client/theme/buttons.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  final void Function() onLogoutClick;

  const LogoutDialog({Key? key, required this.onLogoutClick}) : super(key: key);

  @override
  build(context) => Dialog(
        backgroundColor: background2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to logout?',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: white),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: onLogoutClick,
                      child: const Text('Yes'),
                      style: secondaryButtonStyle,
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('No'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
