import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
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
    int x = 8;
    int y = 4;
    return Scaffold(
        body: SafeArea(
            child: Container(
                color: Colors.black,
                child: SingleChildScrollView(child:
                    BlocBuilder<LeaderboardCubit, LeaderboardState>(
                        builder: (context, state) {
                  if (state is OverallLeaderboardSuccess) {
                    y = state.rankList[0].id;
                    x = 8;
                    return _leaderboardTable(
                        state.rankList, state.totalUsers, x, y);
                  } else if (state is DailyLeaderboardSuccess) {
                    y = state.rankList[0].id;
                    x = 8;
                    return _leaderboardTable(
                        state.rankList, state.totalUsers, x, y);
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
                              y == 4
                                  ? {
                                      context
                                          .read<LeaderboardCubit>()
                                          .getLeaderboard(
                                              y, 10, widget.leaderboardType)
                                    }
                                  : {
                                      context
                                          .read<LeaderboardCubit>()
                                          .getLeaderboard(
                                              x + y, 10, widget.leaderboardType)
                                    };
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

  Widget _leaderboardTable(dynamic rankList, int totalUsers, int x, int y) {
    return Theme(
      data: Theme.of(context).copyWith(
          cardColor: background2,
          cardTheme: const CardTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))))),
      child: PaginatedDataTable2(
          handleNext: (i) {
            y >= (totalUsers - x)
                ? {null}
                : {
                    context
                        .read<LeaderboardCubit>()
                        .getLeaderboard(x + y, 8, widget.leaderboardType)
                  };
          },
          handlePrevious: (i) {
            y == 4
                ? {null}
                : {
                    context
                        .read<LeaderboardCubit>()
                        .getLeaderboard(y - x, 8, widget.leaderboardType)
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
