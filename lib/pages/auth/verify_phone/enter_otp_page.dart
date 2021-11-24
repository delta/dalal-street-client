import 'package:dalal_street_client/blocs/auth/verify_phone/enter_otp/enter_otp_cubit.dart';
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
          child: Center(
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
                  return Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: _buildOTPForm(state.phone),
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

  void _onLogoutClicked() => context.read<EnterOtpCubit>().logout();

  Widget _buildOTPForm(String phone) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Verify Phone Number',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 10),
            Text('We have sent a verification code to $phone'),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: PinCodeTextField(
                appContext: context,
                length: 4,
                keyboardType: TextInputType.number,
                onChanged: (s) => _otp = s,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _onResendOTPClick(phone),
              child: const Align(
                child: Text("Didn't recieve OTP?"),
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
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil('/enterPhone', (route) => false),
                child: const Text('Change Phone Number'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _onLogoutClicked,
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      );

  void _onResendOTPClick(String phone) {
    // TODO: form validation
    context.read<EnterOtpCubit>().resendOTP();
  }

  void _onVerifyOTPClick(String phone) {
    // TODO: form validation
    context.read<EnterOtpCubit>().verifyOTP(int.parse(_otp), phone);
  }
}
