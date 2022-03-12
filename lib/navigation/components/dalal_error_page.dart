import 'package:dalal_street_client/constants/images.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DalalErrorPage extends StatelessWidget {
  final GoRouterState routerState;

  const DalalErrorPage({Key? key, required this.routerState}) : super(key: key);

  @override
  build(context) => Container(
        color: backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.error),
              const SizedBox(height: 20),
              Text(
                'Oops!  Mr dalal has lost its way. Return back to home',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: primaryColor),
              ),
            ],
          ),
        ),
      );
}
