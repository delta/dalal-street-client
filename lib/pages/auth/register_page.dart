import 'package:dalal_street_client/blocs/auth/register/register_cubit.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
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
      'confirmPassword': FormControl(),
      'referralCode': FormControl(),
    },
    validators: [Validators.mustMatch('password', 'confirmPassword')],
  );

  @override
  Widget build(context) => Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              showSnackBar(context,
                  'Registraion successful. Please check your inbox to verify email');
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            } else if (state is RegisterFailure) {
              showSnackBar(context, state.msg);
            }
          },
          builder: (context, state) {
            if (state is RegisterLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: _buildForm(context),
                ),
              );
            }
          },
        ),
      );

  Widget _buildForm(BuildContext context) => ReactiveForm(
        formGroup: form,
        child: Column(
          children: [
            ReactiveTextField(
              formControlName: 'name',
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            ReactiveTextField(
              formControlName: 'email',
              decoration: const InputDecoration(labelText: 'Email Address'),
              keyboardType: TextInputType.emailAddress,
            ),
            ReactiveTextField(
              formControlName: 'password',
              decoration: const InputDecoration(labelText: 'Password'),
              keyboardType: TextInputType.visiblePassword,
            ),
            ReactiveTextField(
              formControlName: 'confirmPassword',
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              keyboardType: TextInputType.visiblePassword,
            ),
            ReactiveTextField(
              formControlName: 'referralCode',
              decoration: const InputDecoration(labelText: 'Referral Code'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _onRegisterClick(context),
                child: const Text('Register'),
              ),
            ),
          ],
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
}
