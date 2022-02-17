import 'package:dalal_street_client/blocs/open_orders/open_orders_cubit.dart';
import 'package:dalal_street_client/blocs/open_orders_subscription/open_orders_subscription_cubit.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/proto_build/actions/GetMyOrders.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/MyOrders.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/buttons.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
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
            appBar: AppBar(
              title: const Text(
                'Open Orders',
                style: TextStyle(
                    color: lightGray,
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
                textAlign: TextAlign.left,
              ),
            ),
            body: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: background2),
                    child: BlocBuilder<SubscribeCubit, SubscribeState>(
                        builder: (context, state) {
                      if (state is SubscriptionDataLoaded) {
                        context
                            .read<OpenordersSubscriptionCubit>()
                            .getOpenOrdersStream(state.subscriptionId);
                        return BlocBuilder<OpenordersSubscriptionCubit,
                            OpenordersSubscriptionState>(
                          builder: ((context, state) {
                            if (state is SubscriptionToOpenOrderSuccess) {
                              return updateTable(state.orderUpdate, context);
                            } else if (state is SubscriptionToOpenOrderFailed) {
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
                              return buildTable(context);
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
                        return buildTable(context);
                      }
                    })))));
  }

  List<DataRow> updateRows(GetMyOpenOrdersResponse response,
      MyOrderUpdate myOrderUpdate, BuildContext context) {
    List<Ask> openAskOrdersList = response.openAskOrders;
    List<Bid> openBidOrdersList = response.openBidOrders;
    List<DataRow> rows = [];
    final stockList = getIt<GlobalStreams>().latestStockMap;
    for (var element in openAskOrdersList) {
      Stock? company = stockList[element.stockId];
      if (element.id == myOrderUpdate.id) {
        if (!myOrderUpdate.isClosed) {
          rows.add(addRow(
              company?.fullName,
              company?.shortName,
              'https://upload.wikimedia.org/wikipedia/en/1/18/Airtel_logo.svg',
              'ASK / ' + element.orderType.name + ' ORDER',
              '${myOrderUpdate.tradeQuantity + element.stockQuantityFulfilled}/${element.stockQuantity}',
              element.price,
              element.id,
              myOrderUpdate.isClosed,
              true,
              element.createdAt,
              context));
        }
      } else {
        rows.add(addRow(
            company?.fullName,
            company?.shortName,
            'https://upload.wikimedia.org/wikipedia/en/1/18/Airtel_logo.svg',
            'ASK / ' + element.orderType.name + ' ORDER',
            '${element.stockQuantityFulfilled}/${element.stockQuantity}',
            element.price,
            element.id,
            element.isClosed,
            true,
            element.createdAt,
            context));
      }
    }
    for (var element in openBidOrdersList) {
      Stock? company = stockList[element.stockId];
      if (element.id == myOrderUpdate.id) {
        if (!myOrderUpdate.isClosed) {
          rows.add(addRow(
              company?.fullName,
              company?.shortName,
              'https://upload.wikimedia.org/wikipedia/en/1/18/Airtel_logo.svg',
              'BID / ' + element.orderType.name + ' ORDER',
              '${myOrderUpdate.tradeQuantity + element.stockQuantityFulfilled}/${element.stockQuantity}',
              element.price,
              element.id,
              myOrderUpdate.isClosed,
              false,
              element.createdAt,
              context));
        }
      } else {
        rows.add(addRow(
            company?.fullName,
            company?.shortName,
            'https://upload.wikimedia.org/wikipedia/en/1/18/Airtel_logo.svg',
            'BID / ' + element.orderType.name + ' ORDER',
            '${element.stockQuantityFulfilled}/${element.stockQuantity}',
            element.price,
            element.id,
            element.isClosed,
            false,
            element.createdAt,
            context));
      }
    }
    return rows;
  }

  List<DataRow> buildRows(
      GetMyOpenOrdersResponse response, BuildContext context) {
    List<Ask> openAskOrdersList = response.openAskOrders;
    List<Bid> openBidOrdersList = response.openBidOrders;
    List<DataRow> rows = [];
    final stockList = getIt<GlobalStreams>().latestStockMap;
    for (var element in openAskOrdersList) {
      Stock? company = stockList[element.stockId];

      rows.add(addRow(
          company?.fullName,
          company?.shortName,
          'https://upload.wikimedia.org/wikipedia/en/1/18/Airtel_logo.svg',
          'ASK / ' + element.orderType.name + ' ORDER',
          '${element.stockQuantityFulfilled}/${element.stockQuantity}',
          element.price,
          element.id,
          element.isClosed,
          true,
          element.createdAt,
          context));
    }
    for (var element in openBidOrdersList) {
      Stock? company = stockList[element.stockId];

      rows.add(addRow(
          company?.fullName,
          company?.shortName,
          'https://upload.wikimedia.org/wikipedia/en/1/18/Airtel_logo.svg',
          'BID / ' + element.orderType.name + ' ORDER',
          '${element.stockQuantityFulfilled}/${element.stockQuantity}',
          element.price,
          element.id,
          element.isClosed,
          false,
          element.createdAt,
          context));
    }
    return rows;
  }

  DataRow addRow(
      String? fullName,
      String? shortName,
      String imagePath,
      String orderTypeName,
      String orderStatus,
      Int64 price,
      int id,
      bool isClosed,
      bool isAsk,
      String createdAt,
      BuildContext context) {
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
                  fullName!.toUpperCase(),
                  style: const TextStyle(fontSize: 12,color: lightGray),
                  textAlign: TextAlign.center,
                ),
                const SizedBox.square(dimension: 10),
                Text(
                  shortName!.toUpperCase(),
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
          showDialog(
              context: context,
              builder: (BuildContext context) => _buildPopupDialog(context,isClosed,id,isAsk),
            );
          
        });
  }

  Widget updateTable(MyOrderUpdate myOrderUpdate, BuildContext context) {
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
          if (updateRows(state.res, myOrderUpdate, context).isNotEmpty) {
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
                              columnSpacing: 15,
                              columns: const <DataColumn>[
                                DataColumn(
                                    label: Text(
                                  'ACTION',
                                  style: TextStyle(
                                    color: blurredGray,
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                                DataColumn(
                                    label: Text(
                                  'DETAIL',
                                  style: TextStyle(
                                      color: blurredGray,
                                      fontSize: 11,
                                      ),
                                  textAlign: TextAlign.center,
                                )),
                                DataColumn(
                                    label: Text(
                                  'STATUS',
                                  style: TextStyle(
                                      color: blurredGray,
                                      fontSize: 11,
                                      ),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                              rows: updateRows(
                                  state.res, myOrderUpdate, context))),
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Long press a order to close it',
                            style: TextStyle(color: blurredGray, fontSize: 11),
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

  Widget buildTable(BuildContext context) {
    return BlocConsumer<OpenOrdersCubit, OpenOrdersState>(
      listener: (context, state) {
        logger.i('listening');
        if (state is CancelorderSuccess) {
          logger.i('Cancel Order Sucess');
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
          if (buildRows(state.res, context).isNotEmpty) {
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
                              columnSpacing: 15,
                              columns: const <DataColumn>[
                                DataColumn(
                                    label: Text(
                                  'ACTION',
                                  style: TextStyle(
                                    color: blurredGray,
                                    fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                                DataColumn(
                                    label: Text(
                                  'DETAIL',
                                  style: TextStyle(
                                      color: blurredGray,
                                      fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                                DataColumn(
                                    label: Text(
                                  'STATUS',
                                  style: TextStyle(
                                      color: blurredGray,
                                      fontSize: 11,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                              rows: buildRows(state.res, context))),
                      const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Long press a order to close it',
                            style: TextStyle(color: blurredGray, fontSize: 11),
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

  Widget _buildPopupDialog(BuildContext context,bool isClosed, int id, bool isAsk,) {
  return  AlertDialog(
    backgroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10))),
     content: SizedBox(
       height: 200,
       width: 300,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
         
       const Text('Are you sure you want to close the order ?',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
      const SizedBox.square(dimension: 40,),
       Row(
           mainAxisAlignment:MainAxisAlignment.center,
           children: [
             SizedBox(
              width: 95,
              height: 40,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('No',style: TextStyle(fontSize: 13),),
                
                style: primaryButtonStyle
              ),
            ),
            const SizedBox.square(dimension: 30,),

            SizedBox(
              width: 95,
              height: 40,
              child: ElevatedButton(
                onPressed: (){
                   if (!isClosed) {
            logger.i(id);
            logger.i('Cancel');
            context.read<OpenOrdersCubit>().cancelOpenOrders(id, isAsk);
            Navigator.of(context).pop();
          }
          
                },
                child: const Text('Yes',style: TextStyle(fontSize: 13)),
                
                style: outlinedButtonStyle
              ),
            ),
          
            
           ],)
       ]),
     )
     ,
    
  );
  }
}
