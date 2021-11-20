import 'package:dalal_street_client/blocs/auth/verify_phone/verify_phone_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPhonePage extends StatefulWidget {
  const VerifyPhonePage({Key? key}) : super(key: key);

  @override
  State<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  final _codeCont = TextEditingController();
  final _numCont = TextEditingController();

  late String _otp;

  @override
  void initState() {
    super.initState();
    _codeCont.text = '91';
  }

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
          child: BlocConsumer<VerifyPhoneCubit, VerifyPhoneState>(
            listener: (context, state) {
              if (state is VerifyPhoneFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.msg)));
              } else if (state is VerifyPhoneSuccess) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                      const SnackBar(content: Text('Phone Verified')));
              }
            },
            builder: (context, state) {
              if (state is EnteringPhone) {
                return Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _buildNumberForm(),
                    )
                  ],
                );
              } else if (state is EnteringOTP) {
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

  void _onLogoutClicked() => context.read<VerifyPhoneCubit>().logout();

  // Enter Number part
  // ignore: unused_element
  Widget _buildNumberForm() => Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Phone Number',
                style: Theme.of(context).textTheme.headline6,
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
                        child: TextField(
                          controller: _codeCont,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 8,
                        child: TextField(
                          controller: _numCont,
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
              ElevatedButton(
                onPressed: _onSendOTPClick,
                child: const Text('Send OTP'),
              ),
            ],
          ),
        ),
      );

  void _onSendOTPClick() {
    // TODO: form validation
    context
        .read<VerifyPhoneCubit>()
        .sendOTP('+${_codeCont.text}${_numCont.text}');
  }

  // Enter OTP part
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
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      children: [
                        ElevatedButton(
                          onPressed: _onResendOTPClick,
                          child: const Text('Resend in 00:29'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Wrap(
                      children: [
                        ElevatedButton(
                          onPressed: () => _onVerifyOTPClick(phone),
                          child: const Text('Verify'),
                        ),
                      ],
                    ),
                  ],
                ),
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
    context.read<VerifyPhoneCubit>().verifyOTP(int.parse(_otp), phone);
  }

  @override
  void dispose() {
    _codeCont.dispose();
    _numCont.dispose();
    super.dispose();
  }
}
