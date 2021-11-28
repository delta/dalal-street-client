import 'package:flutter/material.dart';

// TODO: Integrate in Auth flow
class CheckMailPage extends StatelessWidget {
  final String mail;

  const CheckMailPage({Key? key, this.mail = 'johndoe@gmail.com'})
      : super(key: key);

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
        children: [
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Check Your\nEmail',
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.start,
            ),
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

  void onLoginClick(BuildContext context) =>
      Navigator.of(context).pushNamed('/login');
}
