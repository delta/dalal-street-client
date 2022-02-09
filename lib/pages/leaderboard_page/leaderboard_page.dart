import 'package:dalal_street_client/constants/leaderboard_type.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/leaderboard_page_builder.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:dalal_street_client/theme/colors.dart';

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
            mobile: _mobileBody(),
            tablet: _tabletBody(),
            desktop: _desktopBody(),
          ),
        ),
      ),
    );
  }

  Center _desktopBody() {
    return const Center(
      child: Text(
        'Web UI will design soon :)',
        style: TextStyle(
          fontSize: 14,
          color: secondaryColor,
        ),
      ),
    );
  }

  Center _tabletBody() {
    return const Center(
      child: Text(
        'Tablet UI will design soon :)',
        style: TextStyle(
          fontSize: 14,
          color: secondaryColor,
        ),
      ),
    );
  }

  Padding _mobileBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: leaderboardPageUi(),
    );
  }

  Padding leaderboardPageUi() {
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
            height: 5,
          ),
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        'Overall',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: lightGray,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Daily',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: lightGray,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                  indicatorColor: lightGray,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: const TabBarView(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: [
                        LeaderboardPageBuilder(
                            leaderboardType: LeaderboardType.Overall),
                        LeaderboardPageBuilder(
                            leaderboardType: LeaderboardType.Daily)
                      ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
