import 'package:dalal_street_client/blocs/auth/login/login_cubit.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
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
          appBar: AppBar(
            title: const Text('Log In'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: (() {
              if (state is LoginLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildForm(context);
            })(),
          ),
        ),
      );

  Widget _buildForm(BuildContext context) => ReactiveForm(
        formGroup: form,
        child: Column(
          children: [
            ReactiveTextField(
              formControlName: 'email',
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ReactiveTextField(
              formControlName: 'password',
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _onLoginClicked(context),
              child: const Text('Log In'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => _onSignUpClicked(context),
              child: const Text('Dont have an account? Sign Up.'),
            ),
          ],
        ),
      );

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
