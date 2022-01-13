import 'package:dalal_street_client/blocs/daily_challenges/challenge_reward.dart/challenge_reward_cubit.dart';
import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:dalal_street_client/proto_build/models/UserState.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeReward extends StatelessWidget {
  final UserState userState;
  final DailyChallenge challenge;

  const ChallengeReward({
    Key? key,
    required this.userState,
    required this.challenge,
  }) : super(key: key);

  @override
  build(context) => BlocConsumer<ChallengeRewardCubit, ChallengeRewardState>(
        listener: (context, state) {
          if (state is ChallengeRewardFailure) {
            showSnackBar(context, state.msg);
          } else if (state is ChallengeRewardClaimed) {
            showSnackBar(context, 'Reward of ₹${state.reward} Claimed!');
          }
        },
        builder: (context, state) {
          if (state is ChallengeIncomplete) {
            return challengeIncomplete();
          } else if (state is ChallengeComplete) {
            return challengeComplete(context);
          } else if (state is ChallengeRewardClaimed) {
            return challengeRewardClaimed();
          }
          return const CircularProgressIndicator();
        },
      );

  Widget challengeIncomplete() => Column(
        children: [
          Image.asset('assets/images/ChallengeIncomplete.png'),
          const SizedBox(height: 10),
          Text(
            '₹${challenge.reward}',
            style: const TextStyle(color: gold),
          ),
        ],
      );

  Widget challengeComplete(BuildContext context) => Column(
        children: [
          Image.asset('assets/images/ChallengeComplete.png'),
          const SizedBox(height: 10),
          Text(
            '₹${challenge.reward}',
            style: const TextStyle(color: gold),
          ),
          SizedBox(
            width: 80,
            height: 30,
            child: claimButton(context),
          ),
        ],
      );

  // TODO: the sizing is wierd
  Widget claimButton(context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: gold,
          onPrimary: baseColor,
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          padding: const EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () => onClaimRewardClick(context),
        child: const Text('Claim Reward'),
      );

  Widget challengeRewardClaimed() => Column(
        children: [
          Image.asset('assets/images/ChallengeRewardClaimed.png'),
          const SizedBox(height: 10),
          Text(
            '₹${challenge.reward}',
            style: const TextStyle(
              color: gold,
              decoration: TextDecoration.lineThrough,
            ),
          )
        ],
      );

  void onClaimRewardClick(BuildContext context) =>
      context.read<ChallengeRewardCubit>().claimReward();
}
