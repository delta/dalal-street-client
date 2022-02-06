import 'package:dalal_street_client/blocs/exchange/exchange_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/pages/stock_exchange/components/exchange_bottom_sheet.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/streams/transformations.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StockExchangeItem extends StatefulWidget {
  final Stock company;

  const StockExchangeItem({
    Key? key,
    required this.company,
  }) : super(key: key);

  @override
  _StockExchangeItemState createState() => _StockExchangeItemState();
}

class _StockExchangeItemState extends State<StockExchangeItem> {
  Map<int, Stock> mapOfStocks = getIt<GlobalStreams>().latestStockMap;
  final stockMapStream = getIt<GlobalStreams>().stockMapStream;
  @override
  Widget build(BuildContext context) {
    int previousDayClose = widget.company.previousDayClose.toInt();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: background2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _stockNames(widget.company),
            _stockPrices(
              widget.company.id,
              previousDayClose,
              widget.company.currentPrice.toInt(),
            ),
          ]),
          const SizedBox(
            height: 10,
          ),
          _stockExchangeDetails(widget.company.id, widget.company),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 40,
                width: 100,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      )),
                      overlayColor: MaterialStateProperty.all(secondaryColor),
                      backgroundColor: MaterialStateProperty.all(
                          primaryColor.withOpacity(0.2))),
                  onPressed: () {
                    int cash =
                        getIt<GlobalStreams>().dynamicUserInfoStream.value.cash;
                    List<int> data = [widget.company.id, cash];
                    Navigator.pushNamed(context, '/company', arguments: data);
                  },
                  child: const Text(
                    'View',
                    style: TextStyle(color: primaryColor, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                height: 40,
                width: 100,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      )),
                      overlayColor: MaterialStateProperty.all(secondaryColor)),
                  onPressed: () => _showModalSheet(widget.company),
                  child: const Text(
                    'Buy',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _stockNames(Stock company) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          company.shortName,
          style: const TextStyle(fontSize: 18, color: white),
        ),
        Text(
          company.fullName,
          style: const TextStyle(
            fontSize: 14,
            color: whiteWithOpacity50,
          ),
        ),
      ]),
    );
  }

  Widget _stockPrices(
    int stockId,
    int previousDayClose,
    int currentPrice,
  ) =>
      Expanded(
        child: StreamBuilder<Int64>(
          stream: stockMapStream.priceStream(stockId),
          initialData: Int64(currentPrice),
          builder: (_, snapshot) {
            int stockPrice = snapshot.data!.toInt();
            int updatedPriceChange = stockPrice - previousDayClose;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹' + oCcy.format(stockPrice).toString(),
                  style: const TextStyle(fontSize: 18, color: white),
                ),
                Text(
                  updatedPriceChange >= 0
                      ? '+' + oCcy.format(updatedPriceChange).toString()
                      : oCcy.format(updatedPriceChange).toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: updatedPriceChange > 0 ? secondaryColor : heartRed,
                  ),
                ),
              ],
            );
          },
        ),
      );

  Widget _stockExchangeDetails(
    int stockId,
    Stock company,
  ) =>
      BlocBuilder<ExchangeCubit, ExchangeState>(
        builder: (context, state) {
          if (state is ExchangeDataLoaded) {
            int stocksInMarket =
                state.exchangeData[stockId]?.stocksInMarket.toInt() ??
                    (mapOfStocks[stockId]?.stocksInMarket.toInt() ?? 0);
            mapOfStocks[stockId]?.stocksInMarket = Int64(stocksInMarket);
            int stocksInExchange =
                state.exchangeData[stockId]?.stocksInExchange.toInt() ??
                    (mapOfStocks[stockId]?.stocksInExchange.toInt() ?? 0);
            mapOfStocks[stockId]?.stocksInExchange = Int64(stocksInExchange);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 14,
                      children: [
                        SvgPicture.asset(
                          AppIcons.stockMarket,
                          width: 18,
                        ),
                        const Text(
                          'Stocks in Market',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: white,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    Text(
                      stocksInMarket.toString(),
                      style: const TextStyle(color: bronze),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 14,
                      children: [
                        SvgPicture.asset(
                          AppIcons.stockExchange,
                          width: 18,
                        ),
                        const Text(
                          'Stocks in Exchange',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: white,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    Text(stocksInExchange.toString(),
                        style: const TextStyle(color: gold))
                  ],
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 14,
                    children: [
                      SvgPicture.asset(
                        AppIcons.stockMarket,
                        width: 18,
                      ),
                      const Text(
                        'Stocks in Market',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Text(company.stocksInMarket.toString(),
                      style: const TextStyle(color: bronze))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 14,
                    children: [
                      SvgPicture.asset(
                        AppIcons.stockMarket,
                        width: 18,
                      ),
                      const Text(
                        'Stocks in Exchange',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Text(company.stocksInExchange.toString(),
                      style: const TextStyle(color: gold))
                ],
              )
            ],
          );
        },
      );

  void _showModalSheet(Stock company) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: background2,
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return ExchangeBottomSheet(company: company);
        });
  }
}
