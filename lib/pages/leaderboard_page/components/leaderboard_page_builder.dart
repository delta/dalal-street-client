import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/leaderboard_type.dart';
// import 'package:dalal_street_client/pages/leaderboard_page/components/leaderboard_page_data.dart';
import 'package:dalal_street_client/theme/colors.dart';
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
  final List<Map<String, String>> tableDataDaily = [];
  final List<Map<String, String>> tableDataOverall = [];
  final List<Map<String, String>> top3DataDaily = [];
  final List<Map<String, String>> top3DataOverall = [];
  @override
  initState() {
    super.initState();
    context
        .read<LeaderboardCubit>()
        .getLeaderboard(1, 20, widget.leaderboardType);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaderboardCubit, LeaderboardState>(
        builder: (context, state) {
      if (state is DailyLeaderboardSuccess) {
        return _leaderboardPageData(
            state.myRank, context, state.rankList, widget.leaderboardType);
      } else if (state is OverallLeaderboardSuccess) {
        return _leaderboardPageData(
            state.myRank, context, state.rankList, widget.leaderboardType);
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
                      .getLeaderboard(1, 20, widget.leaderboardType);
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

  Padding _leaderboardPageData(int myRank, BuildContext context,
      dynamic rankList, LeaderboardType leaderboardType) {
    if (leaderboardType == LeaderboardType.Daily) {
      for (var e in rankList) {
        (e.id == 1 || e.id == 2 || e.id == 3)
            ? {
                top3DataDaily.add({
                  'rank': e.rank.toString(),
                  'username': e.userName,
                  'totalworth': e.totalWorth.toString(),
                  'stockworth': e.stockWorth.toString()
                })
              }
            : {
                tableDataDaily.add({
                  'rank': e.rank.toString(),
                  'username': e.userName,
                  'totalworth': e.totalWorth.toString(),
                  'stockworth': e.stockWorth.toString()
                })
              };
      }
      logger.i(tableDataDaily);
      logger.i(top3DataDaily);
    } else {
      for (var e in rankList) {
        (e.id == 1 || e.id == 2 || e.id == 3)
            ? {
                top3DataOverall.add({
                  'rank': e.rank.toString(),
                  'username': e.userName,
                  'totalworth': e.totalWorth.toString(),
                  'stockworth': e.stockWorth.toString()
                })
              }
            : {
                tableDataOverall.add({
                  'rank': e.rank.toString(),
                  'username': e.userName,
                  'totalworth': e.totalWorth.toString(),
                  'stockworth': e.stockWorth.toString()
                })
              };
      }
      logger.i(tableDataOverall);
      logger.i(top3DataOverall);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          _topContainer(leaderboardType),
          _rankContainer(myRank),
          const SizedBox(height: 20),
          // tableHeader(),
          _table(leaderboardType, context),
        ],
      ),
    );
  }

  Container _topContainer(LeaderboardType leaderboardType) {
    List<Map<String, String>> tabledata = [];
    leaderboardType == LeaderboardType.Overall
        ? {tabledata = top3DataOverall}
        : {tabledata = top3DataDaily};
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        color: background2,
      ),
      width: double.infinity,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 35.0),
                        child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: silver, width: 4),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/placeholder.png'),
                                    fit: BoxFit.fill))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: silver, width: 2),
                                color: background2),
                            child: const Text(
                              '2',
                              style: TextStyle(
                                  color: silver, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 130.0),
                        child: Column(
                          children: [
                            Text(
                              tabledata[1]['username'].toString(),
                              style: const TextStyle(color: silver),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              tabledata[1]['totalworth'].toString(),
                              style: const TextStyle(color: silver),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 35.0),
                        child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: gold, width: 3),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/placeholder.png'),
                                    fit: BoxFit.fill))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 140),
                        child: Image.asset('assets/images/crown.png',
                            width: 50, height: 50),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: gold, width: 2),
                                color: background2),
                            child: const Text(
                              '1',
                              style: TextStyle(
                                  color: gold, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 130.0),
                        child: Column(
                          children: [
                            Text(
                              tabledata[0]['username'].toString(),
                              style: const TextStyle(color: gold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              tabledata[0]['totalworth'].toString(),
                              style: const TextStyle(color: gold),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 35.0),
                        child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: bronze, width: 4),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/placeholder.png'),
                                    fit: BoxFit.fill))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: bronze, width: 2),
                                color: background2),
                            child: const Text(
                              '3',
                              style: TextStyle(
                                  color: bronze, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 130.0),
                        child: Column(
                          children: [
                            Text(
                              tabledata[2]['username'].toString(),
                              style: const TextStyle(color: bronze),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              tabledata[2]['totalworth'].toString(),
                              style: const TextStyle(color: bronze),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _rankContainer(int myRank) {
    return Container(
        padding:
            const EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 15),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
            color: background2),
        width: double.infinity,
        child: Row(children: [
          const Padding(padding: EdgeInsets.all(10)),
          const Text(
            'My Rank   ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            myRank.toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ]));
  }

  Widget _table(LeaderboardType leaderboardType, BuildContext context) {
    return Expanded(
      child: Theme(
        data: Theme.of(context).copyWith(
            cardColor: background2,
            cardTheme: const CardTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))))),
        child: PaginatedDataTable(
            // onPageChanged: (i) {
            //   context
            //       .read<LeaderboardCubit>()
            //       .getLeaderboard((20 * (i ~/ 8)) + 1, 20, leaderboardType);
            // },
            source: MyData(
                tableData: leaderboardType == LeaderboardType.Overall
                    ? tableDataOverall
                    : tableDataDaily),
            columnSpacing: 20,
            dataRowHeight: 40,
            headingRowHeight: 40.0,
            rowsPerPage: 8,
            horizontalMargin: 30,
            columns: <DataColumn>[
              DataColumn(
                label: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 40.0,
                    maxWidth: 40.0,
                  ),
                  child: const Text(
                    'Rank',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 100.0,
                    maxWidth: 100.0,
                  ),
                  child: const Text('Name',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ),
              ),
              DataColumn(
                label: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 90.0,
                    maxWidth: 90.0,
                  ),
                  child: const Text('Stock Worth',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ),
              ),
              DataColumn(
                label: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 70.0,
                    maxWidth: 70.0,
                  ),
                  child: const Text('Net Worth',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ),
              ),
            ]),
      ),
    );
  }
}

class MyData extends DataTableSource {
  MyData({required this.tableData});

  final List<Map<String, String>> tableData;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => tableData.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 20.0,
          maxWidth: 20.0,
        ),
        child: Text(
          tableData[index]['rank'].toString(),
          textAlign: TextAlign.center,
        ),
      )),
      DataCell(ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 100.0,
          maxWidth: 100.0,
        ),
        child: Text(
          tableData[index]['username'].toString(),
          textAlign: TextAlign.center,
        ),
      )),
      DataCell(ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 80.0,
          maxWidth: 80.0,
        ),
        child: Text(
          tableData[index]['stockworth'].toString(),
          textAlign: TextAlign.center,
        ),
      )),
      DataCell(ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 70.0,
          maxWidth: 70.0,
        ),
        child: Text(
          tableData[index]['totalworth'].toString(),
          textAlign: TextAlign.center,
        ),
      )),
    ]);
  }
}
