import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:flutter/material.dart';

class DailyChallengeItem extends StatelessWidget {
  final DailyChallenge challenge;

  const DailyChallengeItem({Key? key, required this.challenge})
      : super(key: key);

  @override
  build(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '${challenge.reward}',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              challengeDescription(challenge),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '0/${challenge.value}',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
}

String challengeDescription(DailyChallenge challenge) {
  // TODO: do for remaining cases
  if (challenge.challengeType == 'SpecificStock') {
    return 'Increase the number of stocks by ${challenge.value}';
  }
  return '?!?!?!?!';
}
