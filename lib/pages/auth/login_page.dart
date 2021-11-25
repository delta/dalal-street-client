import 'package:dalal_street_client/blocs/auth/login/login_cubit.dart';
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

  // TODO: add proper validationMessages in all ReactiveForms
  @override
  Widget build(context) => BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            showSnackBar(context, state.msg);
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Log In'),
          ),
          body: (() {
            if (state is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildForm(context);
          })(),
        ),
      );

  Widget _buildForm(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: ReactiveForm(
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
                ReactiveTextField(
                  formControlName: 'password',
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.password),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _onForgotPasswordClick,
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _onLoginClicked(context),
                    child: const Text('Log In'),
                  ),
                ),
                const SizedBox(height: 20),
                buildFooter(context),
              ],
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
              const TextSpan(text: "Dont't have an account? "),
              TextSpan(
                text: 'Sign Up',
                style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _onSignUpClicked(context),
              ),
            ],
          ),
        ),
      );

  void _onForgotPasswordClick() {}

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
