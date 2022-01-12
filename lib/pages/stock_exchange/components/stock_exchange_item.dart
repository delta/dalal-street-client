import 'package:dalal_street_client/blocs/exchange/exchange_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/pages/stock_exchange/components/exchange_bottom_sheet.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StockExchangeItem extends StatefulWidget {
  final Stock company;
  final int stockId;
  final int priceChange;
  final int currentPrice;

  const StockExchangeItem(
      {Key? key,
      required this.company,
      required this.stockId,
      required this.priceChange,
      required this.currentPrice})
      : super(key: key);

  @override
  _StockExchangeItemState createState() => _StockExchangeItemState();
}

class _StockExchangeItemState extends State<StockExchangeItem> {
  Map<int, Stock> mapOfStocks = getIt<GlobalStreams>().latestStockMap;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: baseColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            _stockNames(widget.company),
            _stockPrices(
              widget.stockId,
              widget.priceChange,
              widget.currentPrice,
            ),
          ]),
          const SizedBox(
            height: 10,
          ),
          _stockExchangeDetails(widget.stockId, widget.company),
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
                  onPressed: () {},
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
                  onPressed: () => _showModalSheet(
                      widget.stockId,
                      widget.company.fullName,
                      widget.currentPrice,
                      widget.company),
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

  Widget _stockNames(Stock? company) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          company?.shortName ?? 'Airtel',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        Text(
          company?.fullName ?? 'Airtel Pvt Ltd',
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
    int priceChange,
    int currentPrice,
  ) =>
      BlocBuilder<ExchangeCubit, ExchangeState>(
        builder: (context, state) {
          if (state is ExchangeDataLoaded) {
            return Expanded(
              child: () {
                int currentStockPrice =
                    state.exchangeData[stockId]?.price.toInt() ??
                        mapOfStocks[stockId]?.currentPrice.toInt() ??
                        0;

                mapOfStocks[stockId]?.currentPrice = Int64(currentStockPrice);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      oCcy.format(currentStockPrice).toString(),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      priceChange >= 0
                          ? '+' + oCcy.format(priceChange).toString()
                          : oCcy.format(priceChange).toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: priceChange > 0 ? secondaryColor : heartRed,
                      ),
                    ),
                  ],
                );
              }(),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                oCcy.format(currentPrice).toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                priceChange >= 0
                    ? '+' + oCcy.format(priceChange).toString()
                    : oCcy.format(priceChange).toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: priceChange > 0 ? secondaryColor : heartRed,
                ),
              ),
            ],
          );
        },
      );

  Widget _stockExchangeDetails(
    int stockId,
    Stock? company,
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(child: Text('Stocks in Market')),
                    const SizedBox(width: 10),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(child: Text('Stocks in Exchange')),
                    const SizedBox(width: 10),
                    Text(stocksInExchange.toString(),
                        style: const TextStyle(color: gold))
                  ],
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: Text('Stocks in Market')),
                  const SizedBox(width: 10),
                  Text(company?.stocksInMarket.toString() ?? '0')
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: Text('Stocks in Exchange')),
                  const SizedBox(width: 10),
                  Text(company?.stocksInExchange.toString() ?? '0')
                ],
              )
            ],
          );
        },
      );

  void _showModalSheet(
      int stockId, String stockName, int currentPrice, Stock? company) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: backgroundColor,
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return ExchangeBottomSheet(company: company ?? Stock());
        });
  }
}
