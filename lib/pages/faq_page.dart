import 'dart:convert';

import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  Map<String, String> jsonMap = {};
  List<bool> isOpen = [];

  List<ExpansionPanel> get expansionList => jsonMap
      .map(
        (question, answer) => MapEntry(
          question,
          ExpansionPanel(
            backgroundColor: background2,
            canTapOnHeader: true,
            isExpanded: isOpen[jsonMap.keys.toList().indexOf(question)],
            headerBuilder: (context, isOpen) => Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                child: Text(question),
              ),
            ),
            body: Center(child: Text(answer)),
          ),
        ),
      )
      .values
      .toList();

  @override
  void initState() {
    super.initState();
    readFaqFromJson();
  }

  Future<void> readFaqFromJson() async {
    final jsonString = await rootBundle.loadString('faq.json');
    setState(() {
      jsonMap = Map<String, String>.from(jsonDecode(jsonString));
      isOpen = List<bool>.generate(jsonMap.length, (_) => false);
    });
  }

  @override
  build(context) => SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: ExpansionPanelList(
              expansionCallback: onItemClick,
              children: expansionList,
            ),
          ),
        ),
      );

  void onItemClick(int index, bool isExpanded) =>
      setState(() => isOpen[index] = !isExpanded);
}
