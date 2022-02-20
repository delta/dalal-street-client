import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
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
    int x = 10;
    int y = 1;
    return Scaffold(
        body: SafeArea(
            child: Container(
                color: backgroundColor,
                child: SingleChildScrollView(child:
                    BlocBuilder<LeaderboardCubit, LeaderboardState>(
                        builder: (context, state) {
                  if (state is OverallLeaderboardSuccess) {
                    y = state.rankList[0].id;
                    x = 10;
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                cardColor: backgroundColor,
                                dividerColor: backgroundColor,
                                cardTheme: const CardTheme(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))))),
                            child: PaginatedDataTable2(
                                handleNext: (i) {
                                  y >= (state.totalUsers - x)
                                      ? {null}
                                      : {
                                          context
                                              .read<LeaderboardCubit>()
                                              .getLeaderboard(x + y, 10,
                                                  widget.leaderboardType)
                                        };
                                },
                                handlePrevious: (i) {
                                  y == 1
                                      ? {null}
                                      : {
                                          context
                                              .read<LeaderboardCubit>()
                                              .getLeaderboard(y - x, 10,
                                                  widget.leaderboardType)
                                        };
                                },
                                source: MyData(tableData: state.rankList),
                                columnSpacing: 5,
                                dataRowHeight: 50,
                                headingRowHeight: 50.0,
                                rowsPerPage: 10,
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 570),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: baseColor),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Your rank is ',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            state.myRank.toString(),
                                            style: const TextStyle(
                                                color: secondaryColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text(
                                            ' out of ',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            state.totalUsers.toString(),
                                            style: const TextStyle(
                                                color: Colors.yellow,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text(
                                            ' participants. ',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      )))
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is DailyLeaderboardSuccess) {
                    y = state.rankList[0].id;
                    x = 10;
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                cardColor: backgroundColor,
                                dividerColor: backgroundColor,
                                cardTheme: const CardTheme(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))))),
                            child: PaginatedDataTable2(
                                handleNext: (i) {
                                  y >= (state.totalUsers - x)
                                      ? {null}
                                      : {
                                          context
                                              .read<LeaderboardCubit>()
                                              .getLeaderboard(x + y, 10,
                                                  widget.leaderboardType)
                                        };
                                },
                                handlePrevious: (i) {
                                  y == 1
                                      ? {null}
                                      : {
                                          context
                                              .read<LeaderboardCubit>()
                                              .getLeaderboard(y - x, 10,
                                                  widget.leaderboardType)
                                        };
                                },
                                source: MyData(tableData: state.rankList),
                                columnSpacing: 5,
                                dataRowHeight: 50,
                                headingRowHeight: 50.0,
                                rowsPerPage: 10,
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 570),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: baseColor),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Your rank is ',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            state.myRank.toString(),
                                            style: const TextStyle(
                                                color: secondaryColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text(
                                            ' out of ',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            state.totalUsers.toString(),
                                            style: const TextStyle(
                                                color: Colors.yellow,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text(
                                            ' participants. ',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      )))
                            ],
                          ),
                        ),
                      ],
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
                              y == 1
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
    if (tableData[index].rank == 1 ||
        tableData[index].rank == 2 ||
        tableData[index].rank == 3) {
      Color textColor = background2;
      String imagePath = ' ';
      if (tableData[index].rank == 1) {
        textColor = gold;
        imagePath = 'assets/images/Batch1.png';
      } else if (tableData[index].rank == 2) {
        textColor = silver;
        imagePath = 'assets/images/Batch2.png';
      } else {
        textColor = bronze;
        imagePath = 'assets/images/Batch3.png';
      }
      return DataRow(cells: [
        DataCell(
          Center(
            child: Container(
              height: 45,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: background2),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 120.0,
                    maxWidth: 120.0,
                  ),
                  child: Image(image: AssetImage(imagePath)),
                ),
              ),
            ),
          ),
        ),
        DataCell(Center(
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: background2),
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
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: background2),
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
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: background2),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
    } else {
      return DataRow(cells: [
        DataCell(
          Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  color: index % 2 != 0 ? background3 : background2),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 120.0,
                    maxWidth: 120.0,
                  ),
                  child: Text(
                    tableData[index].rank.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ),
        DataCell(Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: index % 2 != 0 ? background3 : background2),
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
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        )),
        DataCell(Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: index % 2 != 0 ? background3 : background2),
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
                  style: const TextStyle(fontSize: 20),
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
                  color: index % 2 != 0 ? background3 : background2),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 360.0,
                    maxWidth: 360.0,
                  ),
                  child: Text(
                    oCcy.format(tableData[index].totalWorth).toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]);
    }
  }
}
