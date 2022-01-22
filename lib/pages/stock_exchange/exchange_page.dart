import 'package:dalal_street_client/blocs/exchange/exchange_cubit.dart';
import 'package:dalal_street_client/components/stock_bar.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/pages/stock_exchange/components/stock_exchange_item.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// todo: navigate to company page on clicking view button
class ExchangePage extends StatefulWidget {
  const ExchangePage({Key? key}) : super(key: key);

  @override
  _ExchangePageState createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage>
    with AutomaticKeepAliveClientMixin {
  Map<int, Stock> mapOfStocks = getIt<GlobalStreams>().latestStockMap;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<ExchangeCubit>().listenToExchangeStream(mapOfStocks);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                const StockBar(),
                const SizedBox(
                  height: 10,
                ),
                _companiesExchange(),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _companiesExchange() => Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delta Stock Exchange',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w500, color: lightGray),
              textAlign: TextAlign.end,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Companies in DSE',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: white,
              ),
              textAlign: TextAlign.end,
            ),
            const SizedBox(
              height: 20,
            ),
            _exchangeBody(),
          ],
        ),
      );

  Widget _exchangeBody() => ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: mapOfStocks.length,
        itemBuilder: (context, index) {
          Stock? company = mapOfStocks[index + 1];
          int currentPrice = mapOfStocks[index + 1]?.currentPrice.toInt() ?? 0;
          return StockExchangeItem(
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
