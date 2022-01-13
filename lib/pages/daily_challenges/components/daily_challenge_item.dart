import 'package:dalal_street_client/blocs/daily_challenges/challenge_reward.dart/challenge_reward_cubit.dart';
import 'package:dalal_street_client/pages/daily_challenges/components/challenge_progress.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/pages/daily_challenges/components/challenge_reward.dart';
import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/proto_build/models/UserState.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/challenge_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyChallengeItem extends StatelessWidget {
  final int marketDay;

  final DailyChallenge challenge;
  final UserState userState;
  final Stock? stock;

  DailyChallengeItem({
    Key? key,
    required this.marketDay,
    required this.challenge,
    required this.userState,
    required this.stock,
  }) : super(key: key);

  final userInfoStream = getIt<GlobalStreams>().dynamicUserInfoStream;

  int get initialProgress =>
      challenge.progress(userInfoStream.value, userState);

  Stream<int> get progressStream => userInfoStream
      .map((userInfo) => challenge.progress(userInfo, userState))
      // userInfoStream might change because of lot of factors. Not all of them might lead to a change in progress
      // so only take unique changes
      .distinct();

  @override
  build(context) => Card(
        color: baseColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(challenge.title),
                    const SizedBox(height: 10),
                    Text(
                      challenge.description(stock),
                      style: const TextStyle(color: silver),
                    ),
                    const SizedBox(height: 25),
                    _challengeProgress(),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: BlocProvider(
                  create: (_) => ChallengeRewardCubit(
                    challenge,
                    userState,
                  ),
                  child: ChallengeReward(
                    userState: userState,
                    challenge: challenge,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  // TODO: add progress bar
  // TODO: animate between changes in userInfoStream
  Widget _challengeProgress() {
    if (challenge.marketDay != marketDay) {
      return ChallengeProgress(
        progress: (userState.finalValue - userState.initialValue).toInt(),
        targetValue: challenge.value.toInt(),
      );
    }
    // Update progress from stream only for challenges of current day
    return StreamBuilder<int>(
      stream: progressStream,
      initialData: initialProgress,
      builder: (_, snapshot) => ChallengeProgress(
        progress: snapshot.data!,
        targetValue: challenge.value.toInt(),
      ),
    );
  }
}
