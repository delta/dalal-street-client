import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/constants/leaderboard_type.dart';
// import 'package:dalal_street_client/pages/leaderboard_page/components/leaderboard_page_builder.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../leaderboard_page.dart';

class LeaderboardTable extends StatefulWidget {
  const LeaderboardTable({Key? key, required this.leaderboardType})
      : super(key: key);

  final LeaderboardType leaderboardType;
  @override
  State<LeaderboardTable> createState() => _LeaderboardTableState();
}

class _LeaderboardTableState extends State<LeaderboardTable> {
  @override
  initState() {
    super.initState();
    context
        .read<LeaderboardCubit>()
        .getLeaderboard(4, 8, widget.leaderboardType);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          child: Container(
              color: Colors.black,
              child: SingleChildScrollView(child:
                  BlocBuilder<LeaderboardCubit, LeaderboardState>(
                      builder: (context, state) {
                if (state is OverallLeaderboardSuccess) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                        cardColor: background2,
                        cardTheme: const CardTheme(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))))),
                    child: PaginatedDataTable(
                        handleNext: (i) {
                          int y = state.rankList[0].id;
                          int x = 8;
                          y >= state.totalUsers - x
                              ? {}
                              : {
                                  context
                                      .read<LeaderboardCubit>()
                                      .getLeaderboard(
                                          x + y, 8, widget.leaderboardType)
                                };
                        },
                        handlePrevious: (i) {
                          int y = state.rankList[0].id;
                          int x;
                          y == 4
                              ? {null}
                              : {
                                  x = 8,
                                  context
                                      .read<LeaderboardCubit>()
                                      .getLeaderboard(
                                          y - x, 8, widget.leaderboardType)
                                };
                        },
                        source: MyData(tableData: state.rankList),
                        columnSpacing: 20,
                        dataRowHeight: 40,
                        headingRowHeight: 40.0,
                        rowsPerPage: 8,
                        horizontalMargin: 30,
                        columns: <DataColumn>[
                          const DataColumn(
                            label: Text('Rank',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                          ),
                          DataColumn(
                            label: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 120.0,
                                maxWidth: 120.0,
                              ),
                              child: const Text('Name',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                          const DataColumn(
                            label: Text('Stock Worth (₹)',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                          ),
                          const DataColumn(
                            label: Text('Net Worth (₹)',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                          ),
                        ]),
                  );
                } else if (state is DailyLeaderboardSuccess) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                        cardColor: background2,
                        cardTheme: const CardTheme(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))))),
                    child: Center(
                      child: PaginatedDataTable(
                          handleNext: (i) {
                            int y = state.rankList[0].rank;
                            int x = 8;
                            y >= state.totalUsers - x
                                ? {}
                                : {
                                    context
                                        .read<LeaderboardCubit>()
                                        .getLeaderboard(
                                            x + y, 8, widget.leaderboardType)
                                  };
                          },
                          handlePrevious: (i) {
                            int y = state.rankList[0].rank;
                            int x;
                            y == 4
                                ? {null}
                                : {
                                    x = 8,
                                    context
                                        .read<LeaderboardCubit>()
                                        .getLeaderboard(
                                            y - x, 8, widget.leaderboardType)
                                  };
                          },
                          source: MyData(tableData: state.rankList),
                          columnSpacing: 20,
                          dataRowHeight: 40,
                          headingRowHeight: 40.0,
                          rowsPerPage: 8,
                          // horizontalMargin: 30,
                          columns: <DataColumn>[
                            const DataColumn(
                              label: Text('Rank',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                            DataColumn(
                              label: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 120.0,
                                  maxWidth: 120.0,
                                ),
                                child: const Text('Name',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                              ),
                            ),
                            const DataColumn(
                              label: Text('Stock Worth (₹)',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                            const DataColumn(
                              label: Text('Net Worth (₹)',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            ),
                          ]),
                    ),
                  );
                } else if (state is LeaderboardFailure) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          'Failed to fetch the leaderboard. Please try again.'),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            context
                                .read<LeaderboardCubit>()
                                .getLeaderboard(4, 8, widget.leaderboardType);
                          },
                          child: const Text('Retry'),
                        ),
                      ),
                    ],
                  ));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })))));
}

class MyData extends DataTableSource {
  MyData({required this.tableData});

  final dynamic tableData;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => tableData.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(
        Center(
          child: Text(
            tableData[index].rank.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      DataCell(ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 120.0,
          maxWidth: 120.0,
        ),
        child: Center(
          child: Text(
            tableData[index].userName.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      )),
      DataCell(Center(
        child: Text(
          oCcy.format(tableData[index].stockWorth).toString(),
          textAlign: TextAlign.center,
        ),
      )),
      DataCell(
        Center(
          child: Text(
            oCcy.format(tableData[index].totalWorth).toString(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ]);
  }
}
