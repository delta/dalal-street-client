import 'package:dalal_street_client/blocs/daily_challenges/single_day_challenges_cubit.dart';
import 'package:dalal_street_client/pages/daily_challenges/daily_challenge_item.dart';
import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleDayChallenges extends StatefulWidget {
  final int day;

  const SingleDayChallenges({Key? key, required this.day}) : super(key: key);

  @override
  State<SingleDayChallenges> createState() => _SingleDayChallengesState();
}

class _SingleDayChallengesState extends State<SingleDayChallenges>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<SingleDayChallengesCubit>().getChallenges(widget.day);
  }

  @override
  build(context) {
    super.build(context);
    return BlocConsumer<SingleDayChallengesCubit, SingleDayChallengesState>(
      listener: (context, state) {
        if (state is DailyChallengesFailure) {
          showSnackBar(context, state.msg);
        }
      },
      builder: (context, state) {
        if (state is DailyChallengesLoaded) {
          return buildList(state.challenges);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildList(List<DailyChallenge> challenges) => ListView.separated(
        itemCount: challenges.length,
        itemBuilder: (_, i) => DailyChallengeItem(challenge: challenges[i]),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
      );

  // For preserving state between tab view pages: https://stackoverflow.com/questions/49087703/preserving-state-between-tab-view-pages
  @override
  bool get wantKeepAlive => true;
}
