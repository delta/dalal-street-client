import 'package:dalal_street_client/blocs/auth/verify_phone/enter_phone/enter_phone_cubit.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterPhonePage extends StatefulWidget {
  const EnterPhonePage({Key? key}) : super(key: key);

  @override
  _EnterPhonePageState createState() => _EnterPhonePageState();
}

class _EnterPhonePageState extends State<EnterPhonePage> {
  final _codeCont = TextEditingController();
  final _numCont = TextEditingController();

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
                      child: _buildForm(),
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

  void _onLogoutClicked() => context.read<EnterPhoneCubit>().logout();

  Widget _buildForm() => Card(
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
        .read<EnterPhoneCubit>()
        .sendOTP('+${_codeCont.text}${_numCont.text}');
  }

  @override
  void dispose() {
    _codeCont.dispose();
    _numCont.dispose();
    super.dispose();
  }
}
