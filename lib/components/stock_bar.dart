import 'package:dalal_street_client/blocs/stock_bar/stockbar_cubit.dart';
import 'package:dalal_street_client/components/marquee.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
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
        height: 100.0,
        margin: const EdgeInsets.only(bottom: 4.0),
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
        children: stockBarItemList,
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

            bool isLowOrHigh = stockPrice >= previousDayClosePrice;

            logger.d(previousDayClosePrice);

            return Row(
              children: [
                Text('$currentPrice',
                    style: const TextStyle(
                      fontSize: 13,
                      color: whiteWithOpacity50,
                    )),
                const SizedBox(
                  width: 5.0,
                ),
                Text('${previousDayClosePrice - stockPrice}',
                    style: TextStyle(
                        fontSize: 13,
                        color: isLowOrHigh ? secondaryColor : heartRed)),
                const SizedBox(
                  width: 5.0,
                ),
                isLowOrHigh
                    ? Image.asset('assets/images/trendingUp.png',
                        width: 8, height: 8)
                    : Image.asset('assets/images/trendingDown.png',
                        width: 8, height: 8),
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

  Int64 modulus(Int64 number) {
    if (number < 0) return -number;

    return number;
  }
}
