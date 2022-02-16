import 'package:dalal_street_client/blocs/open_orders/open_orders_cubit.dart';
import 'package:dalal_street_client/blocs/open_orders_subscription/openorders_subscription_cubit.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/proto_build/actions/GetMyOrders.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/MyOrders.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/get_it.dart';
import '../proto_build/datastreams/Subscribe.pbenum.dart';
import '../proto_build/models/Ask.pb.dart';
import '../proto_build/models/Bid.pb.dart';
import '../streams/global_streams.dart';

class OpenOrdersPage extends StatefulWidget {
  const OpenOrdersPage({Key? key}) : super(key: key);
  @override
  _OpenOrdersPageState createState() => _OpenOrdersPageState();
}

class _OpenOrdersPageState extends State<OpenOrdersPage> {
  @override
  void initState() {
    context.read<OpenOrdersCubit>().getOpenOrders();
    context.read<SubscribeCubit>().subscribe(DataStreamType.MY_ORDERS);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: background2),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Open Orders',
                            style: TextStyle(
                                color: lightGray,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                          )),
                      Center(child: BlocBuilder<SubscribeCubit, SubscribeState>(
                          builder: (context, state) {
                        if (state is SubscriptionDataLoaded) {
                          context
                              .read<OpenordersSubscriptionCubit>()
                              .getOpenOrdersStream(state.subscriptionId);
                          return BlocBuilder<OpenordersSubscriptionCubit,
                              OpenordersSubscriptionState>(
                            builder: ((context, state) {
                              if (state is SubscriptionToOpenOrderSuccess) {
                                return buildOpenOrdersTableUpdate(
                                    state.orderUpdate);
                              } else if (state
                                  is SubscriptionToOpenOrderFailed) {
                                return Column(children: [
                                  const Text('Failed to reach server'),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: 100,
                                    height: 50,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        context
                                            .read<OpenordersSubscriptionCubit>()
                                            .getOpenOrdersStream(
                                                state.subscriptionId);
                                      },
                                      child: const Text('Retry'),
                                    ),
                                  )
                                ]);
                              } else {
                                return buildOpenOrdersTable();
                              }
                            }),
                          );
                        } else if (state is SubscriptonDataFailed) {
                          return Column(children: [
                            const Text('Failed to reach server'),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  context
                                      .read<SubscribeCubit>()
                                      .subscribe(DataStreamType.MY_ORDERS);
                                },
                                child: const Text('Retry'),
                              ),
                            )
                          ]);
                        } else {
                          return buildOpenOrdersTable();
                        }
                      }))
                    ]))));
  }

  List<DataRow> buildRowsOfOpenOrdersUpdate(
      GetMyOpenOrdersResponse response, MyOrderUpdate myOrderUpdate) {
    List<Ask> openAskOrdersList = response.openAskOrders;
    List<Bid> openBidOrdersList = response.openBidOrders;
    List<DataRow> rows = [];
    final stockList = getIt<GlobalStreams>().latestStockMap;
    for (var element in openAskOrdersList) {
      Stock? company = stockList[element.stockId];
      if (element.id == myOrderUpdate.id) {
        if (!myOrderUpdate.isClosed) {
          rows.add(buildOpenOrdersRow(
              company?.fullName,
              company?.shortName,
              'https://upload.wikimedia.org/wikipedia/en/1/18/Airtel_logo.svg',
              'ASK / ' + element.orderType.name + ' ORDER',
              '${myOrderUpdate.tradeQuantity + element.stockQuantityFulfilled}/${element.stockQuantity}',
              element.price,
              element.id,
              myOrderUpdate.isClosed,
              true,
              element.createdAt));
        }
      } else {
        rows.add(buildOpenOrdersRow(
            company?.fullName,
            company?.shortName,
            'https://upload.wikimedia.org/wikipedia/en/1/18/Airtel_logo.svg',
            'ASK / ' + element.orderType.name + ' ORDER',
            '${element.stockQuantityFulfilled}/${element.stockQuantity}',
            element.price,
            element.id,
            element.isClosed,
            true,
            element.createdAt));
      }
    }
    for (var element in openBidOrdersList) {
      Stock? company = stockList[element.stockId];
      if (element.id == myOrderUpdate.id) {
        if (!myOrderUpdate.isClosed) {
          rows.add(buildOpenOrdersRow(
              company?.fullName,
              company?.shortName,
              'https://upload.wikimedia.org/wikipedia/en/1/18/Airtel_logo.svg',
              'BID / ' + element.orderType.name + ' ORDER',
              '${myOrderUpdate.tradeQuantity + element.stockQuantityFulfilled}/${element.stockQuantity}',
              element.price,
              element.id,
              myOrderUpdate.isClosed,
              true,
              element.createdAt));
        }
      } else {
        rows.add(buildOpenOrdersRow(
            company?.fullName,
            company?.shortName,
            'https://upload.wikimedia.org/wikipedia/en/1/18/Airtel_logo.svg',
            'BID / ' + element.orderType.name + ' ORDER',
            '${element.stockQuantityFulfilled}/${element.stockQuantity}',
            element.price,
            element.id,
            element.isClosed,
            true,
            element.createdAt));
      }
    }
    return rows;
  }

  List<DataRow> buildRowsOfOpenOrders(GetMyOpenOrdersResponse response) {
    List<Ask> openAskOrdersList = response.openAskOrders;
    List<Bid> openBidOrdersList = response.openBidOrders;
    List<DataRow> rows = [];
    final stockList = getIt<GlobalStreams>().latestStockMap;
    for (var element in openAskOrdersList) {
      Stock? company = stockList[element.stockId];

      rows.add(buildOpenOrdersRow(
          company?.fullName,
          company?.shortName,
          'https://upload.wikimedia.org/wikipedia/en/1/18/Airtel_logo.svg',
          'ASK / ' + element.orderType.name + ' ORDER',
          '${element.stockQuantityFulfilled}/${element.stockQuantity}',
          element.price,
          element.id,
          element.isClosed,
          true,
          element.createdAt));
    }
    for (var element in openBidOrdersList) {
      Stock? company = stockList[element.stockId];

      rows.add(buildOpenOrdersRow(
          company?.fullName,
          company?.shortName,
          'https://upload.wikimedia.org/wikipedia/en/1/18/Airtel_logo.svg',
          'BID / ' + element.orderType.name + ' ORDER',
          '${element.stockQuantityFulfilled}/${element.stockQuantity}',
          element.price,
          element.id,
          element.isClosed,
          false,
          element.createdAt));
    }
    return rows;
  }

  DataRow buildOpenOrdersRow(
      String? fullName,
      String? shortName,
      String imagePath,
      String orderTypeName,
      String orderStatus,
      Int64 price,
      int id,
      bool isClosed,
      bool isAsk,
      String createdAt) {
    return DataRow(
        cells: <DataCell>[
          DataCell(Row(
            children: [
              ClipRRect(
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Image.network(
                        'https://assets.airtel.in/static-assets/new-home/img/favicon-32x32.png',
                        height: 20,
                        width: 20,
                      )),
                  borderRadius: BorderRadius.circular(10)),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox.square(dimension: 20),
                Text(
                  fullName!,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox.square(dimension: 10),
                Text(
                  shortName!,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ])
            ],
          )),
          DataCell(
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox.square(dimension: 20),
            const Text(
              'TYPE',
              style: TextStyle(fontSize: 9, color: lightGray),
            ),
            Text(orderTypeName,
                style: const TextStyle(fontSize: 12, color: Colors.white)),
            const SizedBox.square(dimension: 10),
            const Text('PRICE',
                style: TextStyle(fontSize: 9, color: lightGray)),
            Text(
              '\$' + price.toString() + ' per stock',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              maxLines: 1,
            ),
          ])),
          DataCell(
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const SizedBox.square(dimension: 20),
            const Text(
              'COMPLETED',
              style: TextStyle(fontSize: 9, color: lightGray),
            ),
            Text(orderStatus,
                style: const TextStyle(fontSize: 12, color: secondaryColor)),
            const SizedBox.square(dimension: 10),
            const Text(
              'ORDERED',
              style: TextStyle(fontSize: 9, color: lightGray),
            ),
            Text(
              getdur(createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.white),
              maxLines: 1,
            )
          ])),
        ],
        onLongPress: () {
          if (!isClosed) {
            logger.i(id);
            logger.i('Cancel');
            context.read<OpenOrdersCubit>().cancelOpenOrders(id, isAsk);
          }
        });
  }

  Widget buildOpenOrdersTableUpdate(MyOrderUpdate myOrderUpdate) {
    return BlocConsumer<OpenOrdersCubit, OpenOrdersState>(
      listener: (context, state) {
        if (state is CancelorderSuccess) {
          showSnackBar(context, 'Order Cancelled Sucessfully');
          context.read<OpenOrdersCubit>().getOpenOrders();
        } else if (state is OrderFailure) {
          if (state.ordertype == OpenOrderType.cancel) {
            showSnackBar(context, 'Failed To Cancel Order Retrying.....');
            context.read<OpenOrdersCubit>().getOpenOrders();
            logger.e(state.msg);
          } else {
            showSnackBar(context, 'Failed to Fetch Open Orders');
            context.read<OpenOrdersCubit>().getOpenOrders();
            logger.e(state.msg);
          }
        }
      },
      builder: (context, state) {
        if (state is GetOpenordersSuccess) {
          if (buildRowsOfOpenOrdersUpdate(state.res, myOrderUpdate)
              .isNotEmpty) {
            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                          child: DataTable(
                              border: const TableBorder(
                                  bottom: BorderSide(
                                      width: 0,
                                      style: BorderStyle.solid,
                                      color: lightGray)),
                              dataRowHeight: 120,
                              columnSpacing: 25,
                              columns: const <DataColumn>[
                                DataColumn(
                                    label: Text(
                                  'ACTION',
                                  style: TextStyle(
                                    color: lightGray,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                                DataColumn(
                                    label: Text(
                                  'DETAIL',
                                  style: TextStyle(
                                      color: lightGray,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800),
                                  textAlign: TextAlign.center,
                                )),
                                DataColumn(
                                    label: Text(
                                  'STATUS',
                                  style: TextStyle(
                                      color: lightGray,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                              rows: buildRowsOfOpenOrdersUpdate(
                                  state.res, myOrderUpdate))),
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Long press a order to close it',
                            style: TextStyle(color: lightGray, fontSize: 11),
                          ))
                    ]));
          } else {
            return const Center(child: Text('No Open Orders'));
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }
      },
    );
  }

  Widget buildOpenOrdersTable() {
    return BlocConsumer<OpenOrdersCubit, OpenOrdersState>(
      listener: (context, state) {
        if (state is CancelorderSuccess) {
          showSnackBar(context, 'Order Cancelled Sucessfully');
          context.read<OpenOrdersCubit>().getOpenOrders();
        } else if (state is OrderFailure) {
          if (state.ordertype == OpenOrderType.cancel) {
            showSnackBar(context, 'Failed To Cancel Order Retrying.....');
            context.read<OpenOrdersCubit>().getOpenOrders();
            logger.e(state.msg);
          } else {
            showSnackBar(context, 'Failed to Fetch Open Orders');
            context.read<OpenOrdersCubit>().getOpenOrders();
            logger.e(state.msg);
          }
        }
      },
      builder: (context, state) {
        if (state is GetOpenordersSuccess) {
          if (buildRowsOfOpenOrders(
            state.res,
          ).isNotEmpty) {
            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                          child: DataTable(
                              border: const TableBorder(
                                  bottom: BorderSide(
                                      width: 0,
                                      style: BorderStyle.solid,
                                      color: lightGray)),
                              dataRowHeight: 120,
                              columnSpacing: 25,
                              columns: const <DataColumn>[
                                DataColumn(
                                    label: Text(
                                  'ACTION',
                                  style: TextStyle(
                                    color: lightGray,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                                DataColumn(
                                    label: Text(
                                  'DETAIL',
                                  style: TextStyle(
                                      color: lightGray,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800),
                                  textAlign: TextAlign.center,
                                )),
                                DataColumn(
                                    label: Text(
                                  'STATUS',
                                  style: TextStyle(
                                      color: lightGray,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                              rows: buildRowsOfOpenOrders(state.res))),
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Long press a order to close it',
                            style: TextStyle(color: lightGray, fontSize: 11),
                          ))
                    ]));
          } else {
            return const Center(child: Text('No Open Orders'));
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }
      },
    );
  }

  String getdur(String createdAt) {
    DateTime dt1 = DateTime.parse(createdAt);
    DateTime dt2 = DateTime.now();
    Duration diff = dt2.difference(dt1);
    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return (diff.inMinutes.toString() + ' minutes ago');
      } else {
        return (diff.inHours.toString() + ' hour ago');
      }
    } else {
      return (diff.inDays.toString() + ' day ago');
    }
  }
}
