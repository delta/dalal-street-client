import 'package:flutter/material.dart';
import 'package:dalal_street_client/theme/colors.dart';

Container topContainer(int myRank, List<Map<String, String>> tabledataOverall) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    decoration: BoxDecoration(
      color: background2,
      borderRadius: BorderRadius.circular(10),
    ),
    width: double.infinity,
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            image: const DecorationImage(
                                image: AssetImage(
                                    '../../../assets/images/placeholder.png'),
                                fit: BoxFit.fill))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 105.0, left: 30.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            color: background2),
                        child: const Text(
                          '2',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 130.0),
                    child: Column(
                      children: [
                        Text(
                          tabledataOverall[1]['username'].toString(),
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          tabledataOverall[1]['totalworth'].toString(),
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.yellow, width: 3),
                            image: const DecorationImage(
                                image: AssetImage(
                                    '../../../assets/images/placeholder.png'),
                                fit: BoxFit.fill))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 150, left: 15.0),
                    child: Image.asset('../../../assets/images/crown.png',
                        width: 50, height: 50),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 105.0, left: 30.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.yellow, width: 2),
                            color: background2),
                        child: const Text(
                          '1',
                          style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 130.0),
                    child: Column(
                      children: [
                        Text(
                          tabledataOverall[0]['username'].toString(),
                          style: const TextStyle(color: Colors.yellow),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          tabledataOverall[0]['totalworth'].toString(),
                          style: const TextStyle(color: Colors.yellow),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.red, width: 3),
                            image: const DecorationImage(
                                image: AssetImage(
                                    '../../../assets/images/placeholder.png'),
                                fit: BoxFit.fill))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 105.0, left: 30.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.red, width: 2),
                            color: background2),
                        child: const Text(
                          '3',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 130.0),
                    child: Column(
                      children: [
                        Text(
                          tabledataOverall[2]['username'].toString(),
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          tabledataOverall[2]['totalworth'].toString(),
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
