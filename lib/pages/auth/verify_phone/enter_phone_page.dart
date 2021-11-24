import 'package:dalal_street_client/blocs/auth/verify_phone/enter_phone/enter_phone_cubit.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EnterPhonePage extends StatelessWidget {
  EnterPhonePage({Key? key}) : super(key: key);

  final form = FormGroup({
    'code': FormControl(
        value: '91', validators: [Validators.required, Validators.number]),
    'number': FormControl(validators: [
      Validators.required,
      Validators.number,

      /// Source: https://www.oreilly.com/library/view/regular-expressions-cookbook/9781449327453/ch04s03.html
      /// ```
      /// Thanks to the international phone numbering plan (ITU-T E.164), phone numbers cannot contain more than 15 digits. The shortest international phone numbers in use contain seven digits.
      /// ```
      /// 🙃
      Validators.minLength(7),
      Validators.maxLength(15)
    ]),
  });

  @override
  Widget build(context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: BlocConsumer<EnterPhoneCubit, EnterPhoneState>(
              listener: (context, state) {
                if (state is EnterPhoneSuccess) {
                  Navigator.of(context).pushNamed(
                    '/enterOtp',
                    arguments: state.phone,
                  );
                }
                if (state is EnterPhoneFailure) {
                  showSnackBar(context, state.msg);
                }
              },
              builder: (context, state) {
                if (state is EnterPhoneInitial) {
                  return Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: _buildForm(context),
                      )
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      );

  void _onLogoutClicked(BuildContext context) =>
      context.read<EnterPhoneCubit>().logout();

  Widget _buildForm(BuildContext context) => ReactiveForm(
        formGroup: form,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Verify Phone Number',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 20),
              const Text(
                'You will recieve a 4 digit verification code to this number',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ReactiveTextField(
                          formControlName: 'code',
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 8,
                        child: ReactiveTextField(
                          formControlName: 'number',
                          decoration:
                              const InputDecoration(labelText: 'Mobile Number'),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _onSendOTPClick(context),
                  child: const Text('Send OTP'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => _onLogoutClicked(context),
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      );

  void _onSendOTPClick(BuildContext context) {
    if (form.valid) {
      context.read<EnterPhoneCubit>().sendOTP(
          '+${form.control('code').value}${form.control('number').value}');
    } else {
      form.markAllAsTouched();
    }
  }
}
