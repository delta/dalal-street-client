import 'package:flutter/material.dart';

Widget table(List<Map<String, String>> tableData,
        ScrollController _scrollcontroller) =>
    Expanded(
      child: ListView.builder(
          itemCount: tableData.length,
          controller: _scrollcontroller,
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
                        child: Text(tableData[index]['totalworth'].toString(),
                            style: const TextStyle(fontSize: 16))),
                  ],
                ),
              ),
            );
          }),
    );
