import 'package:dalal_street_client/blocs/daily_challenges/daily_challenges_cubit.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/pages/daily_challenges/daily_challenge_item.dart';
import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
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
                style: Theme.of(context).textTheme.headline4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Expanded(
                      flex: 1,
                      child: Text(
                        'Rewards',
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                      flex: 2,
                      child: Text(
                        'Challenges',
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(
                        'Progress',
                        textAlign: TextAlign.center,
                      )),
                ],
              ),
              buildBody(),
            ],
          ),
        ),
      );

  Widget buildBody() =>
      BlocConsumer<DailyChallengesCubit, DailyChallengesState>(
        listener: (context, state) {
          if (state is DailyChallengesFailure) {
            showSnackBar(context, state.msg);
          }
        },
        builder: (context, state) {
          if (state is DailyChallengesLoaded) {
            return buildList(state.challenges);
          }
          return const CircularProgressIndicator();
        },
      );

  Widget buildList(List<DailyChallenge> challenges) => Expanded(
        child: ListView.builder(
          itemCount: challenges.length,
          itemBuilder: (_, i) => DailyChallengeItem(
            challenge: challenges[i],
          ),
        ),
      );
}
