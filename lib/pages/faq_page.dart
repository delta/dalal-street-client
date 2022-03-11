import 'dart:convert';

import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/services.dart' as rootBundle;

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Responsive(
            mobile: _mobileBody(),
            tablet: _tabletBody(),
            desktop: _desktopBody(),
          ),
        ),
      ),
    );
  }

  Center _tabletBody() {
    return const Center(
      child: Text(
        'Tablet UI will design soon :)',
        style: TextStyle(
          fontSize: 16,
          color: secondaryColor,
        ),
      ),
    );
  }

  Center _desktopBody() {
    return const Center(
      child: Text(
        'Desktop UI will design soon :)',
        style: TextStyle(
          fontSize: 16,
          color: secondaryColor,
        ),
      ),
    );
  }

  Widget _mobileBody() {
    String? question = '';
    String? answer = '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: background2),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage('assets/images/faqPage.png')),
                    Flexible(
                      child: Column(
                        children: const [
                          Text(
                            'Have Questions?',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Mr Bull has got exceptional answers for you!',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
          const SizedBox(height: 20),
          FutureBuilder(
            future: ReadJsonData(),
            builder: (context, data) {
              if (data.hasError) {
                return const Center(child: Text('Some error occured'));
              } else if (data.hasData) {
                var items = data.data as List<FAQDataModel>;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                color: background2),
                            child: ElevatedButton(
                                onPressed: () => {
                                      question = items[index].question,
                                      answer = items[index].answer,
                                      openBottomSheet(question!, answer!),
                                    },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          background2),
                                  textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                          const TextStyle(
                                              fontWeight: FontWeight.normal)),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(items[index].question ?? ' ',
                                            style: const TextStyle(
                                                fontSize: 16, color: white),
                                            textAlign: TextAlign.start),
                                        const SizedBox(height: 10),
                                        Text(items[index].question ?? ' ',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: whiteWithOpacity75),
                                            textAlign: TextAlign.start),
                                      ],
                                    ))),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  openBottomSheet(String question, String answer) {
    showModalBottomSheet(
        backgroundColor: background2,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Wrap(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                width: 150,
                                height: 4.5,
                                decoration: const BoxDecoration(
                                  color: lightGray,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                )),
                            const SizedBox(height: 15),
                            Text(
                              question,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              answer,
                              style:
                                  const TextStyle(fontSize: 16, color: white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          );
        });
  }
}

class FAQDataModel {
  String? question;
  String? answer;

  FAQDataModel({this.question, this.answer});

  FAQDataModel.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
  }
}

Future<List<FAQDataModel>> ReadJsonData() async {
  final jsondata = await rootBundle.rootBundle.loadString('faqs.json');

  final list = json.decode(jsondata) as List<dynamic>;

  return list.map((e) => FAQDataModel.fromJson(e)).toList();
}
