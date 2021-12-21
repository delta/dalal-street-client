import 'package:dalal_street_client/blocs/daily_challenges/single_day_challenges_cubit.dart';
import 'package:dalal_street_client/pages/daily_challenges/single_day_challenges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyChallengesPage extends StatelessWidget {
  const DailyChallengesPage({Key? key}) : super(key: key);

  @override
  build(context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(title: const Text('Daily Challenges')),
          body: Center(
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Day 1'),
                    Tab(text: 'Day 2'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Rewards',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Challenges',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Progress',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    children: [
                      BlocProvider(
                        create: (_) => SingleDayChallengesCubit(),
                        child: const SingleDayChallenges(day: 1),
                      ),
                      BlocProvider(
                        create: (_) => SingleDayChallengesCubit(),
                        child: const SingleDayChallenges(day: 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
