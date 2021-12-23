import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/models/daily_challenge_info.dart';
import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class DailyChallengeItem extends StatelessWidget {
  final DailyChallengeInfo challengeInfo;

  DailyChallengeItem({Key? key, required this.challengeInfo}) : super(key: key);

  final Map<int, Stock> stockList = getIt();

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
                  Text(challengeTitle(challenge)),
                  Text(challengeDescription(
                      challenge, stockList[challenge.stockId]!)),
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

String challengeTitle(DailyChallenge challenge) {
  switch (challenge.challengeType) {
    case 'Cash':
      return 'Cash';
    case 'NetWorth':
      return 'Net Worth';
    case 'StockWorth':
      return 'Stock Worth';
    case 'SpecificStock':
      return 'Specific Stock';
    default:
      return '?!?!?!?!';
  }
}

String challengeDescription(DailyChallenge challenge, Stock stock) {
  switch (challenge.challengeType) {
    case 'Cash':
      return 'Increase cash worth by ₹${challenge.value}';
    case 'NetWorth':
      return 'Increase net worth by ₹${challenge.value}';
    case 'StockWorth':
      return 'Increase stock worth by ₹${challenge.value}';
    case 'SpecificStock':
      return 'Buy ${challenge.value} stocks from ${stock.fullName}';
    default:
      return '?!?!?!?!';
  }
}
