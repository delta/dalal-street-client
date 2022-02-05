import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class NewsDetail extends StatelessWidget {
  final String text;
  final String imagePath;
  final String headline;
  final String dur;
  const NewsDetail(
      {Key? key,
      required this.text,
      required this.imagePath,
      required this.headline,
      required this.dur})
      : super(key: key);

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
                  'News',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: whiteWithOpacity75),
                  textAlign: TextAlign.left,
                )),
            Center(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(imagePath),
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.2,
              ),
            )),
            Padding(
                padding: const EdgeInsets.all(15),
                child: Text('Published on ' + dur,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: lightGray,
                        fontSize: 12))),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                headline,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 16, color: lightGray),
              ),
            )
          ]),
    )));
  }
}
