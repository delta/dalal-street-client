import 'package:dalal_street_client/blocs/daily_challenges/single_day_challenges_cubit.dart';
import 'package:dalal_street_client/pages/daily_challenges/daily_challenge_item.dart';
import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleDayChallenges extends StatelessWidget {
  final int day;

  const SingleDayChallenges({Key? key, required this.day}) : super(key: key);

  @override
  build(context) => BlocConsumer<SingleDayChallengesCubit, SingleDayChallengesState>(
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
        child: ListView.separated(
          itemCount: challenges.length,
          itemBuilder: (_, i) => DailyChallengeItem(challenge: challenges[i]),
          separatorBuilder: (_, __) => const SizedBox(height: 16),
        ),
      );
}
