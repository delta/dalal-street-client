import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Responsive(
            mobile: _mobileBody(),
            tablet: _desktopBody(),
            desktop: _desktopBody(),
          ),
        ),
      ),
    );
  }

  Center _desktopBody() {
    var screenwidth = MediaQuery.of(context).size.width;
    return Center(
        child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: secondaryColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: _mobileBody(),
      margin: EdgeInsets.fromLTRB(screenwidth * 0.35, screenwidth * 0.03,
          screenwidth * 0.35, screenwidth * 0.1),
    ));
  }

  Widget _mobileBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Do you need help?',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Our Mr Bull is standing here for your service and support',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () => {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('How to play?',
                            style: TextStyle(fontSize: 20, color: primaryColor),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text('Play tutorial for Dalal Street game',
                            style: TextStyle(fontSize: 18, color: white),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/faqs');
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('FAQs',
                            style: TextStyle(fontSize: 20, color: primaryColor),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text('Find brilliant answers instantly',
                            style: TextStyle(fontSize: 18, color: white),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: background2),
                child: ElevatedButton(
                  onPressed: () {
                    launch('https://discord.gg/Qz8QBvgs8H');
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(background2),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Community',
                            style: TextStyle(fontSize: 20, color: primaryColor),
                            textAlign: TextAlign.start),
                        SizedBox(height: 10),
                        Text(
                            'Join our official Discord channel to become part of elite community',
                            style: TextStyle(fontSize: 18, color: white),
                            textAlign: TextAlign.start),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
