import 'package:dalal_street_client/blocs/companies/companies_bloc.dart';
import 'package:dalal_street_client/blocs/exchange/exchangeStream/exchange_stream_bloc.dart';
import 'package:dalal_street_client/blocs/exchange/exchange_cubit.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/buttons.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/responsive.dart';
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
  Map<int, Stock> mapOfStocks = {};
  // Unsubscribe to the streams when the widget is disposed
  @override
  void dispose() {
    SubscriptionId? _stockPricesExchangeSubscriptionId;
    final state = context.read<SubscribeCubit>().state;
    if (state is SubscriptionDataLoaded) {
      _stockPricesExchangeSubscriptionId = state.subscriptionId;
      context
          .read<SubscribeCubit>()
          .unsubscribe(_stockPricesExchangeSubscriptionId);
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Get List of Stocks
    context.read<CompaniesBloc>().add(const GetStockList());
    // Subscribe to the stream of Stock Exchange Update
    context.read<SubscribeCubit>().subscribe(DataStreamType.STOCK_EXCHANGE);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Responsive(
            mobile: _mobileBody(),
            tablet: _tabletBody(),
            desktop: _desktopBody(),
          ),
        ),
      ),
    );
  }

  Widget _desktopBody() {
    return const Center(
      child: Text(
        'Web UI will design soon :)',
        style: TextStyle(
          fontSize: 14,
          color: secondaryColor,
        ),
      ),
    );
  }

  Widget _tabletBody() {
    return const Center(
      child: Text(
        'Tablet UI will design soon :)',
        style: TextStyle(
          fontSize: 14,
          color: secondaryColor,
        ),
      ),
    );
  }

  Widget _mobileBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          _buildBody(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
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
          _exchangeListBody(),
        ],
      ),
    );
  }

  Widget _exchangeListBody() {
    return BlocBuilder<CompaniesBloc, CompaniesState>(
        builder: (context, state) {
      if (state is GetCompaniesSuccess) {
        mapOfStocks = state.stockList.stockList;
        return BlocBuilder<SubscribeCubit, SubscribeState>(
            builder: (context, state) {
          if (state is SubscriptionDataLoaded) {
            // Start the stream of Stock Prices
            context
                .read<ExchangeStreamBloc>()
                .add(SubscribeToStockExchange(state.subscriptionId));
            return ListView.builder(
              shrinkWrap: true,
              itemCount: mapOfStocks.length,
              itemBuilder: (context, index) {
                Stock? company = mapOfStocks[index + 1];
                int currentPrice = company?.currentPrice.toInt() ?? 0;
                int previousDayPrice = company?.previousDayClose.toInt() ?? 0;
                var priceChange = (currentPrice - previousDayPrice);
                return _exchangeListItem(
                    company, index + 1, priceChange, currentPrice);
              },
            );
          } else if (state is SubscriptonDataFailed) {
            logger.i('Stock Prices Stream Failed $state');
            return const Center(
              child: Text(
                'Failed to load data \nReason : //',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryColor,
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: secondaryColor,
              ),
            );
          }
        });
      } else {
        return const Center(
          child: CircularProgressIndicator(
            color: secondaryColor,
          ),
        );
      }
    });
  }

// Company list item widget for stock exchange
  Widget _exchangeListItem(
      Stock? company, int index, int priceChange, int currentPrice) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            _stockNames(company),
            _stockGraph(),
            _stockPrices(index, priceChange, currentPrice),
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
        ],)
        ]
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

  Widget _stockGraph() {
    return Expanded(
      child: Image.network(
        'https://i.imgur.com/zrmdl8j.png',
        height: 23,
      ),
    );
  }

  Widget _stockPrices(int index, int priceChange, int currentPrice) {
    return Expanded(
      child: BlocBuilder<ExchangeStreamBloc, ExchangeStreamState>(
        builder: (context, state) {
          if (state is SubscriptionToStockExchangeSuccess) {
            int currentStockPrice = state
                    .stockExchangeUpdate.stocksInExchange[index]?.price
                    .toInt() ??
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
          } else if (state is SubscriptionToStockExchangeFailed) {
            return const Center(
              child: Text(
                'Failed to load data \nReason : //',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryColor,
                ),
              ),
            );
          } else {
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
          }
        },
      ),
    );
  }

  Widget _stockExchangeDetails(
    int index,
    Stock? company,
  ) {
    return BlocBuilder<ExchangeStreamBloc, ExchangeStreamState>(
      builder: (context, state) {
        if (state is SubscriptionToStockExchangeSuccess) {
          int stocksInMarket = state
                  .stockExchangeUpdate.stocksInExchange[index]?.stocksInMarket
                  .toInt() ??
              (mapOfStocks[index]?.stocksInMarket.toInt() ?? 0);
          mapOfStocks[index]?.stocksInMarket = Int64(stocksInMarket);
          int stocksInExchange = state
                  .stockExchangeUpdate.stocksInExchange[index]?.stocksInExchange
                  .toInt() ??
              (mapOfStocks[index]?.stocksInExchange.toInt() ?? 0);
          mapOfStocks[index]?.stocksInExchange = Int64(stocksInExchange);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              )
            ],
          );
        } else if (state is SubscriptionToStockExchangeFailed) {
          return const Center(
            child: Text(
              'Failed to load data \nReason : //',
              style: TextStyle(
                fontSize: 14,
                color: secondaryColor,
              ),
            ),
          );
        } else {
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
        }
      },
    );
  }
  // todo: modal sheet UI
  void _showModalSheet(int stockId, String stockName, int currentPrice) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.black38,
        context: context,
        builder: (_) {
          final _controller = TextEditingController();
          return BlocProvider.value(
            value: BlocProvider.of<ExchangeCubit>(context),
            child: Padding(
              child: BlocConsumer<ExchangeCubit, ExchangeState>(
                listener: (context, state) {
                  if (state is ExchangeSuccess) {
                    showSnackBar(
                        context, 'Successfully bought $stockName stocks');
                    Navigator.maybePop(context);
                  } else if (state is ExchangeFailure) {
                    showSnackBar(context, state.msg);
                  }
                },
                builder: (context, state) {
                  if (state is ExchangeLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    );
                  } else if (state is ExchangeFailure) {
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
                                .read<ExchangeCubit>()
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
              padding: const EdgeInsets.all(20.0),
            ),
          );
        });
  }
}
