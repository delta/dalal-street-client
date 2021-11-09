import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(const CheckUser());
  }

  @override
  Widget build(context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Dalal Street',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(color: Colors.blue),
              ),
              const SizedBox(height: 80),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      );
}
