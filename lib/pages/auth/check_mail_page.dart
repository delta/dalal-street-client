import 'package:dalal_street_client/blocs/resend_mail/resend_mail_cubit.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/theme/buttons.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CheckMailPage extends StatelessWidget {
  final String mail;

  const CheckMailPage({Key? key, required this.mail}) : super(key: key);

  @override
  Widget build(context) => BlocListener<ResendMailCubit, ResendMailState>(
        listener: (context, state) {
          if (state is ResendMailSuccess) {
            showSnackBar(context, state.msg, type: SnackBarType.success);
          } else if (state is ResendMailFailure) {
            showSnackBar(context, state.msg, type: SnackBarType.error);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: (() {
              var screenwidth = MediaQuery.of(context).size.width;

              if (screenwidth > 1000) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: secondaryColor, width: 2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: body(context),
                  margin: EdgeInsets.fromLTRB(
                      screenwidth * 0.35,
                      screenwidth * 0.03,
                      screenwidth * 0.35,
                      screenwidth * 0.1),
                );
              }
              return body(context);
            }()),
          ),
        ),
      );

  Padding body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildHeader(context),
          SizedBox(
            child: Image.asset('assets/images/Mail.png'),
          ),
          buildFooter(context),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Text(
            'Check Your Email',
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headline6,
              children: [
                const TextSpan(text: 'We have sent a verification email to '),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () => onLoginClick(context),
                  child: const Text('Log In'),
                ),
              ),
              const SizedBox(width: 20),
              BlocBuilder<ResendMailCubit, ResendMailState>(
                builder: (context, state) {
                  return Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: secondaryButtonStyle,
                      onPressed: state is! ResendMailLoading
                          ? () => resendMail(context)
                          : null,
                      child: const Text('Resend mail'),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 50),
          const Text('Didn’t recieve the email? Check the spam folder'),
          const SizedBox(height: 20),
        ],
      );

  void onLoginClick(BuildContext context) => context.push('/login');

  void resendMail(BuildContext context) =>
      {context.read<ResendMailCubit>().resendVerificationLink(mail)};
}
