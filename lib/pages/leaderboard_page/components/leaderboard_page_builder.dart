import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/constants/leaderboard_type.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/leaderboard_table.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/top_container.dart';
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
        .getLeaderboard(1, 8, widget.leaderboardType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                color: Colors.black,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    topContainer(widget.leaderboardType, context),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: BlocProvider(
                        create: (context) => LeaderboardCubit(),
                        child: LeaderboardTable(
                            leaderboardType: widget.leaderboardType),
                      ),
                    )
                  ],
                )))));
  }
}
