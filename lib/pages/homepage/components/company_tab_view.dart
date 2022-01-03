import 'package:dalal_street_client/pages/homepage/components/news.dart';
import 'package:dalal_street_client/pages/homepage/components/overview.dart';
import 'package:dalal_street_client/pages/homepage/components/market_depth.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

Container companyTabView(BuildContext context, Stock company) {
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: lightGrey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Tab(
                  child: Text(
                    'Market Depth',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: lightGrey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Tab(
                  child: Text(
                    'News',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: lightGrey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
              indicatorColor: lightGray,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: MediaQuery.of(context).size.height * 0.8,
              child: TabBarView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [overView(company), marketDepth(company), news()]),
            )
          ],
        ),
      ));
}
