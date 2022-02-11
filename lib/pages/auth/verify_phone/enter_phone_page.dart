import 'package:dalal_street_client/blocs/auth/verify_phone/enter_phone/enter_phone_cubit.dart';
import 'package:dalal_street_client/constants/app_info.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
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
                  showSnackBar(context, state.msg, type: SnackBarType.error);
                }
              },
              builder: (context, state) {
                if (state is EnterPhoneInitial) {
                  return buildContent(context);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      );

  Widget buildContent(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildHeader(context),
            const SizedBox(height: 50),
            buildForm(context),
          ],
        ),
      );

  Widget buildHeader(BuildContext context) => Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/images/OTP.png',
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Verify Phone Number',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 20),
          Text(
            otpDesc,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      );

  Widget buildForm(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            ReactiveForm(
              formGroup: form,
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
                          const InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () => _onSendOTPClick(context),
                child: const Text('Send OTP'),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 300,
              child: TextButton(
                onPressed: () => _onLogoutClicked(context),
                child: const Text('Log Out'),
              ),
            ),
          ],
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

  void _onLogoutClicked(BuildContext context) =>
      context.read<EnterPhoneCubit>().logout();
}
