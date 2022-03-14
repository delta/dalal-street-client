import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/constants/leaderboard_type.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/leaderboard_page_builder.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/leaderboard_page_builder_web.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat('#,##0.00', 'en_US');

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Responsive(
            mobile: leaderboardPageMobileUi(),
            tablet: _tabletBody(),
            desktop: leaderboardPageDesktopUi(),
          ),
        ),
      ),
    );
  }

  Center _tabletBody() {
    var screenwidth = MediaQuery.of(context).size.width;
    return Center(
        child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: secondaryColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: leaderboardPageMobileUi(),
      margin: EdgeInsets.fromLTRB(screenwidth * 0.05, screenwidth * 0.03,
          screenwidth * 0.05, screenwidth * 0.1),
    ));
  }

  Widget leaderboardPageMobileUi() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Leaderboard',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: white,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 10,
          ),
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: const [
                    Tab(
                      child: Text(
                        'Overall',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: secondaryColor,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Daily',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: secondaryColor,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // Creates border
                      color: background2),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: [
                        BlocProvider(
                          create: (context) => LeaderboardCubit(),
                          child: const LeaderboardPageBuilder(
                              leaderboardType: LeaderboardType.Overall),
                        ),
                        BlocProvider(
                          create: (context) => LeaderboardCubit(),
                          child: const LeaderboardPageBuilder(
                              leaderboardType: LeaderboardType.Daily),
                        ),
                      ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget leaderboardPageDesktopUi() {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Leaderboard',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: white,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Winning isn\'t everything, it\'s the only thing',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: lightGray,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 20,
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: 350,
                          height: 50,
                          child: TabBar(
                            labelStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                            unselectedLabelColor: secondaryColor,
                            labelColor: Colors.black,
                            tabs: [
                              Tab(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0)),
                                      border: Border.all(color: primaryColor)),
                                  child: const Text(
                                    'Overall',
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0)),
                                      border: Border.all(color: primaryColor)),
                                  child: const Text(
                                    'Daily',
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ],
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        children: [
                          BlocProvider(
                            create: (context) => LeaderboardCubit(),
                            child: const LeaderboardPageBuilderWeb(
                                leaderboardType: LeaderboardType.Overall),
                          ),
                          BlocProvider(
                            create: (context) => LeaderboardCubit(),
                            child: const LeaderboardPageBuilderWeb(
                                leaderboardType: LeaderboardType.Daily),
                          )
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
