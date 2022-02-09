import 'package:dalal_street_client/pages/leaderboard_page/components/rank_container.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/table_container.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/table_header.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/top_container.dart';
import 'package:flutter/material.dart';

Padding leaderboardPageData(int myRank, BuildContext context,
    List<Map<String, String>> tableData, ScrollController _scrollController) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    child: Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        topContainer(tableData),
        rankContainer(myRank),
        const SizedBox(height: 5),
        tableHeader(),
        table(tableData, _scrollController),
      ],
    ),
  );
}
