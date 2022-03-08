import 'package:dalal_street_client/pages/company_page/components/overview.dart';
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
              child: TabBar(
                controller: _controller,
                tabs: const [
                  Tab(
                    child: Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: lightGray,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Market Depth',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: lightGray,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
                indicatorColor: lightGray,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
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
