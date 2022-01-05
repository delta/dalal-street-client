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
  build(context) => Column(
        children: [
          Image.asset(userState.isRewardClamied
              ? 'assets/images/Coin Done.png'
              : 'assets/images/Coin.png'),
          const SizedBox(height: 10),
          Text(
            '₹${challenge.reward}',
            style: TextStyle(
              color: gold,
              decoration: userState.isRewardClamied
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          )
        ],
      );
}
