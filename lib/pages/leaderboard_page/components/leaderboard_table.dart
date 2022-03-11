import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/constants/leaderboard_type.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/paginated_data_table_2.dart';
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
  Widget build(BuildContext context) {
    int noOfEntries = 8;
    int startingIndex = 4;
    return Scaffold(
        body: SafeArea(
            child: Container(
                color: Colors.black,
                child: SingleChildScrollView(child:
                    BlocBuilder<LeaderboardCubit, LeaderboardState>(
                        builder: (context, state) {
                  if (state is OverallLeaderboardSuccess) {
                    if (state.rankList.isEmpty) {
                      return Center(
                          child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const Text(
                            'Leaderboard will be created after registration of atleast 5 players'),
                      ));
                    }
                    startingIndex = state.rankList[0].id;
                    noOfEntries = 8;
                    return _leaderboardTable(state.rankList, state.totalUsers,
                        noOfEntries, startingIndex);
                  } else if (state is DailyLeaderboardSuccess) {
                    if (state.rankList.isEmpty) {
                      return Center(
                          child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const Text(
                            'Leaderboard will be created after registration of atleast 5 players'),
                      ));
                    }
                    startingIndex = state.rankList[0].id;
                    noOfEntries = 8;
                    return _leaderboardTable(state.rankList, state.totalUsers,
                        noOfEntries, startingIndex);
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
                              startingIndex == 4
                                  ? {
                                      context
                                          .read<LeaderboardCubit>()
                                          .getLeaderboard(startingIndex, 10,
                                              widget.leaderboardType)
                                    }
                                  : {
                                      context
                                          .read<LeaderboardCubit>()
                                          .getLeaderboard(
                                              noOfEntries + startingIndex,
                                              10,
                                              widget.leaderboardType)
                                    };
                            },
                            child: const Text('Retry'),
                          ),
                        ),
                      ],
                    ));
                  } else {
                    return const Center(child: DalalLoadingBar());
                  }
                })))));
  }

  Widget _leaderboardTable(
      dynamic rankList, int totalUsers, int noOfEntries, int startingIndex) {
    return Theme(
      data: Theme.of(context).copyWith(
          cardColor: background2,
          cardTheme: const CardTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))))),
      child: PaginatedDataTable2(
          handleNext: (i) {
            startingIndex >= (totalUsers - noOfEntries)
                ? {null}
                : {
                    context.read<LeaderboardCubit>().getLeaderboard(
                        noOfEntries + startingIndex, 8, widget.leaderboardType)
                  };
          },
          handlePrevious: (i) {
            startingIndex == 4
                ? {null}
                : {
                    context.read<LeaderboardCubit>().getLeaderboard(
                        startingIndex - noOfEntries, 8, widget.leaderboardType)
                  };
          },
          source: MyData(tableData: rankList),
          columnSpacing: 20,
          dataRowHeight: 40,
          headingRowHeight: 40.0,
          rowsPerPage: 8,
          columns: <DataColumn>[
            const DataColumn(
              label: Text('Rank',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
            DataColumn(
              label: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 120.0,
                  maxWidth: 120.0,
                ),
                child: const Text('Name',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
            ),
            const DataColumn(
              label: Text('Stock Worth (₹)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
            const DataColumn(
              label: Text('Net Worth (₹)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
          ]),
    );
  }
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
