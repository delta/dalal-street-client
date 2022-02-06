import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/blocs/portfolio/userWorth/portfolio_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';

class PortfolioUserWorth extends StatefulWidget {
  const PortfolioUserWorth({Key? key}) : super(key: key);

  @override
  _PortfolioUserWorthState createState() => _PortfolioUserWorthState();
}

class _PortfolioUserWorthState extends State<PortfolioUserWorth> {
  Map<int, Stock> mapOfStocks = getIt<GlobalStreams>().latestStockMap;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => userWorth();

  Widget userWorth() =>
      BlocBuilder<PortfolioCubit, PortfolioState>(builder: (context, state) {
        if (state is PortfolioLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        } else if (state is UserWorthLoaded) {
          int stockWorth = calculateUserStockWorth(state.stocks);
          int reserveStockWorth =
              calculateUserReservedStocksWorth(state.reservedStocks);
          Int64 cash = state.user.cash;
          Int64 reservedCash = state.user.reservedCash;
          int total = stockWorth +
              reserveStockWorth +
              cash.toInt() +
              reservedCash.toInt();
          return Wrap(children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 15),
                      ),
                      const Text(
                        'Portfolio',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          _eachField('Cash in Hand', cash.toString()),
                          const SizedBox(height: 15),
                          _eachField('Stock Worth', stockWorth.toString()),
                          const SizedBox(height: 15),
                          _eachField('Reserved Cash', reservedCash.toString()),
                          const SizedBox(height: 15),
                          _eachField('Reserved Stock Worth',
                              reserveStockWorth.toString()),
                          const SizedBox(height: 15),
                          Row(children: [
                            const Padding(padding: EdgeInsets.only(left: 20)),
                            const Text(
                              'Total Worth',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.only(right: 25, top: 5),
                              child: Text(
                                total.toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: total.toInt() >= 0
                                        ? secondaryColor
                                        : heartRed),
                              ),
                            )
                          ])
                        ],
                      ),
                    ])),
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 15),
                      ),
                      const Text(
                        'Your Holdings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _holdings(state),
                      Container(
                        width: double.infinity,
                      )
                    ])),
          ]);
        } else if (state is UserWorthFailure) {
          return Center(
            child: Text(state.message),
          );
        }
        return const Text('');
      });

  Widget _holdings(UserWorthLoaded state) {
    var stockHeld = <dynamic, dynamic>{};

    Map<int, Int64> stocksReservedMap = state.reservedStocks;
    Map<int, Int64> stocksOwnedMap = state.stocks;
    Map<int, Int64> cashSpentMap = state.cashSpent;

    mapOfStocks.forEach((stockId, value) {
      if ((!stocksReservedMap.containsKey(stockId)) &
          (!stocksOwnedMap.containsKey(stockId))) {
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
      ListView.builder(
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
          });

  Widget _eachStock(Int64? owned, Int64? reserved, Int64? cashSpent,
      String name, Int64? price) {
    Int64 avgbuyprice = Int64(0);
    Int64 totalStocks = owned! + reserved!;
    cashSpent == null
        ? {null}
        : {
            totalStocks == 0 ? {null} : {avgbuyprice = cashSpent ~/ totalStocks}
          };
    return Wrap(children: [
      Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 5, top: 10),
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
                      style: TextStyle(color: blurredGray),
                    )),
                Text(
                  owned.toString(),
                  style: TextStyle(
                      color: (owned.toInt()) >= 0 ? secondaryColor : heartRed),
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
                      style: TextStyle(color: blurredGray),
                    )),
                Text(
                  reserved.toString(),
                  style: TextStyle(
                      color:
                          (reserved.toInt()) >= 0 ? secondaryColor : heartRed),
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
                      style: TextStyle(color: blurredGray),
                    )),
                Text(price.toString())
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
                      style: TextStyle(color: blurredGray),
                    )),
                Text(
                  avgbuyprice.toString(),
                  style: TextStyle(
                      color: (avgbuyprice.toInt()) >= 0
                          ? secondaryColor
                          : heartRed),
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
          fontSize: 18,
        ),
      ),
      const Spacer(),
      Container(
        padding: const EdgeInsets.only(right: 25),
        child: Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
      )
    ]);
  }

  int calculateUserReservedStocksWorth(Map<int, Int64> stocksReservedMap) {
    int worth = 0;
    stocksReservedMap.forEach((stockId, value) {
      worth +=
          value.toInt() * (mapOfStocks[stockId]?.currentPrice.toInt() ?? 0);
    });
    return worth;
  }

  int calculateUserStockWorth(Map<int, Int64> stocksOwnedMap) {
    int worth = 0;
    stocksOwnedMap.forEach((stockId, value) {
      worth +=
          value.toInt() * (mapOfStocks[stockId]?.currentPrice.toInt() ?? 0);
    });
    return worth;
  }
}
