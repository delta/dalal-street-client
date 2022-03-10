import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class MediaPartners extends StatelessWidget {
  const MediaPartners({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(
                child: SingleChildScrollView(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                            color: background2,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            const SizedBox.square(dimension: 10),
                            const Text(
                              'Media Partners',
                              style: TextStyle(fontSize: 24, color: white),
                            ),
                            const SizedBox.square(dimension: 20),
                            Card(
                              elevation: 10,
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                      'assets/images/StartupNews_logo.png',
                                      width: 300,
                                      height: 150,
                                      fit: BoxFit.contain)),
                              color: white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            const SizedBox.square(dimension: 50),
                            Card(
                                elevation: 10,
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.asset(
                                        'assets/images/logo_dalalstreet.png',
                                        width: 300,
                                        height: 150,
                                        fit: BoxFit.contain)),
                                color: white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                )),
                            const SizedBox.square(dimension: 50),
                            Card(
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                      'assets/images/VB_Global_Kannadiga_Logo.png',
                                      width: 300,
                                      height: 150,
                                      fit: BoxFit.contain),
                                ),
                                color: white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ))
                          ],
                        ))))));
  }
}
