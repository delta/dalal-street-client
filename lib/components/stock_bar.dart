import 'package:dalal_street_client/blocs/stock_bar/stockbar_cubit.dart';
import 'package:dalal_street_client/components/marquee.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fixnum/fixnum.dart';

import '../global_streams.dart';

class StockBar extends StatelessWidget {
  const StockBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StockbarCubit(),
      child: Container(
        child: StockBarMarquee(),
        color: backgroundColor,
        height: 30.0,
        margin: const EdgeInsets.only(bottom: 1.0),
      ),
    );
  }
}

class StockBarMarquee extends StatelessWidget {
  StockBarMarquee({Key? key}) : super(key: key);

  final Map<int, Stock> stocks = getIt<GlobalStreams>().stockList;

  @override
  Widget build(BuildContext context) {
    var stockBarItemList = <StockBarItem>[];

    stocks.forEach((i, stock) => {
          stockBarItemList.add(StockBarItem(
              companyName: stock.fullName,
              stockId: i,
              previousDayClosePrice: stock.previousDayClose,
              currentPrice: stock.currentPrice))
        });

    return Marquee(
      child: Row(
        children: [
          const SizedBox(width: 2.0),
          ...stockBarItemList,
          const SizedBox(
            width: 2.0,
          )
        ],
      ),
      pauseDuration: const Duration(milliseconds: 0),
      backDuration: const Duration(milliseconds: 10000),
      animationDuration: const Duration(milliseconds: 10000),
    );
  }
}

class StockBarItem extends StatelessWidget {
  final int stockId;
  final String companyName;
  final Int64 previousDayClosePrice;
  final Int64 currentPrice;

  const StockBarItem(
      {Key? key,
      required this.stockId,
      required this.companyName,
      required this.previousDayClosePrice,
      required this.currentPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          companyName,
          style: const TextStyle(
            fontSize: 13,
            color: whiteWithOpacity75,
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        BlocBuilder<StockbarCubit, StockbarState>(
          builder: (context, state) {
            Int64 stockPrice = currentPrice;
            if (state is StockPriceUpdate) {
              stockPrice = state.stockPrice[stockId]!;
            }

            bool isLowOrHigh = stockPrice > previousDayClosePrice;

            Int64 percentageHighOrLow = previousDayClosePrice == 0
                ? previousDayClosePrice
                : (previousDayClosePrice - stockPrice) ~/ previousDayClosePrice;

            return Row(
              children: [
                Text(oCcy.format(stockPrice).toString(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: whiteWithOpacity50,
                    )),
                const SizedBox(
                  width: 5.0,
                ),
                Text('${oCcy.format(percentageHighOrLow).toString()}%',
                    style: TextStyle(
                        fontSize: 13,
                        color: isLowOrHigh ? secondaryColor : heartRed)),
                const SizedBox(
                  width: 3.0,
                ),
                isLowOrHigh
                    ? Image.asset('assets/images/trendingUp.png',
                        width: 20, height: 20)
                    : Image.asset('assets/images/trendingDown.png',
                        width: 25, height: 25),
                const SizedBox(
                  width: 13.0,
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
