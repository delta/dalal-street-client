import 'package:flutter/material.dart';

ListTile tableHeader() {
  return ListTile(
      // visualDensity: const VisualDensity(vertical: -3),
      // tileColor: background2,
      title: Row(
    children: const <Widget>[
      Padding(padding: EdgeInsets.all(10)),
      Expanded(
        flex: 1,
        child: Text('Rank',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      Expanded(
        flex: 3,
        child: Text('Username',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      Expanded(
        flex: 2,
        child: Text('Net Worth',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      )
    ],
  ));
}
