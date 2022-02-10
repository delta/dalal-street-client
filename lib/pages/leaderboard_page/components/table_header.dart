import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

Widget tableHeader() {
  return Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      color: background2,
    ),
    child: SizedBox(
      width: double.infinity,
      child: Center(
        child: ListTile(
            title: Row(
          children: const <Widget>[
            Padding(padding: EdgeInsets.all(10)),
            Expanded(
              flex: 1,
              child: Text('Rank',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
              child: Text('Name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 2,
              child: Text('Stock Worth',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 2,
              child: Text('Net Worth',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            )
          ],
        )),
      ),
    ),
  );
}
