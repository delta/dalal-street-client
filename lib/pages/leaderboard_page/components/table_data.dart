import 'package:flutter/material.dart';

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
      DataCell(SizedBox(
        width: 1,
        child: Text(
          tableData[index]['rank'].toString(),
          textAlign: TextAlign.center,
        ),
      )),
      DataCell(ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 200.0,
          maxWidth: 200.0,
        ),
        child: Text(
          tableData[index]['username'].toString(),
          textAlign: TextAlign.center,
        ),
      )),
      DataCell(ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 100.0,
          maxWidth: 100.0,
        ),
        child: Text(
          tableData[index]['stockworth'].toString(),
          textAlign: TextAlign.center,
        ),
      )),
      DataCell(ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 100.0,
          maxWidth: 100.0,
        ),
        child: Text(
          tableData[index]['totalworth'].toString(),
          textAlign: TextAlign.center,
        ),
      )),
    ]);
  }
}
