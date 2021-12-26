import 'package:dalal_street_client/components/dalal_back_button.dart';
import 'package:dalal_street_client/components/fill_max_height_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  final formGroup = FormGroup({
    'email': FormControl(validators: [Validators.required, Validators.email])
  });

  @override
  build(context) => Scaffold(
        body: SafeArea(
          child: FillMaxHeightScrollView(
            builder: (_) => Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  header(),
                  const SizedBox(height: 150),
                  form(),
                ],
              ),
            ),
          ),
        ),
      );

  Widget header() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          DalalBackButton(),
          Text('Forgot Password'),
          Text('Enter your email to reset password'),
        ],
      );

  Widget form() => SizedBox(
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
                  onPressed: onResetClick,
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ),
      );

  void onResetClick() {
    if (formGroup.valid) {
      //
    } else {
      formGroup.markAllAsTouched();
    }
  }
}
