import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

Container rankContainer(int myRank) {
  return Container(
      padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 15),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)),
          color: background2),
      width: double.infinity,
      child: Row(children: [
        const Padding(padding: EdgeInsets.all(10)),
        const Text(
          'My Rank   ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          myRank.toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ]));
}
