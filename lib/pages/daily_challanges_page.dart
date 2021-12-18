import 'package:dalal_street_client/blocs/daily_challenges/daily_challenges_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyChallengesPage extends StatelessWidget {
  const DailyChallengesPage({Key? key}) : super(key: key);

  @override
  build(context) => Scaffold(
        appBar: AppBar(
          title: const Text('Daily Challenges'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                'Daily Challenges',
                style: Theme.of(context).textTheme.headline3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text('Rewards'),
                  Text('Challenges'),
                  Text('Progress'),
                ],
              ),
              buildBody(),
            ],
          ),
        ),
      );

  Widget buildBody() => BlocBuilder<DailyChallengesCubit, DailyChallengesState>(
        builder: (context, state) {
          if (state is DailyChallengesLoaded) {
            return const Text('Loaded');
          }
          return const CircularProgressIndicator();
        },
      );
}
