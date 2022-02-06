import 'package:dalal_street_client/blocs/leaderboard/daily_leaderboard/daily_leaderboard_cubit.dart';
import 'package:dalal_street_client/blocs/leaderboard/overall_leaderboard/overall_leaderboard_cubit.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/top_container.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/top_daily_container.dart';
import 'package:dalal_street_client/proto_build/models/DailyLeaderboardRow.pb.dart';
import 'package:dalal_street_client/proto_build/models/LeaderboardRow.pb.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalal_street_client/theme/colors.dart';

final List<Map<String, String>> tabledataOverall = [];
final List<Map<String, String>> tabledataDaily = [];
final DataTableSource _data = MyData();
final DataTableSource _dataDaily = MyDataDaily();
final keyDaily = GlobalKey<PaginatedDataTableState>();

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  initState() {
    super.initState();
    context.read<OverallLeaderboardCubit>().getOverallLeaderboard(1, 10);
    context.read<DailyLeaderboardCubit>().getDailyLeaderboard(1, 10);
  }

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
      child: _overallleaderboard(),
    );
  }

  BlocBuilder<OverallLeaderboardCubit, OverallLeaderboardState>
      _overallleaderboard() {
    return BlocBuilder<OverallLeaderboardCubit, OverallLeaderboardState>(
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
        logger.i(tabledataOverall);
        return leaderboardPageUi(state.myRank, state.rankList, context);
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
                      .read<OverallLeaderboardCubit>()
                      .getOverallLeaderboard(1, 10);
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

  Padding leaderboardPageUi(
      int myRank, Iterable<LeaderboardRow> rankList, BuildContext context) {
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
                  child: TabBarView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: [
                        overallLeaderboardPageUi(myRank, rankList, context),
                        _dailyleaderboard()
                      ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  BlocBuilder<DailyLeaderboardCubit, DailyLeaderboardState>
      _dailyleaderboard() {
    return BlocBuilder<DailyLeaderboardCubit, DailyLeaderboardState>(
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
        logger.i(tabledataDaily);
        return dailyLeaderboardPageUi(state.myRank, state.rankList, context);
      } else if (state is DailyLeaderboardFailure) {
        logger.i(state.statusMessage);
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
                  context
                      .read<DailyLeaderboardCubit>()
                      .getDailyLeaderboard(1, 10);
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

  Padding overallLeaderboardPageUi(
      int myRank, Iterable<LeaderboardRow> rankList, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          topContainer(myRank, tabledataOverall),
          const SizedBox(
            height: 10,
          ),
          _tableContainer(rankList),
        ],
      ),
    );
  }

  Padding dailyLeaderboardPageUi(int myRank,
      Iterable<DailyLeaderboardRow> rankList, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          topDailyContainer(myRank, tabledataDaily),
          const SizedBox(
            height: 10,
          ),
          _tableDailyContainer(rankList),
        ],
      ),
    );
  }

  Container _tableContainer(Iterable<LeaderboardRow> rankList) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: background2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_table()]));
  }

  Container _tableDailyContainer(Iterable<DailyLeaderboardRow> rankList) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: background2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_tableDaily()]));
  }

  Theme _table() {
    // int i = 1;
    return Theme(
      data: Theme.of(context).copyWith(cardColor: background2),
      child: PaginatedDataTable(
          onPageChanged: (i) {
            context
                .read<OverallLeaderboardCubit>()
                .getOverallLeaderboard((10 * i) + 1, 10);
            i++;
          },
          source: _data,
          columnSpacing: 50,
          dataRowHeight: 35,
          rowsPerPage: 8,
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Rank',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            DataColumn(
              label: Text('User Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
            DataColumn(
              label: Text('Wealth',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
          ]),
    );
  }

  Theme _tableDaily() => Theme(
        data: Theme.of(context).copyWith(cardColor: background2),
        child: PaginatedDataTable(
            onPageChanged: (int page) {
              context
                  .read<DailyLeaderboardCubit>()
                  .getDailyLeaderboard((10 * page) + 1, 10);
            },
            source: _dataDaily,
            columnSpacing: 50,
            dataRowHeight: 35,
            rowsPerPage: 8,
            columns: const <DataColumn>[
              DataColumn(
                label: Text('Rank',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              DataColumn(
                label: Text('User Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              DataColumn(
                label: Text('Wealth',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
            ]),
      );
}

class MyData extends DataTableSource {
  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => tabledataOverall.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(
        tabledataOverall[index]['rank'].toString(),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        tabledataOverall[index]['username'].toString(),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        tabledataOverall[index]['totalworth'].toString(),
        textAlign: TextAlign.center,
      )),
    ]);
  }
}

class MyDataDaily extends DataTableSource {
  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => tabledataDaily.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(
        tabledataDaily[index]['rank'].toString(),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        tabledataDaily[index]['username'].toString(),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        tabledataDaily[index]['totalworth'].toString(),
        textAlign: TextAlign.center,
      )),
    ]);
  }
}
