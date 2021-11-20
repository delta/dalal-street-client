import 'package:dalal_street_client/blocs/auth/register/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameCont = TextEditingController();
  final _emailCont = TextEditingController();
  final _passCont = TextEditingController();
  final _conPassCont = TextEditingController();
  final _referralCont = TextEditingController();

  @override
  Widget build(context) => Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    content: Text(
                        'Registraion successful. Please check your inbox to verify email')));
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.msg)));
            }
          },
          builder: (context, state) {
            if (state is RegisterLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: _buildForm(),
                ),
              );
            }
          },
        ),
      );

  Widget _buildForm() => Column(
        children: [
          TextField(
            controller: _nameCont,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailCont,
            decoration: const InputDecoration(labelText: 'Email Address'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passCont,
            decoration: const InputDecoration(labelText: 'Password'),
            keyboardType: TextInputType.visiblePassword,
          ),
          TextField(
            controller: _conPassCont,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            keyboardType: TextInputType.visiblePassword,
          ),
          TextField(
            controller: _referralCont,
            decoration: const InputDecoration(labelText: 'Referral Code'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onRegisterClick,
              child: const Text('Register'),
            ),
          ),
        ],
      );

  void _onRegisterClick() {
    // TODO: form validation
    context
        .read<RegisterCubit>()
        .register(_emailCont.text, _passCont.text, _nameCont.text);
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _emailCont.dispose();
    _passCont.dispose();
    _conPassCont.dispose();
    _referralCont.dispose();
    super.dispose();
  }
}
