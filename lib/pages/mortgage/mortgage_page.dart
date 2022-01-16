import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/pages/mortgage/components/stock_mortgage_item.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:flutter/material.dart';

class MortgagePage extends StatefulWidget {
  const MortgagePage({Key? key}) : super(key: key);

  @override
  _MortgagePageState createState() => _MortgagePageState();
}

class _MortgagePageState extends State<MortgagePage> {
  Map<int, Stock> mapOfStocks = getIt<GlobalStreams>().latestStockMap;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: _mortgageBody(),
    );
  }

  Widget _mortgageBody() => ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: mapOfStocks.length,
        itemBuilder: (context, index) {
          Stock? company = mapOfStocks[index + 1];
          int currentPrice = mapOfStocks[index + 1]?.currentPrice.toInt() ?? 0;
          return MortgageStockItem(
              company: company ?? Stock(),
              stockId: index + 1,
              currentPrice: currentPrice);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 10,
          );
        },
      );
}