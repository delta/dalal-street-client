import 'package:flutter/material.dart';

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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: _buildForm(),
          ),
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
