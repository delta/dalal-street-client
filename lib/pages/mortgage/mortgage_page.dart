import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/pages/mortgage/components/mortgage_stock_item.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  Widget _mortgageBody() {
    List<Widget> stockMortgageItems = mapOfStocks.entries
        .map((entry) => MortgageStockItem(
            company: entry.value, onViewClicked: _navigateToCompanyPage))
        .toList();
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: mapOfStocks.length,
      itemBuilder: (context, index) => stockMortgageItems[index],
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 10,
        );
      },
    );
  }

  void _navigateToCompanyPage(int stockId) {
    int cash = getIt<GlobalStreams>().dynamicUserInfoStream.value.cash;
    List<int> data = [stockId, cash];
    context.push(
      '/company',
      extra: data,
    );
  }
}
