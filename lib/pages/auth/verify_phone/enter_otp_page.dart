import 'package:dalal_street_client/blocs/auth/verify_phone/enter_otp/enter_otp_cubit.dart';
import 'package:dalal_street_client/components/fill_max_height_scroll_view.dart';
import 'package:dalal_street_client/theme/theme.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterOtpPage extends StatefulWidget {
  const EnterOtpPage({Key? key}) : super(key: key);

  @override
  _EnterOtpPageState createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpPage> {
  late String _otp;

  @override
  Widget build(context) => Scaffold(
        body: SafeArea(
          child: BlocConsumer<EnterOtpCubit, OtpState>(
            listener: (context, state) {
              if (state is OtpFailure) {
                showSnackBar(context, state.msg);
              } else if (state is OtpResent) {
                showSnackBar(context, 'Otp resent succesfully');
              } else if (state is OtpSuccess) {
                showSnackBar(context, 'Phone Verified');
              }
            },
            builder: (context, state) {
              if (state is OtpInitial) {
                return buildContent(state.phone);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      );

  Widget buildContent(String phone) => FillMaxHeightScrollView(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildHeader(phone),
              buildForm(phone),
            ],
          ),
        ),
      );

  Widget buildHeader(String phone) => Column(
        children: [
          Text(
            'Verify Phone Number',
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.topLeft,
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyText1,
                children: [
                  const TextSpan(text: 'We have sent a verification code to\n'),
                  TextSpan(
                    text: phone,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget buildForm(String phone) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: PinCodeTextField(
              appContext: context,
              length: 4,
              keyboardType: TextInputType.number,
              onChanged: (s) => _otp = s,
              textStyle: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              pinTheme: pinTextFieldTheme,
            ),
          ),
          GestureDetector(
            onTap: () => _onResendOTPClick(phone),
            child: Align(
              child: Text(
                "Didn't recieve OTP?",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              alignment: Alignment.centerRight,
            ),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _onVerifyOTPClick(phone),
              child: const Text('Verify OTP'),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _onChangeNumberClick,
              child: const Text('Change Phone Number'),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _onLogoutClick,
              child: const Text('Log Out'),
            ),
          ),
        ],
      );

  void _onResendOTPClick(String phone) {
    context.read<EnterOtpCubit>().resendOTP();
  }

  void _onVerifyOTPClick(String phone) {
    // TODO: form validation
    context.read<EnterOtpCubit>().verifyOTP(int.parse(_otp), phone);
  }

  void _onChangeNumberClick() => Navigator.of(context)
      .pushNamedAndRemoveUntil('/enterPhone', (route) => false);

  void _onLogoutClick() => context.read<EnterOtpCubit>().logout();
}
