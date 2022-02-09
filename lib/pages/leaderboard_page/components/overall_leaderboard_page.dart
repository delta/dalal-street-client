import 'package:dalal_street_client/blocs/leaderboard/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/leaderboard_page_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OverallLeaderboardPage extends StatefulWidget {
  const OverallLeaderboardPage({Key? key}) : super(key: key);

  @override
  State<OverallLeaderboardPage> createState() => _OverallLeaderboardPageState();
}

class _OverallLeaderboardPageState extends State<OverallLeaderboardPage> {
  final List<Map<String, String>> tabledataOverall = [];
  final List<Map<String, String>> tabledataDaily = [];
  @override
  initState() {
    super.initState();
    context.read<LeaderboardCubit>().getOverallLeaderboard(1, 100);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaderboardCubit, LeaderboardState>(
        builder: (context, state) {
      if (state is OverallLeaderboardSuccess) {
        {
          for (var e in state.rankList) {
            tabledataOverall.add({
              'rank': e.rank.toString(),
              'username': e.userName,
              'totalworth': e.totalWorth.toString()
            });
          }
        }
        return leaderboardPageData(state.myRank, context, tabledataOverall);
      } else if (state is OverallLeaderboardFailure) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to Fetch the Overall Leaderboard'),
            const SizedBox(height: 20),
            SizedBox(
              width: 100,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  context
                      .read<LeaderboardCubit>()
                      .getOverallLeaderboard(1, 100);
                },
                child: const Text('Retry'),
              ),
            ),
          ],
        ));
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}
