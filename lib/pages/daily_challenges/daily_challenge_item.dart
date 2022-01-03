import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/models/daily_challenge_info.dart';
import 'package:dalal_street_client/models/dynamic_user_info.dart';
import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/proto_build/models/UserState.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/challenge_util.dart';
import 'package:flutter/material.dart';

class DailyChallengeItem extends StatelessWidget {
  final DailyChallengeInfo challengeInfo;
  final Stock? stock;

  DailyChallengeItem({
    Key? key,
    required this.challengeInfo,
    required this.stock,
  }) : super(key: key);

  final userInfoStream = getIt<GlobalStreams>().dynamicUserInfoStream;

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
                  Text(challenge.title),
                  Text(challenge.description(stock)),
                  _challengeProgress(challenge, userState),
                ],
              ),
              _challengeReward(),
            ],
          ),
        ),
      ),
    );
  }

  // TODO: add progress bar
  // TODO: animate between changes in userInfoStream
  Widget _challengeProgress(DailyChallenge challenge, UserState userState) =>
      StreamBuilder(
        stream: userInfoStream,
        initialData: userInfoStream.value,
        builder: (context, AsyncSnapshot<DynamicUserInfo> snapshot) {
          final userInfo = snapshot.data!;
          final progress = challenge.progress(userInfo, userState);
          return Text('$progress/${challenge.value}');
        },
      );

  Widget _challengeReward() => Column(
        children: [
          Image.asset('assets/images/Coin.png'),
          Text(
            '₹${challengeInfo.challenge.reward}',
            style: const TextStyle(color: gold),
          )
        ],
      );
}
