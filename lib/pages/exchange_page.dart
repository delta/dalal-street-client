import 'package:dalal_street_client/blocs/exchange/exchange_cubit.dart';
import 'package:dalal_street_client/blocs/exchange/sheet/exchange_sheet_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/global_streams.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/buttons.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat('#,##0.00', 'en_US');

// todo: UI similar to figma mock up
class ExchangePage extends StatefulWidget {
  const ExchangePage({Key? key}) : super(key: key);

  @override
  _ExchangePageState createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  Map<int, Stock> mapOfStocks = getIt<GlobalStreams>().stockList;

  @override
  void initState() {
    super.initState();
    context.read<ExchangeCubit>().listenToExchangeStream(mapOfStocks);
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
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
              'Stock Exchange',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: whiteWithOpacity75),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Companies',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: white,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 20,
            ),
            _exchangeBody(),
          ],
        ),
      );

  Widget _exchangeBody() => ListView.builder(
        shrinkWrap: true,
        itemCount: mapOfStocks.length,
        itemBuilder: (context, index) {
          Stock? company = mapOfStocks[index + 1];
          int currentPrice = mapOfStocks[index + 1]?.currentPrice.toInt() ?? 0;
          int previousDayPrice = company?.previousDayClose.toInt() ?? 0;
          var priceChange = (currentPrice - previousDayPrice);
          return _stockExchangeItem(
            company,
            index + 1,
            priceChange,
            currentPrice,
          );
        },
      );

  Widget _stockExchangeItem(
    Stock? company,
    int index,
    int priceChange,
    int currentPrice,
  ) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              _stockNames(company),
              _stockGraph(),
              _stockPrices(
                index,
                priceChange,
                currentPrice,
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            _stockExchangeDetails(index, company),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: secondaryButtonStyle,
                    onPressed: () {},
                    child: const Text('View'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showModalSheet(
                        index, company?.fullName ?? 'Airtel', currentPrice),
                    child: const Text('Buy'),
                  ),
                ),
              ],
            )
          ],
        ),
      );

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

  Widget _stockGraph() {
    return Expanded(
      child: Image.network(
        'https://i.imgur.com/zrmdl8j.png',
        height: 23,
      ),
    );
  }

  Widget _stockPrices(
    int index,
    int priceChange,
    int currentPrice,
  ) =>
      BlocBuilder<ExchangeCubit, ExchangeState>(
        builder: (context, state) {
          if (state is ExchangeDataLoaded) {
            return Expanded(
              child: () {
                int currentStockPrice =
                    state.exchangeData[index + 1]?.price.toInt() ??
                        mapOfStocks[index]?.currentPrice.toInt() ??
                        0;

                mapOfStocks[index]?.currentPrice = Int64(currentStockPrice);
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
                    const SizedBox(
                      height: 20,
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
    int index,
    Stock? company,
  ) =>
      BlocBuilder<ExchangeCubit, ExchangeState>(
        builder: (context, state) {
          if (state is ExchangeDataLoaded) {
            int stocksInMarket =
                state.exchangeData[index]?.stocksInMarket.toInt() ??
                    (mapOfStocks[index]?.stocksInMarket.toInt() ?? 0);
            mapOfStocks[index]?.stocksInMarket = Int64(stocksInMarket);
            int stocksInExchange =
                state.exchangeData[index]?.stocksInExchange.toInt() ??
                    (mapOfStocks[index]?.stocksInExchange.toInt() ?? 0);
            mapOfStocks[index]?.stocksInExchange = Int64(stocksInExchange);
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(child: Text('Stocks in Market')),
                    const SizedBox(width: 10),
                    Text(stocksInMarket.toString())
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
                    Text(stocksInExchange.toString())
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

  void _showModalSheet(int stockId, String stockName, int currentPrice) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.black38,
        context: context,
        builder: (_) {
          final _controller = TextEditingController();
          return Padding(
            child: BlocProvider(
              create: (context) => ExchangeSheetCubit(),
              child: BlocConsumer<ExchangeSheetCubit, ExchangeSheetState>(
                listener: (context, state) {
                  if (state is ExchangeSheetSuccess) {
                    showSnackBar(
                        context, 'Successfully bought $stockName stocks');
                    Navigator.maybePop(context);
                  } else if (state is ExchangeSheetFailure) {
                    showSnackBar(context, state.msg);
                  }
                },
                builder: (context, state) {
                  if (state is ExchangeSheetLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    );
                  } else if (state is ExchangeSheetFailure) {
                    return Center(
                      child: Text(state.msg),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stockName,
                        style: const TextStyle(
                          fontSize: 26.0,
                        ),
                      ),
                      Text(
                        currentPrice.toString(),
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Number of Stocks',
                              style: TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30.0,
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: 100.0,
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  height: 0.25,
                                  color: Colors.white),
                              controller: _controller,
                              keyboardType: TextInputType.number,
                            ),
                          )
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          int stockQuantity = int.parse(
                              _controller.text == '' ? '0' : _controller.text);

                          if (stockQuantity > 0) {
                            context
                                .read<ExchangeSheetCubit>()
                                .buyStocksFromExchange(stockId, stockQuantity);
                          }
                          _controller.text = '';
                        },
                        child: const Text('Buy Stocks from Exchange'),
                      )
                    ],
                  );
                },
              ),
            ),
            padding: const EdgeInsets.all(20.0),
          );
        });
  }
}
