import 'package:dalal_street_client/blocs/leaderboard/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/leaderboard_page_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyLeaderboardPage extends StatefulWidget {
  const DailyLeaderboardPage({Key? key}) : super(key: key);

  @override
  State<DailyLeaderboardPage> createState() => _DailyLeaderboardPageState();
}

class _DailyLeaderboardPageState extends State<DailyLeaderboardPage> {
  final List<Map<String, String>> tabledataDaily = [];
  @override
  initState() {
    super.initState();
    context.read<LeaderboardCubit>().getDailyLeaderboard(1, 100);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaderboardCubit, LeaderboardState>(
        builder: (context, state) {
      if (state is DailyLeaderboardSuccess) {
        {
          for (var e in state.rankList) {
            tabledataDaily.add({
              'rank': e.rank.toString(),
              'username': e.userName,
              'totalworth': e.totalWorth.toString()
            });
          }
        }
        return leaderboardPageData(state.myRank, context, tabledataDaily);
      } else if (state is DailyLeaderboardFailure) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to Fetch the Daily Leaderboard'),
            const SizedBox(height: 20),
            SizedBox(
              width: 100,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  context.read<LeaderboardCubit>().getDailyLeaderboard(1, 100);
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
