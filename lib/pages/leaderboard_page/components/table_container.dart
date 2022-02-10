import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/constants/leaderboard_type.dart';
import 'package:dalal_street_client/pages/leaderboard_page/components/table_data.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

Widget table(List<Map<String, String>> tableData,
    LeaderboardType leaderboardType, BuildContext context) {
  // int i = 1;
  final DataTableSource _data = MyData(tableData: tableData);
  return SingleChildScrollView(
    child: Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      width: double.infinity,
      child: Theme(
        data: Theme.of(context).copyWith(cardColor: background2),
        child: PaginatedDataTable(
            onPageChanged: (i) {
              context
                  .read<LeaderboardCubit>()
                  .getLeaderboard((10 * i) + 1, 10, leaderboardType);
              i++;
            },
            source: _data,
            columnSpacing: 20,
            dataRowHeight: 40,
            headingRowHeight: 40.0,
            rowsPerPage: 8,
            horizontalMargin: 30,
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Rank',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              DataColumn(
                label: Text('User Name',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              DataColumn(
                label: Text('Stock Worth',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              DataColumn(
                label: Text('Net Worth',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
            ]),
      ),
    ),
  );
}

  
// Widget table(
//   List<Map<String, String>> tableData,
// ) {
//   return Expanded(
//     child: Container(
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.only(
//             bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
//         color: background2,
//       ),
//       width: double.infinity,
//       child: ListView.builder(
//           itemCount: tableData.length,
//           itemBuilder: (BuildContext context, int index) {
//             return Center(
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ListTile(
//                   onTap: null,
//                   visualDensity: const VisualDensity(vertical: -2),
//                   title: Row(
//                     children: <Widget>[
//                       const Padding(padding: EdgeInsets.all(10)),
//                       Expanded(
//                           flex: 1,
//                           child: Text(
//                             '  ' + tableData[index]['rank'].toString(),
//                             style: const TextStyle(fontSize: 15),
//                             textAlign: TextAlign.start,
//                           )),
//                       Expanded(
//                           flex: 3,
//                           child: Text(tableData[index]['username'].toString(),
//                               style: const TextStyle(fontSize: 15))),
//                       Expanded(
//                           flex: 2,
//                           child: Text(tableData[index]['stockworth'].toString(),
//                               style: const TextStyle(fontSize: 15))),
//                       Expanded(
//                           flex: 2,
//                           child: Text(tableData[index]['totalworth'].toString(),
//                               style: const TextStyle(fontSize: 15))),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }),
//     ),
//   );
// }
