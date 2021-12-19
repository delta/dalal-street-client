import 'package:dalal_street_client/blocs/companies/companies_bloc.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:intl/intl.dart';

// ignore: unnecessary_new
final oCcy = new NumberFormat('#,##0.00', 'en_US');

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    // Get List of Stocks
    BlocProvider.of<CompaniesBloc>(context).add(const GetStockList());
    // Subscribe to the stream of Stock Prices
    context.read<SubscribeCubit>().subscribe(DataStreamType.STOCK_PRICES);
    // TODO : Subscribe to the stream of News and Prices Graph
  }

// TODO : Remove print statements
  @override
  Widget build(context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Resposive(
          mobile: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    color: backgroundColor2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Home',
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
                          'Top Companies',
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
                        BlocBuilder<CompaniesBloc, CompaniesState>(
                          builder: (context, state) {
                            if (state is GetCompaniesSuccess) {
                              var mapOfStocks = state.stockList.stockList;
                              return BlocBuilder<SubscribeCubit,
                                  SubscribeState>(builder: (context, state) {
                                if (state is SubscriptionDataLoaded) {
                                  SubscriptionId subscriptionId =
                                      state.subscriptionId;
                                  // Start the stream of Stock Prices
                                  context.read<CompaniesBloc>().add(
                                      SubscribeToStockPrices(subscriptionId));
                                } else if (state is SubscriptonDataFailed) {
                                  // ignore: avoid_print
                                  print('Stock Prices Stream Failed $state');
                                }

                                return Expanded(
                                  child: ListView.builder(
                                    itemCount: mapOfStocks.length,
                                    itemBuilder: (context, index) {
                                      Stock? company = mapOfStocks[index];
                                      int currentPrice =
                                          company?.currentPrice.toInt() ?? 0;
                                      int previousDayPrice =
                                          company?.previousDayClose.toInt() ??
                                              0;
                                      var priceChange =
                                          (currentPrice - previousDayPrice);
                                      return Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          company?.shortName ??
                                                              'Airtel',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        Text(
                                                          company?.fullName ??
                                                              'Airtel Pvt Ltd',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                whiteWithOpacity50,
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                                Expanded(
                                                  child: Image.network(
                                                      'https://i.imgur.com/zrmdl8j.png'),
                                                ),
                                                Expanded(
                                                  child: BlocBuilder<
                                                      CompaniesBloc,
                                                      CompaniesState>(
                                                    builder: (context, state) {
                                                      if (state
                                                          is SubscriptionToStockPricesSuccess) {
                                                        var currentStockPrice =
                                                            state.stockPrices
                                                                .prices[index];
                                                        // ignore: avoid_print
                                                        print(
                                                            state.stockPrices);
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              oCcy
                                                                  .format(
                                                                      currentStockPrice)
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            Text(
                                                              priceChange >= 0
                                                                  ? '+' +
                                                                      oCcy
                                                                          .format(
                                                                              priceChange)
                                                                          .toString()
                                                                  : oCcy
                                                                      .format(
                                                                          priceChange)
                                                                      .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: priceChange >
                                                                        0
                                                                    ? secondaryColor
                                                                    : heartRed,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      } else if (state
                                                          is SubscriptionToStockPricesFailed) {
                                                        return const Center(
                                                          child: Text(
                                                            'Failed to load data \nReason : //',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  secondaryColor,
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              oCcy
                                                                  .format(
                                                                      currentPrice)
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            Text(
                                                              priceChange >= 0
                                                                  ? '+' +
                                                                      oCcy
                                                                          .format(
                                                                              priceChange)
                                                                          .toString()
                                                                  : oCcy
                                                                      .format(
                                                                          priceChange)
                                                                      .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: priceChange >
                                                                        0
                                                                    ? secondaryColor
                                                                    : heartRed,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ]));
                                    },
                                  ),
                                );
                              });
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: secondaryColor,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          tablet: const Center(
            child: Text(
              'Tablet UI will design soon :)',
              style: TextStyle(
                fontSize: 14,
                color: secondaryColor,
              ),
            ),
          ),
          desktop: const Center(
            child: Text(
              'Web UI will design soon :)',
              style: TextStyle(
                fontSize: 14,
                color: secondaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
