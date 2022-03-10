import 'package:dalal_street_client/pages/company_page/components/overview.dart';
import 'package:dalal_street_client/pages/company_page/components/market_depth.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

// ignore: must_be_immutable
class CompanyTabView extends StatefulWidget {
  Stock company;
  CompanyTabView({Key? key, required this.company}) : super(key: key);

  @override
  State<CompanyTabView> createState() => _CompanyTabViewState();
}

class _CompanyTabViewState extends State<CompanyTabView>
    with SingleTickerProviderStateMixin {
  final _key1 = GlobalKey();
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context)!.startShowCase(
        [_key1],
      ),
    );
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
              tabs: [
                const Tab(
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
                Showcase(
                  key: _key1,
                  title: 'Market Depth',
                  description:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
                  child: const Tab(
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
                    marketDepth(widget.company),
                  ]),
            ),
          ],
        ));
  }
}
