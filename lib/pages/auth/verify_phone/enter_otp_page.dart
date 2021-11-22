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
        appBar: AppBar(
          title: const Text('Verify Phone'),
          actions: [
            IconButton(
              onPressed: _onLogoutClicked,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
          child: BlocConsumer<EnterOtpCubit, EnterOtpState>(
            listener: (context, state) {
              if (state is EnterOtpFailure) {
                showSnackBar(context, state.msg);
              } else if (state is EnterOtpSuccess) {
                showSnackBar(context, 'Phone Verified');
              }
            },
            builder: (context, state) {
              if (state is EnterOtpInitial) {
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
      );

  void _onLogoutClicked() => context.read<EnterOtpCubit>().logout();

  Widget _buildOTPForm(String phone) => Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter OTP',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 20),
              Text(phone),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: PinCodeTextField(
                  keyboardType: TextInputType.number,
                  appContext: context,
                  length: 4,
                  onChanged: (s) => _otp = s,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _onVerifyOTPClick(phone),
                child: const Text('Verify'),
              ),
              OutlinedButton(
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil('/enterPhone', (route) => false),
                child: const Text('Change Phone Number'),
              ),
            ],
          ),
        ),
      );

  void _onResendOTPClick() {
    // TODO: form validation
  }

  void _onVerifyOTPClick(String phone) {
    // TODO: form validation
    context.read<EnterOtpCubit>().verifyOTP(int.parse(_otp), phone);
  }
}
