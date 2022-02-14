import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

Container topContainer(List<Map<String, String>> tabledata) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      color: background2,
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
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: silver, width: 4),
                            image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/placeholder.png'),
                                fit: BoxFit.fill))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: silver, width: 2),
                            color: background2),
                        child: const Text(
                          '2',
                          style: TextStyle(
                              color: silver, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 130.0),
                    child: Column(
                      children: [
                        Text(
                          tabledata[1]['username'].toString(),
                          style: const TextStyle(color: silver),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          tabledata[1]['totalworth'].toString(),
                          style: const TextStyle(color: silver),
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
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: gold, width: 3),
                            image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/placeholder.png'),
                                fit: BoxFit.fill))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 140),
                    child: Image.asset('assets/images/crown.png',
                        width: 50, height: 50),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: gold, width: 2),
                            color: background2),
                        child: const Text(
                          '1',
                          style: TextStyle(
                              color: gold, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 130.0),
                    child: Column(
                      children: [
                        Text(
                          tabledata[0]['username'].toString(),
                          style: const TextStyle(color: gold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          tabledata[0]['totalworth'].toString(),
                          style: const TextStyle(color: gold),
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
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: bronze, width: 4),
                            image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/placeholder.png'),
                                fit: BoxFit.fill))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: bronze, width: 2),
                            color: background2),
                        child: const Text(
                          '3',
                          style: TextStyle(
                              color: bronze, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 130.0),
                    child: Column(
                      children: [
                        Text(
                          tabledata[2]['username'].toString(),
                          style: const TextStyle(color: bronze),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          tabledata[2]['totalworth'].toString(),
                          style: const TextStyle(color: bronze),
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
