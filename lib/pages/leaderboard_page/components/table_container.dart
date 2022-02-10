import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

Widget table(
  List<Map<String, String>> tableData,
) =>
    Expanded(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)),
          color: background2,
        ),
        width: double.infinity,
        child: Expanded(
          child: ListView.builder(
              itemCount: tableData.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: double.infinity,
                  child: ListTile(
                    onTap: null,
                    visualDensity: const VisualDensity(vertical: -2),
                    title: Row(
                      children: <Widget>[
                        const Padding(padding: EdgeInsets.all(10)),
                        Expanded(
                            flex: 1,
                            child: Text(tableData[index]['rank'].toString(),
                                style: const TextStyle(fontSize: 16))),
                        Expanded(
                            flex: 3,
                            child: Text(tableData[index]['username'].toString(),
                                style: const TextStyle(fontSize: 16))),
                        Expanded(
                            flex: 2,
                            child: Text(
                                tableData[index]['totalworth'].toString(),
                                style: const TextStyle(fontSize: 16))),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
