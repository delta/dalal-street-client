import 'package:dalal_street_client/blocs/dalal/dalal_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<DalalBloc>().add(const CheckUser());
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
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 80),
              BlocBuilder<DalalBloc, DalalState>(
                builder: (context, state) {
                  if (state is DalalLoginFailed) {
                    return retry(state.sessionId);
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      );

  Widget retry(String sessionId) => Column(
        children: [
          const Text('Failed to reach server'),
          const SizedBox(height: 20),
          SizedBox(
            width: 100,
            height: 50,
            child: OutlinedButton(
              onPressed: () => onRetryClick(sessionId),
              child: const Text('Retry'),
            ),
          ),
        ],
      );

  void onRetryClick(String sessionId) =>
      context.read<DalalBloc>().add(GetUserData(sessionId));
}
