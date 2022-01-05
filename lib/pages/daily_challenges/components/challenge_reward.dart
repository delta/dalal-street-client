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
          } else if (state is ChallengeRewardCalimed) {
            showSnackBar(context, 'Reward of ₹${state.reward} Claimed!');
          }
        },
        builder: (context, state) {
          if (state is ChallengeIncomplete) {
            return challengeIncomplete();
          } else if (state is ChallengeComplete) {
            return claimReward(context);
          } else if (state is ChallengeRewardCalimed) {
            return rewardClaimed();
          }
          return const CircularProgressIndicator();
        },
      );

  Widget challengeIncomplete() => Column(
        children: [
          Image.asset('assets/images/Coin.png'),
          const SizedBox(height: 10),
          Text(
            '₹${challenge.reward}',
            style: const TextStyle(color: gold),
          )
        ],
      );

  Widget claimReward(BuildContext context) => SizedBox(
        width: 80,
        child: TextButton(
          onPressed: () => onClaimRewardClick(context),
          child: const Text('Claim Reward'),
        ),
      );

  Widget rewardClaimed() => Column(
        children: [
          Image.asset('assets/images/Coin Done.png'),
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
