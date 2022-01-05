import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:dalal_street_client/proto_build/models/UserState.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class ChallengeReward extends StatelessWidget {
  final UserState userState;
  final DailyChallenge challenge;

  const ChallengeReward({
    Key? key,
    required this.userState,
    required this.challenge,
  }) : super(key: key);

  @override
  build(context) {
    if (!userState.isCompleted) {
      return challengeIncomplete();
    } else if (userState.isCompleted && !userState.isRewardClamied) {
      return claimReward();
    } else {
      return rewardClaimed();
    }
  }

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

  Widget claimReward() => SizedBox(
        width: 80,
        child: TextButton(
          onPressed: () {},
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
}
