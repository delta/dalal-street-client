import 'package:dalal_street_client/components/dalal_back_button.dart';
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
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(body: SafeArea(child: () {
      return screenWidth > 1000
          ? Container(
              margin: EdgeInsets.fromLTRB(screenWidth * 0.15,
                  screenWidth * 0.03, screenWidth * 0.15, screenWidth * 0.03),
              decoration: BoxDecoration(
                  color: background2, borderRadius: BorderRadius.circular(10)),
              child: newsDetailColumn(context, true))
          : Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  color: background2, borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(10),
              child: newsDetailColumn(context, false));
    }()));
  }

  Widget newsDetailColumn(BuildContext context, bool isWeb) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox.square(
              dimension: 10,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: DalalBackButton(),
            ),
            const SizedBox.square(
              dimension: 5,
            ),
            Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  'News',
                  style: TextStyle(
                      fontSize: isWeb ? 36 : 18,
                      fontWeight: FontWeight.w500,
                      color: whiteWithOpacity75),
                  textAlign: TextAlign.left,
                )),
            Center(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(imagePath),
                fit: BoxFit.fill,
                width: isWeb
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width * 0.85,
                height: isWeb
                    ? MediaQuery.of(context).size.height * 0.45
                    : MediaQuery.of(context).size.height * 0.25,
              ),
            )),
            Padding(
                padding: const EdgeInsets.fromLTRB(15,15,45,15),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text('Published on ' + dur,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: lightGray,
                          fontSize: 12),textAlign: TextAlign.right,),
                )
                        ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                headline,
                style: TextStyle(
                    fontSize: isWeb ? 24 : 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: isWeb ? 22 : 16, color: lightGray),
              ),
            )
          ]);
}
