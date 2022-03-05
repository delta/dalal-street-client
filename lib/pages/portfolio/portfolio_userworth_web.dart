import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/models/dynamic_user_info.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/blocs/portfolio/userWorth/portfolio_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';

class PortfolioUserWorthWeb extends StatefulWidget {
  const PortfolioUserWorthWeb({Key? key}) : super(key: key);

  @override
  _PortfolioUserWorthWebState createState() => _PortfolioUserWorthWebState();
}

class _PortfolioUserWorthWebState extends State<PortfolioUserWorthWeb> {
  Map<int, Stock> mapOfStocks = getIt<GlobalStreams>().latestStockMap;
  final userInfoStream = getIt<GlobalStreams>().dynamicUserInfoStream;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => userWorthWeb();

  Widget userWorthWeb() =>
      BlocBuilder<PortfolioCubit, PortfolioState>(builder: (context, state) {
        if (state is PortfolioLoading) {
          return const Center(
            child: DalalLoadingBar(),
          );
        } else if (state is UserWorthLoaded) {
          return Padding(
            padding: EdgeInsets.only(top: 25),
            child: SizedBox(
              height: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 100),
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: background2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _userWorthDetails()),
                  Container(
                      margin: EdgeInsets.only(right: 100),
                      width: MediaQuery.of(context).size.width * 0.40,
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 15),
                      decoration: BoxDecoration(
                        color: background2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Holdings',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                color: white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _holdings(state),
                          ])),
                ],
              ),
            ),
          );
        } else if (state is UserWorthFailure) {
          return Center(
            child: Text(state.message),
          );
        }
        return const Text('');
      });

  Widget _userWorthDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: background2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: StreamBuilder<DynamicUserInfo>(
        stream: userInfoStream,
        initialData: userInfoStream.value,
        builder: (context, snapshot) {
          dynamic data = snapshot.data!;
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                const Text(
                  'Portfolio',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  children: [
                    const SizedBox(height: 50),
                    _eachField('Cash in Hand', data.cash.toString()),
                    const SizedBox(height: 50),
                    _eachField('Stock Worth', data.stockWorth.toString()),
                    const SizedBox(height: 50),
                    _eachField('Reserved Cash', data.reservedCash.toString()),
                    const SizedBox(height: 50),
                    _eachField('Reserved Stock Worth',
                        data.reservedStocksWorth.toString()),
                    const SizedBox(height: 50),
                    Row(children: [
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      const Text(
                        'Total Worth',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.only(right: 25, top: 5),
                        child: Text(
                          data.totalWorth.toString(),
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: data.totalWorth.toInt() >= 0
                                  ? secondaryColor
                                  : heartRed),
                        ),
                      )
                    ])
                  ],
                ),
              ]);
        },
      ),
    );
  }

  Widget _holdings(UserWorthLoaded state) {
    var stockHeld = <dynamic, dynamic>{};

    Map<int, Int64> stocksReservedMap = state.reservedStocks;
    Map<int, Int64> stocksOwnedMap = state.stocks;
    Map<int, Int64> cashSpentMap = state.cashSpent;

    mapOfStocks.forEach((stockId, value) {
      if (((!stocksReservedMap.containsKey(stockId)) &
              (!stocksOwnedMap.containsKey(stockId))) ||
          ((stocksReservedMap[stockId] == 0) &
              (stocksOwnedMap[stockId] == 0))) {
      } else {
        stockHeld[stockId] = true;
      }
    });
    var keyList = stockHeld.keys.toList();
    return holdinglist(
        stockHeld, keyList, stocksReservedMap, stocksOwnedMap, cashSpentMap);
  }

  Widget holdinglist(
          Map<dynamic, dynamic> stocksHeld,
          List<dynamic> keyList,
          Map<int, Int64> stocksReservedMap,
          Map<int, Int64> stocksOwnedMap,
          Map<int, Int64> cashSpentMap) =>
      Expanded(
          child: 
           RawScrollbar(
            isAlwaysShown: true,
            thumbColor: Color(0xFF388E3C),
            radius: Radius.circular(5.0),
            thickness: 10.0,
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: stocksHeld.length,
              itemBuilder: (context, index) {
                return _eachStock(
                    stocksOwnedMap[keyList[index]],
                    stocksReservedMap[keyList[index]],
                    cashSpentMap[keyList[index]],
                    mapOfStocks[keyList[index]]?.fullName ?? '',
                    mapOfStocks[keyList[index]]?.currentPrice);
              }),),
          
          );

  Widget _eachStock(Int64? owned, Int64? reserved, Int64? cashSpent,
      String name, Int64? price) {
    double avgbuyprice = 0.toDouble();
    Int64 totalStocks = owned! + reserved!;
    cashSpent == null
        ? {null}
        : {
            totalStocks == 0
                ? {null}
                : {
                    avgbuyprice = cashSpent.toDouble() / totalStocks.toDouble(),
                  }
          };
    return Wrap(children: [
      Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 25, top: 10),
              child: Text(
                name.toUpperCase(),
                style: const TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Owned',
                      style: TextStyle(color: blurredGray, fontSize: 18),
                    )),
                Text(
                  owned.toString(),
                  style: TextStyle(
                      color: (owned.toInt()) >= 0 ? secondaryColor : heartRed,
                      fontSize: 18),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Reserved',
                      style: TextStyle(color: blurredGray, fontSize: 18),
                    )),
                Text(
                  reserved.toString(),
                  style: TextStyle(
                      color:
                          (reserved.toInt()) >= 0 ? secondaryColor : heartRed,
                      fontSize: 18),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Current Price',
                      style: TextStyle(color: blurredGray, fontSize: 18),
                    )),
                Text(
                  price.toString(),
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Avg Buy Price',
                      style: TextStyle(color: blurredGray, fontSize: 18),
                    )),
                Text(
                  avgbuyprice.toStringAsFixed(2),
                  style: const TextStyle(color: secondaryColor, fontSize: 18),
                )
              ],
            ),
          ],
        ),
      ]),
    ]);
  }

  Widget _eachField(String field, String value) {
    return Row(children: [
      const Padding(padding: EdgeInsets.all(10)),
      Text(
        field,
        style: const TextStyle(
          fontSize: 21,
        ),
      ),
      const Spacer(),
      Container(
        padding: const EdgeInsets.only(right: 25),
        child: Text(
          value,
          style: const TextStyle(fontSize: 21),
        ),
      )
    ]);
  }
}
