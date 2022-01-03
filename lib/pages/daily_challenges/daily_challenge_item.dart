import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/proto_build/models/UserState.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/challenge_util.dart';
import 'package:flutter/material.dart';

class DailyChallengeItem extends StatelessWidget {
  final DailyChallenge challenge;
  final UserState userState;
  final Stock? stock;

  DailyChallengeItem({
    Key? key,
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
  build(context) => Padding(
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
                    Text(challenge.title),
                    Text(challenge.description(stock)),
                    _challengeProgress(challenge),
                  ],
                ),
                _challengeReward(challenge),
              ],
            ),
          ),
        ),
      );

  // TODO: add progress bar
  // TODO: animate between changes in userInfoStream
  Widget _challengeProgress(DailyChallenge challenge) => StreamBuilder<int>(
        stream: progressStream,
        initialData: initialProgress,
        builder: (context, snapshot) {
          final progress = snapshot.data!;
          return Text('$progress/${challenge.value}');
        },
      );

  Widget _challengeReward(DailyChallenge challenge) => Column(
        children: [
          Image.asset('assets/images/Coin.png'),
          Text(
            '₹${challenge.reward}',
            style: const TextStyle(color: gold),
          )
        ],
      );
}
