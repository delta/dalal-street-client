import 'package:dalal_street_client/blocs/auth/register/register_cubit.dart';
import 'package:dalal_street_client/components/dalal_back_button.dart';
import 'package:dalal_street_client/components/fill_max_height_scroll_view.dart';
import 'package:dalal_street_client/components/reactive_password_field.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:dalal_street_client/utils/tooltip.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final form = FormGroup(
    {
      'name': FormControl(validators: [Validators.required]),
      'email': FormControl(validators: [Validators.required, Validators.email]),
      'password': FormControl(validators: [
        Validators.required,
        Validators.minLength(6),
      ]),
      'confirmPassword': FormControl(validators: [Validators.required]),
      'referralCode': FormControl(),
    },
    validators: [Validators.mustMatch('password', 'confirmPassword')],
  );

  @override
  Widget build(context) => Scaffold(
        body: SafeArea(
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/checkMail',
                  (route) => false,
                  arguments: state.mail,
                );
              } else if (state is RegisterFailure) {
                showSnackBar(context, state.msg);
              }
            },
            builder: (context, state) {
              if (state is RegisterLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return buildBody();
              }
            },
          ),
        ),
      );

  Widget buildBody() => FillMaxHeightScrollView(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildHeader(context),
              buildForm(context),
              buildFooter(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DalalBackButton(),
            const SizedBox(height: 18),
            Text(
              'Create An Account',
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
      );

  Widget buildForm(BuildContext context) => ReactiveForm(
        formGroup: form,
        child: Column(
          children: [
            ReactiveTextField(
              formControlName: 'name',
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outlined),
              ),
            ),
            const SizedBox(height: 20),
            ReactiveTextField(
              formControlName: 'email',
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail_outline),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            const ReactivePasswordField(formControlName: 'password'),
            const SizedBox(height: 20),
            const ReactivePasswordField(
              formControlName: 'confirmPassword',
              label: 'Confirm Password',
            ),
            const SizedBox(height: 20),
            ReactiveTextField(
              formControlName: 'referralCode',
              // TODO: prefixIcon
              decoration: InputDecoration(
                labelText: 'Referral Code',
                suffixIcon: Builder(
                  builder: (context) => IconButton(
                    onPressed: () => showTooltip(
                        context, 'Enter referral code to get cash reward'),
                    icon: const Icon(Icons.info_outline),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () => _onRegisterClick(context),
                child: const Text('Sign Up'),
              ),
            ),
          ],
        ),
      );

  Widget buildFooter(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 15),
            children: [
              const TextSpan(text: 'Already have an account? '),
              TextSpan(
                text: 'Sign In',
                style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _onSigninClicked(context),
              ),
            ],
          ),
        ),
      );

  void _onRegisterClick(BuildContext context) {
    if (form.valid) {
      context.read<RegisterCubit>().register(
            form.control('email').value,
            form.control('password').value,
            form.control('name').value,
            referralCode: form.control('referralCode').value,
          );
    } else {
      form.markAllAsTouched();
    }
  }

  _onSigninClicked(BuildContext context) =>
      Navigator.of(context).pushNamed('/login');
}
