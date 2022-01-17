import 'package:dalal_street_client/components/marquee.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/transformations.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:fixnum/fixnum.dart';

class StockBar extends StatelessWidget {
  const StockBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StockBarMarquee(),
      color: backgroundColor,
      height: 30.0,
      margin: const EdgeInsets.only(bottom: 1.0),
    );
  }
}

class StockBarMarquee extends StatelessWidget {
  StockBarMarquee({Key? key}) : super(key: key);

  final Map<int, Stock> stocks = getIt<GlobalStreams>().stockMapStream.value;
  final stockMapStream = getIt<GlobalStreams>().stockMapStream;

  @override
  Widget build(BuildContext context) {
    var stockBarItemList = <StockBarItem>[];

    stocks.forEach((stockId, stock) => {
          stockBarItemList.add(StockBarItem(
            companyName: stock.fullName.toUpperCase(),
            stockId: stockId,
            previousDayClosePrice: stock.previousDayClose,
            currentPrice: stock.currentPrice,
            stockPriceStream: getStockPriceStream(stockId, stockMapStream),
          ))
        });

    return Marquee(
      child: Row(
        children: [
          const SizedBox(width: 20.0),
          ...stockBarItemList,
          const SizedBox(
            width: 2.0,
          )
        ],
      ),
      pauseDuration: const Duration(milliseconds: 0),
      backDuration: const Duration(milliseconds: 30000),
      animationDuration: const Duration(milliseconds: 30000),
    );
  }
}

class StockBarItem extends StatelessWidget {
  final int stockId;
  final String companyName;
  final Int64 previousDayClosePrice;
  final Int64 currentPrice;
  final Stream<Int64> stockPriceStream;

  const StockBarItem(
      {Key? key,
      required this.stockId,
      required this.companyName,
      required this.previousDayClosePrice,
      required this.currentPrice,
      required this.stockPriceStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          companyName,
          style: const TextStyle(
            fontSize: 13,
            color: white,
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        StreamBuilder<Int64>(
          stream: stockPriceStream,
          initialData: currentPrice,
          builder: (context, state) {
            Int64 stockPrice = state.data!;

            bool isLowOrHigh = stockPrice > previousDayClosePrice;

            double percentageHighOrLow;

            if (previousDayClosePrice == 0) {
              percentageHighOrLow = stockPrice.toDouble();
            } else {
              percentageHighOrLow =
                  ((stockPrice.toDouble() - previousDayClosePrice.toDouble()) /
                      previousDayClosePrice.toDouble());
            }

            return Row(
              children: [
                Text('₹' + oCcy.format(stockPrice).toString(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: whiteWithOpacity50,
                    )),
                const SizedBox(
                  width: 5.0,
                ),
                Text('${oCcy.format(percentageHighOrLow.abs()).toString()}%',
                    style: TextStyle(
                        fontSize: 14,
                        color: isLowOrHigh ? secondaryColor : heartRed)),
                const SizedBox(
                  width: 1.0,
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
        )
      ],
    );
  }
}
