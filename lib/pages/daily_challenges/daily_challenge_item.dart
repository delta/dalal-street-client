import 'package:dalal_street_client/models/daily_challenge_info.dart';
import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class DailyChallengeItem extends StatelessWidget {
  final DailyChallengeInfo challengeInfo;

  const DailyChallengeItem({Key? key, required this.challengeInfo})
      : super(key: key);

  @override
  build(context) {
    final challenge = challengeInfo.challenge;
    final userState = challengeInfo.userState;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: baseColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(challenge.challengeType),
                  Text(challengeDescription(challenge)),
                  Text(
                      '${userState.finalValue - userState.initialValue}/${challenge.value}'),
                ],
              ),
              rewardIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget rewardIndicator() => Column(
        children: [
          Image.asset('assets/images/Coin.png'),
          Text(
            '₹${challengeInfo.challenge.reward}',
            style: const TextStyle(color: gold),
          )
        ],
      );
}

String challengeDescription(DailyChallenge challenge) {
  // TODO: do for remaining cases
  if (challenge.challengeType == 'SpecificStock') {
    return 'Buy ${challenge.value} stocks from ${challenge.stockId}';
  }
  return '?!?!?!?!';
}
