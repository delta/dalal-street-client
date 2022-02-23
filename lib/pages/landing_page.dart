import 'package:dalal_street_client/constants/app_info.dart';
import 'package:dalal_street_client/constants/urls.dart';
import 'package:dalal_street_client/theme/buttons.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(context) => Scaffold(
        bottomNavigationBar: buildFooter(context),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/images/army_bull.png',
                    height: 300,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appTitle,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        appDesc,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () => onRegisterClick(context),
                          child: const Text('Register'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          style: secondaryButtonStyle,
                          onPressed: () => onLoginClick(context),
                          child: const Text('Log In'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Widget buildFooter(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 15),
            children: [
              const TextSpan(text: 'Made with '),
              TextSpan(
                text: '♥',
                style: Theme.of(context).textTheme.caption?.copyWith(
                      fontSize: 15,
                      color: heartRed,
                    ),
                recognizer: TapGestureRecognizer()..onTap = onHeartClick,
              ),
              const TextSpan(text: ' by '),
              TextSpan(
                text: 'Delta',
                style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                recognizer: TapGestureRecognizer()..onTap = onDeltaClick,
              ),
            ],
          ),
        ),
      );

  void onRegisterClick(BuildContext context) => context.push('/register');

  void onLoginClick(BuildContext context) => context.push('/login');

  void onHeartClick() => launch(helikopterHelikopter);

  void onDeltaClick() => launch(deltaUrl);
}
