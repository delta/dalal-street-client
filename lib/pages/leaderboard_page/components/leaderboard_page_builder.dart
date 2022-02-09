import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/leaderboard_page_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderboardPageBuilder extends StatefulWidget {
  const LeaderboardPageBuilder({Key? key, required this.leaderboardType})
      : super(key: key);

  final String leaderboardType;
  @override
  State<LeaderboardPageBuilder> createState() => _LeaderboardPageBuilderState();
}

class _LeaderboardPageBuilderState extends State<LeaderboardPageBuilder> {
  @override
  initState() {
    super.initState();
    if (widget.leaderboardType == leaderboardTypes.Overall.toString()) {
      //overall leaderboard
      context
          .read<LeaderboardCubit>()
          .getLeaderboard(1, 100, leaderboardTypes.Overall.toString());
    } else {
      //daily leaderboard
      context
          .read<LeaderboardCubit>()
          .getLeaderboard(1, 100, leaderboardTypes.Daily.toString());
    }
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
                  if (widget.leaderboardType ==
                      leaderboardTypes.Overall.toString()) {
                    context.read<LeaderboardCubit>().getLeaderboard(
                        1, 100, leaderboardTypes.Overall.toString());
                  } else {
                    context.read<LeaderboardCubit>().getLeaderboard(
                        1, 100, leaderboardTypes.Daily.toString());
                  }
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
