import 'package:dalal_street_client/pages/company_page/components/market_depth.dart';
import 'package:dalal_street_client/pages/company_page/components/overview_web.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CompanyTabViewWeb extends StatefulWidget {
  Stock company;
  CompanyTabViewWeb({Key? key, required this.company}) : super(key: key);

  @override
  State<CompanyTabViewWeb> createState() => _CompanyTabViewWebState();
}

class _CompanyTabViewWebState extends State<CompanyTabViewWeb>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: background2,
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  TabBar(
                    indicatorColor: white,
                    indicatorWeight: 4,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 2.5,
                        color: white,
                      ),
                      insets: EdgeInsets.symmetric(horizontal: 32.0),
                    ),
                    labelPadding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    isScrollable: true,
                    controller: _controller,
                    labelColor: white,
                    labelStyle: TextStyle(fontWeight: FontWeight.w800),
                    unselectedLabelColor: blurredGray,
                    unselectedLabelStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                    tabs: const [
                      Tab(
                        child: Text(
                          'Overview',
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Market Depth',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: TabBarView(
                  controller: _controller,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: <Widget>[
                    overViewWeb(widget.company, context),
                    marketDepth(widget.company),
                  ]),
            ),
          ],
        ));
  }
}
