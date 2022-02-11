import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class NotifsDetail extends StatelessWidget {
  final int id;
  final int userId;
  final String text;

  const NotifsDetail({
    Key? key,
    required this.id,
    required this.userId,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          color: background2, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox.square(
              dimension: 5,
            ),
            const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Notifications',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: whiteWithOpacity75),
                  textAlign: TextAlign.left,
                )),
            const Padding(
              padding: EdgeInsets.all(15),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Flexible(
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                fit: FlexFit.loose,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 16, color: lightGray),
                ),
                fit: FlexFit.loose,
              ),
            )
          ]),
    )));
  }
}
