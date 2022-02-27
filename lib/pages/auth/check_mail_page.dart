import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CheckMailPage extends StatelessWidget {
  final String mail;

  const CheckMailPage({Key? key, required this.mail}) : super(key: key);

  @override
  Widget build(context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildHeader(context),
                SizedBox(
                  width: double.infinity,
                  child: Image.asset('assets/images/Mail.png'),
                ),
                buildFooter(context),
              ],
            ),
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Text(
            'Check Your\nEmail',
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headline6,
              children: [
                const TextSpan(text: 'We have sent a verification email to \n'),
                TextSpan(
                  text: mail,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
        ],
      );

  Widget buildFooter(BuildContext context) => Column(
        children: [
          SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: () => onLoginClick(context),
              child: const Text('Log In'),
            ),
          ),
          const SizedBox(height: 80),
          const Text('Didn’t recieve the email? Check the Spam Folder'),
          const SizedBox(height: 20),
        ],
      );

  void onLoginClick(BuildContext context) => context.push('/login');
}
