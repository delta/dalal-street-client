import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.userName}) : super(key: key);

  final String userName;

  @override
  Widget build(context) => BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoggedOut) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('User Logged Out')));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Current User: $userName',
                    style: const TextStyle(fontSize: 24),
                  ),
                  ElevatedButton(
                    onPressed: () => _onLogoutClick(context),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _onLogoutClick(BuildContext context) =>
      context.read<UserBloc>().add(const UserLogOut());
}
