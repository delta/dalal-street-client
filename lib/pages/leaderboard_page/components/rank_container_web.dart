import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/constants/leaderboard_type.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget rankContainerWeb(LeaderboardType leaderboardType, BuildContext context) {
  context.read<LeaderboardCubit>().getLeaderboard(1, 3, leaderboardType);
  return BlocBuilder<LeaderboardCubit, LeaderboardState>(
      builder: (context, state) {
    if (state is OverallLeaderboardSuccess) {
      return rankContainer(state.myRank, state.totalUsers);
    } else if (state is DailyLeaderboardSuccess) {
      return rankContainer(state.myRank, state.totalUsers);
    } else {
      context.read<LeaderboardCubit>().getLeaderboard(1, 3, leaderboardType);
      return const Center(child: CircularProgressIndicator());
    }
  });
}

Widget rankContainer(myRank, totalUsers) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: baseColor),
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Your rank is ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    myRank.toString(),
                    style: const TextStyle(
                        color: secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    ' out of ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    totalUsers.toString(),
                    style: const TextStyle(
                        color: Colors.yellow,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    ' participants. ',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              )))
    ],
  );
}
