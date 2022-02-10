import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/constants/leaderboard_type.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/leaderboard_page_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderboardPageBuilder extends StatefulWidget {
  const LeaderboardPageBuilder({Key? key, required this.leaderboardType})
      : super(key: key);

  final LeaderboardType leaderboardType;
  @override
  State<LeaderboardPageBuilder> createState() => _LeaderboardPageBuilderState();
}

class _LeaderboardPageBuilderState extends State<LeaderboardPageBuilder> {
  @override
  initState() {
    super.initState();
    context
        .read<LeaderboardCubit>()
        .getLeaderboard(1, 100, widget.leaderboardType);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaderboardCubit, LeaderboardState>(
        builder: (context, state) {
      if (state is DailyLeaderboardSuccess) {
        return leaderboardPageData(state.myRank, context, state.rankList);
      } else if (state is OverallLeaderboardSuccess) {
        return leaderboardPageData(state.myRank, context, state.rankList);
      } else if (state is LeaderboardFailure) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to fetch the leaderboard. Please try again.'),
            const SizedBox(height: 20),
            SizedBox(
              width: 100,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  context
                      .read<LeaderboardCubit>()
                      .getLeaderboard(1, 100, widget.leaderboardType);
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
