import 'package:dalal_street_client/faq.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<bool> isOpen = List<bool>.generate(faq.length, (_) => false);

  List<ExpansionPanel> get expansionList => faq
      .map(
        (question, answer) => MapEntry(
          question,
          ExpansionPanel(
            backgroundColor: background2,
            canTapOnHeader: true,
            isExpanded: isOpen[faq.keys.toList().indexOf(question)],
            headerBuilder: (context, isOpen) => Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                child: Text(question),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: MarkdownBody(
                data: answer,
                onTapLink: (text, href, title) {
                  if (href != null) onMdLinkClick(href);
                },
              ),
            ),
          ),
        ),
      )
      .values
      .toList();

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

  void onMdLinkClick(String url) => launch(url);
}
