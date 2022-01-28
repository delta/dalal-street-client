import 'package:dalal_street_client/blocs/auth/login/login_cubit.dart';
import 'package:dalal_street_client/components/dalal_back_button.dart';
import 'package:dalal_street_client/components/fill_max_height_scroll_view.dart';
import 'package:dalal_street_client/components/reactive_password_field.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final form = FormGroup({
    'email': FormControl(validators: [Validators.required, Validators.email]),
    'password': FormControl(validators: [Validators.required]),
  });

  @override
  Widget build(context) => BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            showSnackBar(context, state.msg);
          }
        },
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: (() {
              if (state is LoginLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return buildBody();
            })(),
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

  Widget buildHeader(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DalalBackButton(),
          const SizedBox(height: 18),
          Text(
            'Login',
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(height: 14),
          Text(
            'Please sign in to continue',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      );

  Widget buildForm(BuildContext context) => ReactiveForm(
        formGroup: form,
        child: Column(
          children: [
            ReactiveTextField(
              formControlName: 'email',
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            const ReactivePasswordField(formControlName: 'password'),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => _onForgotPasswordClick(context),
                child: Text(
                  'Forgot password?',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () => _onLoginClicked(context),
                child: const Text('Log In'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );

  Widget buildFooter(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.caption,
            children: [
              const TextSpan(text: "Don't have an account? "),
              TextSpan(
                text: 'Sign Up',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _onSignUpClicked(context),
              ),
            ],
          ),
        ),
      );

  void _onForgotPasswordClick(BuildContext context) =>
      Navigator.of(context).pushNamed('/forgotPassword');

  void _onLoginClicked(BuildContext context) {
    if (form.valid) {
      context.read<LoginCubit>().login(
            form.control('email').value,
            form.control('password').value,
          );
    } else {
      form.markAllAsTouched();
    }
  }

  void _onSignUpClicked(BuildContext context) =>
      Navigator.of(context).pushNamed('/register');
}
