import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/constants/leaderboard_type.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/leaderboard_table_web.dart';
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
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                color: backgroundColor,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: BlocProvider(
                          create: (context) => LeaderboardCubit(),
                          child: LeaderboardTableWeb(
                              leaderboardType: widget.leaderboardType),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
