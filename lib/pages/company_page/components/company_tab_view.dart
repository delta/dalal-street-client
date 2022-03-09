import 'package:dalal_street_client/pages/company_page/components/overview.dart';
import 'package:dalal_street_client/pages/company_page/components/market_depth.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CompanyTabView extends StatefulWidget {
  Stock company;
  CompanyTabView({Key? key, required this.company}) : super(key: key);

  @override
  State<CompanyTabView> createState() => _CompanyTabViewState();
}

class _CompanyTabViewState extends State<CompanyTabView>
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
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        decoration: BoxDecoration(
          color: background2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: TabBarView(
                  controller: _controller,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: <Widget>[
                    overView(widget.company, context),
                    marketDepthMobile(widget.company),
                  ]),
            ),
          ],
        ));
  }
}
