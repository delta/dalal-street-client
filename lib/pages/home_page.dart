import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(context) => Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Current User: ${user.name}',
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
      );

  void _onLogoutClick(BuildContext context) =>
      context.read<UserBloc>().add(const UserLogOut());
}
