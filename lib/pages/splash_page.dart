import 'package:dalal_street_client/blocs/dalal/dalal_bloc.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/constants/app_info.dart';
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
              Image.asset(
                'assets/images/army_bull.png',
                height: 300,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  appTitle,
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 30),
                Text(
                  appDesc,
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ]),
              const SizedBox(height: 40),
              BlocBuilder<DalalBloc, DalalState>(
                builder: (context, state) {
                  if (state is DalalLoginFailed) {
                    return retry(state.sessionId);
                  }
                  return const DalalLoadingBar();
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
