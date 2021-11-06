import 'package:dalal_street_client/blocs/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(context) => BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.msg)));
            }
          },
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: const Text('Log In'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: (() {
                if (state is LoginLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _buildForm(context);
              })(),
            ),
          ),
        ),
      );

  Widget _buildForm(BuildContext context) => Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _onLoginClicked(context),
            child: const Text('Log In'),
          ),
        ],
      );

  void _onLoginClicked(BuildContext context) {
    // TODO: Implement Form Validation
    context.read<LoginBloc>().add(LoginRequested(
          _emailController.text,
          _passwordController.text,
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
