import 'package:dalal_street_client/blocs/auth/verify_phone/enter_phone/enter_phone_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/constants/app_info.dart';
import 'package:dalal_street_client/navigation/nav_utils.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/form_validation_messages.dart';
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
                  context.webGo(
                    '/enterOtp',
                    extra: state.phone,
                  );
                }
                if (state is EnterPhoneFailure) {
                  showSnackBar(context, state.msg, type: SnackBarType.error);
                }
              },
              builder: (context, state) {
                if (state is EnterPhoneInitial) {
                  var screenwidth = MediaQuery.of(context).size.width;

                  return screenwidth > 1000
                      ? (Center(
                          child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: secondaryColor, width: 2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: buildContent(context),
                          margin: EdgeInsets.fromLTRB(
                              screenwidth * 0.35,
                              screenwidth * 0.03,
                              screenwidth * 0.35,
                              screenwidth * 0.05),
                        )))
                      : buildContent(context);
                } else {
                  return const DalalLoadingBar();
                }
              },
            ),
          ),
        ),
      );

  Widget buildContent(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildHeader(context),
              const SizedBox(height: 50),
              buildForm(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Column(
        children: [
          Image.asset(
            'assets/images/OTP.png',
          ),
          const SizedBox(height: 20),
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
                      validationMessages: (control) =>
                          {ValidationMessage.required: 'Invalid code'},
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
                      validationMessages: (control) => phoneNumberValidation(),
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
