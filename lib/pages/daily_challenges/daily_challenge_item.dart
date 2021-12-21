import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class DailyChallengeItem extends StatelessWidget {
  final DailyChallenge challenge;

  const DailyChallengeItem({Key? key, required this.challenge})
      : super(key: key);

  @override
  build(context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          color: baseColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(challenge.challengeType),
                Text(challengeDescription(challenge)),
                Text('0/${challenge.value}'),
              ],
            ),
          ),
        ),
      );
}

String challengeDescription(DailyChallenge challenge) {
  // TODO: do for remaining cases
  if (challenge.challengeType == 'SpecificStock') {
    return 'Increase the number of stocks by ${challenge.value}';
  }
  return '?!?!?!?!';
}
