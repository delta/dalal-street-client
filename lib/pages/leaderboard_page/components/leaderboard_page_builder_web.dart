import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/constants/leaderboard_type.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/leaderboard_table_web.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/rank_container_web.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderboardPageBuilderWeb extends StatefulWidget {
  const LeaderboardPageBuilderWeb({Key? key, required this.leaderboardType})
      : super(key: key);

  final LeaderboardType leaderboardType;
  @override
  State<LeaderboardPageBuilderWeb> createState() =>
      _LeaderboardPageBuilderWebState();
}

class _LeaderboardPageBuilderWebState extends State<LeaderboardPageBuilderWeb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                color: backgroundColor,
                child: SizedBox(
                  height: 800,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: rankContainerWeb(
                                widget.leaderboardType, context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: BlocProvider(
                            create: (context) => LeaderboardCubit(),
                            child: LeaderboardTableWeb(
                                leaderboardType: widget.leaderboardType),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 620.0, left: 40.0),
                        child: Text(
                          'The leaderboard is updated every 30 seconds.',
                          style: TextStyle(color: blurredGray, fontSize: 16.0),
                          textAlign: TextAlign.end,
                        ),
                      )
                    ],
                  ),
                ))));
  }
}
