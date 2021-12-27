// ignore_for_file: must_call_super
import 'package:dalal_street_client/blocs/market_depth/market_depth_bloc.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/components/buttons/primary_button.dart';
import 'package:dalal_street_client/components/buttons/secondary_button.dart';
<<<<<<< HEAD
import 'package:dalal_street_client/config/get_it.dart';
=======
import 'package:dalal_street_client/components/buttons/tertiary_button.dart';
import 'package:dalal_street_client/constants/constants.dart';
>>>>>>> [feat]: Add Trade Page as a Bottom Sheet
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/datastreams/MarketDepth.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat('#,##0.00', 'en_US');

class CompanyPage extends StatefulWidget {
  final int stockId;
  const CompanyPage({Key? key, required this.stockId}) : super(key: key);

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  initState() {
    super.initState();
    // Subscribe to the stream of Market Depth Updates
    context.read<SubscribeCubit>().subscribe(DataStreamType.MARKET_DEPTH);
  }

  @override
  Widget build(BuildContext context) {
    final stockList = getIt<Map<int, Stock>>();
    Stock company = stockList[widget.stockId]!;
    return SafeArea(
      child: Responsive(
        mobile: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        _companyPrices(company),
                        const SizedBox(
                          height: 10,
                        ),
                        _companyTabView(context, company)
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  decoration: const BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      )),
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: PrimaryButton(
                      height: 45,
                      width: 340,
                      fontSize: 18,
                      title: 'Place Order',
                      onPressed: () {
                        _chooseBuyOrSellBottomSheet(context, company);
                      },
                    ),
                  ),
                ),
              ],
            )),
        tablet: Container(),
        desktop: Container(),
      ),
    );
  }
}

_tradingBottomSheet(BuildContext context, Stock company, String orderType) {
  int priceChange = (company.currentPrice - company.previousDayClose).toInt();
  int quantity = 1;
  int totalPrice = company.currentPrice.toInt() * quantity;
  int orderFee = _calculateOrderFee(totalPrice);
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return BottomSheet(
          backgroundColor: backgroundColor,
          builder: (context) {
            List<String> priceTypeMap = ['Limit', 'Market', 'Stop'];
            var selectedPriceType = 'Limit';
            var orderPriceWindow = _showPriceWindow(totalPrice);
            return StatefulBuilder(builder:
                (BuildContext context, StateSetter setBottomSheetState) {
              return Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 150,
                          height: 4.5,
                          decoration: const BoxDecoration(
                            color: lightGray,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          )),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(AppIcons().crossWhite)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        company.shortName,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Wrap(
                                        spacing: 4,
                                        children: [
                                          Text(
                                            oCcy
                                                .format(company.currentPrice)
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            priceChange >= 0
                                                ? '+' +
                                                    oCcy
                                                        .format(priceChange)
                                                        .toString()
                                                : oCcy
                                                    .format(priceChange)
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: priceChange > 0
                                                  ? secondaryColor
                                                  : heartRed,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                                SecondaryButton(
                                  height: 25,
                                  width: 135,
                                  fontSize: 14,
                                  title: 'Order Type: ' + orderType,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Number of Stocks',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    height: 30,
                                    child: SpinBox(
                                      min: 1,
                                      max: 100,
                                      value: 01,
                                      onChanged: (value) {
                                        setBottomSheetState(() {
                                          quantity = value.toInt();
                                          totalPrice =
                                              company.currentPrice.toInt() *
                                                  quantity;
                                          orderPriceWindow =
                                              _showPriceWindow(totalPrice);
                                          orderFee =
                                              _calculateOrderFee(totalPrice);
                                        });
                                      },
                                      cursorColor: primaryColor,
                                      iconColor: MaterialStateProperty.all(
                                          primaryColor),
                                    ),
                                  )
                                ]),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    spacing: 15,
                                    children: [
                                      const Text(
                                        'Price',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      DropdownButton(
                                        value: selectedPriceType,
                                        onChanged: (newValue) {
                                          setBottomSheetState(() {
                                            selectedPriceType =
                                                newValue.toString();
                                            logger.i(selectedPriceType);
                                          });
                                        },
                                        items: priceTypeMap.map((type) {
                                          return DropdownMenuItem(
                                            child: Text(
                                              type,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: whiteWithOpacity75),
                                            ),
                                            value: type,
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '₹' +
                                            oCcy.format(totalPrice).toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: primaryColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        orderPriceWindow,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: bronze,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Order Fee',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '₹' + oCcy.format(orderFee).toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: primaryColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    AppIcons().balance,
                                  ),
                                  const Text(
                                    ' Balance :',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    ' ₹' +
                                        oCcy
                                            .format(company.currentPrice)
                                            .toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ]),
                            const SizedBox(
                              height: 25,
                            ),
                            PrimaryButton(
                              height: 45,
                              width: 340,
                              fontSize: 18,
                              title: 'Place Order',
                              onPressed: () {
                                _chooseBuyOrSellBottomSheet(context, company);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          },
          onClosing: () {},
        );
      });
}

int _calculateOrderFee(int totalPrice) {
  var orderFee = (ORDER_FEE_RATE * totalPrice);
  return orderFee.toInt();
}

String _showPriceWindow(int currentPrice) {
  var lowerLimit =
      currentPrice.toDouble() * (1 - ORDER_PRICE_WINDOW.toDouble() / 100);
  var higherLimit =
      currentPrice.toDouble() * (1 + ORDER_PRICE_WINDOW.toDouble() / 100);

  return 'Between ₹' +
      lowerLimit.toStringAsFixed(2) +
      ' and ₹' +
      higherLimit.toStringAsFixed(2);
}

_chooseBuyOrSellBottomSheet(BuildContext context, Stock company) {
  int priceChange = (company.currentPrice - company.previousDayClose).toInt();
  showModalBottomSheet(
      backgroundColor: backgroundColor,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Wrap(
          children: [
            SizedBox(
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 150,
                            height: 4.5,
                            decoration: const BoxDecoration(
                              color: lightGray,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        company.shortName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        company.fullName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: whiteWithOpacity50,
                                        ),
                                      ),
                                    ]),
                              ),
                              Column(
                                children: [
                                  Text(
                                    oCcy
                                        .format(company.currentPrice)
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    priceChange >= 0
                                        ? '+' +
                                            oCcy.format(priceChange).toString()
                                        : oCcy.format(priceChange).toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: priceChange > 0
                                          ? secondaryColor
                                          : heartRed,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SecondaryButton(
                                height: 50,
                                width: 150,
                                title: 'Sell',
                                fontSize: 18,
                                onPressed: () {
                                  Navigator.pop(context);
                                  _tradingBottomSheet(context, company, 'Sell');
                                },
                              ),
                              TertiaryButton(
                                height: 50,
                                width: 150,
                                title: 'Buy',
                                fontSize: 18,
                                onPressed: () {
                                  Navigator.pop(context);
                                  _tradingBottomSheet(context, company, 'Buy');
                                },
                              ),
                            ]),
                      ],
                    )),
              ),
            ),
          ],
        );
      });
}

Container _companyTabView(BuildContext context, Stock company) {
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: lightGray,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Tab(
                  child: Text(
                    'Market Depth',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: lightGray,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Tab(
                  child: Text(
                    'News',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: lightGray,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
              indicatorColor: lightGray,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: MediaQuery.of(context).size.height * 0.8,
              child: TabBarView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    _overView(company),
                    _marketDepth(company),
                    _news()
                  ]),
            )
          ],
        ),
      ));
}

Container _companyPrices(Stock company) {
  var priceChange =
      company.currentPrice.toInt() - company.previousDayClose.toInt();
  var priceChangePercentage =
      priceChange.toInt() / company.previousDayClose.toInt();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      'https://i.imgur.com/v5E2Cv7.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      company.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '₹ ' + oCcy.format(company.currentPrice).toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      priceChange >= 0
                          ? '+' +
                              oCcy.format(priceChange).toString() +
                              '  (+' +
                              (priceChangePercentage * 100).toStringAsFixed(2) +
                              '%)'
                          : oCcy.format(priceChange).toString() +
                              '  (' +
                              (priceChangePercentage * 100).toStringAsFixed(2) +
                              '%)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: priceChange > 0 ? secondaryColor : heartRed,
                      ),
                    ),
                  ],
                ),
                SecondaryButton(
                  height: 25,
                  width: 135,
                  fontSize: 14,
                  title: company.shortName,
                  onPressed: () {},
                ),
              ],
            ),
            _companyGraph()
          ]));
}

// TODO : Add Graph
Image _companyGraph() => Image.network('https://i.imgur.com/Y6CBCX2.png');

Container _news() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      'Recent News',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: white.withOpacity(0.75),
      ),
      textAlign: TextAlign.start,
    ),
  );
}

Widget _marketDepth(Stock company) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text(
            'Bid Depth',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: white),
            textAlign: TextAlign.start,
          ),
          Text(
            'Ask Depth',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: white),
            textAlign: TextAlign.start,
          ),
        ],
      ),
      BlocBuilder<SubscribeCubit, SubscribeState>(
        builder: (context, state) {
          if (state is SubscriptionDataLoaded) {
            logger.i(state.subscriptionId);
            // Start the stream of Market Depths
            context
                .read<MarketDepthBloc>()
                .add(SubscribeToMarketDepthUpdates(state.subscriptionId));
            List<MarketDepthUpdate> marketDepthUpdates = [];
            return BlocBuilder<MarketDepthBloc, MarketDepthState>(
              builder: (context, state) {
                if (state is SubscriptionToMarketDepthSuccess) {
                  logger.i(state.marketDepthUpdate.toString());
                  if (state.marketDepthUpdate.stockId == company.id) {
                    marketDepthUpdates.add(state.marketDepthUpdate);
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text('Volume'),
                          ),
                          DataColumn(
                            label: Text('Price'),
                          ),
                          DataColumn(
                            label: Text('Volume'),
                          ),
                          DataColumn(
                            label: Text('Price'),
                          ),
                        ],
                        rows: buildRowsOfMarketDepth(marketDepthUpdates),
                      ),
                    ),
                  );
                } else if (state is SubscriptionToMarketDepthFailed) {
                  return Center(
                    child: Text(
                      'Failed to load data \nReason : ${state.error}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: secondaryColor,
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }
              },
            );
          } else if (state is SubscriptonDataFailed) {
            return Center(
              child: Text(
                'Failed to load data \nReason : ${state.message}',
                style: const TextStyle(
                  fontSize: 14,
                  color: secondaryColor,
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
        },
      ),
    ],
  );
}

List<DataRow> buildRowsOfMarketDepth(
    List<MarketDepthUpdate> marketDepthUpdates) {
  return marketDepthUpdates.map((marketDepth) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            marketDepth.bidDepth.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: white,
            ),
          ),
        ),
        DataCell(
          Text(
            marketDepth.bidDepthDiff.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: white,
            ),
          ),
        ),
        DataCell(
          Text(
            marketDepth.askDepth.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: white,
            ),
          ),
        ),
        DataCell(
          Text(
            marketDepth.askDepthDiff.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: white,
            ),
          ),
        ),
      ],
    );
  }).toList();
}

Column _overView(Stock company) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 15,
      ),
      const Text(
        'About Company',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: white,
        ),
        textAlign: TextAlign.start,
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        company.description.toString(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: lightGray,
        ),
        textAlign: TextAlign.start,
      ),
      const SizedBox(
        height: 30,
      ),
      const Text(
        'Market Status',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: lightGray,
        ),
        textAlign: TextAlign.start,
      ),
      marketStatusTile(AppIcons.currentPrice, 'Current Price',
          oCcy.format(company.currentPrice).toString(), false),
      marketStatusTile(AppIcons.dayHigh, 'Day High',
          oCcy.format(company.dayHigh).toString(), false),
      marketStatusTile(AppIcons.dayHigh, 'Day Low',
          oCcy.format(company.dayLow).toString(), true),
      marketStatusTile(AppIcons.alltimeHigh, 'All Time High',
          oCcy.format(company.allTimeHigh).toString(), false),
      marketStatusTile(AppIcons.alltimeHigh, 'All Time Low',
          oCcy.format(company.allTimeLow).toString(), true),
    ],
  );
}

Widget marketStatusTile(String icon, String name, String value, bool isRed) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          spacing: 14,
          children: [
            SvgPicture.asset(
              icon,
              width: 18,
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: white,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        Text(
          '₹ ' + value,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: !isRed ? primaryColor : heartRed),
          textAlign: TextAlign.start,
        ),
      ],
    ),
  );
}
