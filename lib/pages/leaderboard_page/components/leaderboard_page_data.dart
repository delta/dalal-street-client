import 'package:dalal_street_client/constants/leaderboard_type.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/rank_container.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/table_container.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/top_container.dart';
import 'package:flutter/material.dart';

Padding leaderboardPageData(int myRank, BuildContext context, dynamic rankList,
    LeaderboardType leaderboardType) {
  final List<Map<String, String>> tableData = [];
  final List<Map<String, String>> top3Data = [];

  for (var e in rankList) {
    (e.id == 1 || e.id == 2 || e.id == 3)
        ? {
            top3Data.add({
              'rank': e.rank.toString(),
              'username': e.userName,
              'totalworth': e.totalWorth.toString(),
              'stockworth': e.stockWorth.toString()
            })
          }
        : {
            tableData.add({
              'rank': e.rank.toString(),
              'username': e.userName,
              'totalworth': e.totalWorth.toString(),
              'stockworth': e.stockWorth.toString()
            })
          };
  }
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    child: Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        topContainer(top3Data),
        rankContainer(myRank),
        const SizedBox(height: 20),
        // tableHeader(),
        table(tableData, leaderboardType, context),
      ],
    ),
  );
}
