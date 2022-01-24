import 'package:dalal_street_client/blocs/auth/forgot_password/forgot_password_cubit.dart';
import 'package:dalal_street_client/components/dalal_back_button.dart';
import 'package:dalal_street_client/components/fill_max_height_scroll_view.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  final formGroup = FormGroup({
    'email': FormControl(validators: [Validators.required, Validators.email])
  });

  @override
  build(context) => Scaffold(
        body: SafeArea(
          child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordFailure) {
                showSnackBar(context, state.msg);
              } else if (state is ForgotPasswordSuccess) {
                Navigator.maybePop(context);
                showSnackBar(context,
                    'A temporary password and Password reset link have been sent to your registered Email Id');
              }
            },
            builder: (context, state) {
              if (state is ForgotPasswordLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return body();
            },
          ),
        ),
      );

  Widget body() => FillMaxHeightScrollView(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              header(context),
              const SizedBox(height: 150),
              form(context),
            ],
          ),
        ),
      );

  Widget header(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DalalBackButton(),
          const SizedBox(height: 20),
          Text(
            'Forgot Password',
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(height: 5),
          Text(
            'Enter your email to reset password',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      );

  Widget form(BuildContext context) => SizedBox(
        width: 320,
        child: ReactiveForm(
          formGroup: formGroup,
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
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onResetClick(context),
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ),
      );

  void onResetClick(BuildContext context) {
    if (formGroup.valid) {
      context
          .read<ForgotPasswordCubit>()
          .forgotPassword(formGroup.control('email').value);
    } else {
      formGroup.markAllAsTouched();
    }
  }
}
