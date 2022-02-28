import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/constants/leaderboard_type.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/paginated_data_table_2.dart';
import '../leaderboard_page.dart';

class LeaderboardTableWeb extends StatefulWidget {
  const LeaderboardTableWeb({Key? key, required this.leaderboardType})
      : super(key: key);

  final LeaderboardType leaderboardType;
  @override
  State<LeaderboardTableWeb> createState() => _LeaderboardTableWebState();
}

class _LeaderboardTableWebState extends State<LeaderboardTableWeb> {
  @override
  initState() {
    super.initState();
    context
        .read<LeaderboardCubit>()
        .getLeaderboard(1, 10, widget.leaderboardType);
  }

  @override
  Widget build(BuildContext context) {
    int noOfEntries = 10;
    int startingIndex = 1;
    return Scaffold(
        body: SafeArea(
            child: Container(
                color: backgroundColor,
                child: SingleChildScrollView(child:
                    BlocBuilder<LeaderboardCubit, LeaderboardState>(
                        builder: (context, state) {
                  if (state is OverallLeaderboardSuccess) {
                    startingIndex = state.rankList[0].id;
                    noOfEntries = 10;
                    return _leaderboardTable(state.rankList, state.myRank,
                        state.totalUsers, startingIndex, noOfEntries);
                  } else if (state is DailyLeaderboardSuccess) {
                    startingIndex = state.rankList[0].id;
                    noOfEntries = 10;
                    return _leaderboardTable(state.rankList, state.myRank,
                        state.totalUsers, startingIndex, noOfEntries);
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
                              startingIndex == 1
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

  Widget _leaderboardTable(dynamic rankList, int myRank, int totalUsers,
      int startingIndex, int noOfEntries) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Theme(
        data: Theme.of(context).copyWith(
            cardColor: backgroundColor,
            dividerColor: backgroundColor,
            iconTheme: const IconThemeData(
              size: 35,
              color: white,
            ),
            cardTheme: const CardTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))))),
        child: PaginatedDataTable2(
            handleNext: (i) {
              startingIndex >= (totalUsers - noOfEntries)
                  ? {null}
                  : {
                      context.read<LeaderboardCubit>().getLeaderboard(
                          noOfEntries + startingIndex,
                          10,
                          widget.leaderboardType)
                    };
            },
            handlePrevious: (i) {
              startingIndex == 1
                  ? {null}
                  : {
                      context.read<LeaderboardCubit>().getLeaderboard(
                          startingIndex - noOfEntries,
                          10,
                          widget.leaderboardType)
                    };
            },
            source: MyData(tableData: rankList),
            columnSpacing: 5,
            dataRowHeight: 50,
            headingRowHeight: 50.0,
            rowsPerPage: 10,
            columns: <DataColumn>[
              DataColumn(
                label: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 120.0,
                        maxWidth: 120.0,
                      ),
                      child: const Text('Rank',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          minWidth: 720.0, maxWidth: 720.0),
                      child: const Text('Name',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 360.0,
                        maxWidth: 360.0,
                      ),
                      child: const Text('Stock Worth (₹)',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 360.0,
                        maxWidth: 360.0,
                      ),
                      child: const Text('Net Worth (₹)',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
            ]),
      ),
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
    Color bgColor = index % 2 != 0 ? background3 : background2;
    Color textColor = white;
    String imagePath = ' ';
    if (tableData[index].rank == 1) {
      textColor = gold;
      imagePath = 'assets/images/Batch1.png';
    } else if (tableData[index].rank == 2) {
      textColor = silver;
      imagePath = 'assets/images/Batch2.png';
    } else if (tableData[index].rank == 3) {
      textColor = bronze;
      imagePath = 'assets/images/Batch3.png';
    }
    return DataRow(cells: [
      DataCell(
        Center(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: bgColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 120.0,
                    maxWidth: 120.0,
                  ),
                  child: tableData[index].rank <= 3
                      ? Image(image: AssetImage(imagePath))
                      : _rankContainer(tableData[index].rank, textColor)),
            ),
          ),
        ),
      ),
      DataCell(Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              color: bgColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 720.0,
                maxWidth: 720.0,
              ),
              child: Text(
                (tableData[index].userName).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: textColor),
              ),
            ),
          ),
        ),
      )),
      DataCell(Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              color: bgColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 360.0,
                maxWidth: 360.0,
              ),
              child: Text(
                oCcy.format(tableData[index].stockWorth).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: textColor),
              ),
            ),
          ),
        ),
      )),
      DataCell(
        Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: bgColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 360.0,
                  maxWidth: 360.0,
                ),
                child: Text(
                  oCcy.format(tableData[index].totalWorth).toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: textColor),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

Widget _rankContainer(int rank, Color textColor) {
  return Text(
    rank.toString(),
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 20, color: textColor),
  );
}
