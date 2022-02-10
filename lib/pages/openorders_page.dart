import 'package:dalal_street_client/blocs/open_orders/cubit/openorders_subscription_cubit.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/components/buttons/tertiary_button.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/proto_build/actions/GetMyOrders.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/MyOrders.pb.dart';
import 'package:dalal_street_client/proto_build/models/Ask.pb.dart';
import 'package:dalal_street_client/proto_build/models/Bid.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/open_orders/open_orders_cubit.dart';
import '../proto_build/datastreams/Subscribe.pbenum.dart';

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
          borderRadius: BorderRadius.circular(10), color: background2),
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
                    fontWeight: FontWeight.w500),
              )),
          // BlocListener<SubscribeCubit,SubscribeState>(listener: ((context, state) {

          //   if(state is SubscriptionDataLoaded)
          //   {
          //     context.read<OpenordersSubscriptionCubit>().getOpenOrdersStream(state.subscriptionId);
          //     BlocConsumer<OpenordersSubscriptionCubit,OpenordersSubscriptionState>(listener:(context, state) => {
          //       if(state is SubscriptionToOpenOrderSuccess)
          //       {
          //        MyOrderUpdate orderUpdate = state.orderUpdate

          //       }

          //     });
          //   }

          // }),)
          BlocConsumer<OpenOrdersCubit, OpenOrdersState>(
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
                if (buildRowsOfOpenOrders(state.res).isNotEmpty) {
                  return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                          columnSpacing: 10,
                          headingRowHeight: 40,
                          columns: const <DataColumn>[
                            DataColumn(
                                label: Text('Company',
                                    style: TextStyle(
                                        color: lightGray, fontSize: 12))),
                            DataColumn(
                                label: Text(
                              'Type',
                              style: TextStyle(color: lightGray, fontSize: 12),
                            )),
                            DataColumn(
                                label: Text('Volume',
                                    style: TextStyle(
                                        color: lightGray, fontSize: 12))),
                            DataColumn(
                                label: Text('Filled',
                                    style: TextStyle(
                                        color: lightGray, fontSize: 12))),
                            DataColumn(
                                label: Text('Price',
                                    style: TextStyle(
                                        color: lightGray, fontSize: 12))),
                            DataColumn(
                                label: Text('Action',
                                    style: TextStyle(
                                        color: lightGray, fontSize: 12))),
                          ],
                          rows: buildRowsOfOpenOrders(state.res)));
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
          ),
        ],
      ),
    )));
  }

  List<DataRow> buildRowsOfOpenOrders(GetMyOpenOrdersResponse response) {
    List<Ask> openAskOrdersList = response.openAskOrders;
    List<Bid> openBidOrdersList = response.openBidOrders;
    List<DataRow> rows = [];
    final stockList = getIt<GlobalStreams>().latestStockMap;
    for (var element in openAskOrdersList) {
      Stock? company = stockList[element.stockId];

      rows.add(buildOpenAskOrdersRow(
          company?.fullName,
          'Sell/' + element.orderType.name,
          element.stockQuantity,
          element.stockQuantityFulfilled,
          element.price,
          element));
    }
    for (var element in openBidOrdersList) {
      Stock? company = stockList[element.stockId];
      rows.add(buildOpenBidOrdersRow(
          company?.fullName,
          'Buy/' + element.orderType.name,
          element.stockQuantity,
          element.stockQuantityFulfilled,
          element.price,
          element));
    }
    return rows;
  }

  DataRow buildOpenAskOrdersRow(
    String? fullName,
    String orderTypeName,
    Int64 stockQuantity,
    Int64 stockQuantityFulfilled,
    Int64 price,
    Ask element,
  ) {
    return DataRow(cells: <DataCell>[
      DataCell(Text(
        fullName!,
        style: const TextStyle(fontSize: 12),
      )),
      DataCell(
        Text(orderTypeName, style: const TextStyle(fontSize: 12)),
      ),
      DataCell(
        Text(stockQuantity.toString(), style: const TextStyle(fontSize: 12)),
      ),
      DataCell(
        Text(stockQuantityFulfilled.toString(),
            style: const TextStyle(fontSize: 12)),
      ),
      DataCell(
        Text(price.toString(), style: const TextStyle(fontSize: 12)),
      ),
      DataCell(TertiaryButton(
        width: 45,
        height: 15,
        color: Colors.red,
        onPressed: () => buttonAsktap(element),
        title: 'cancel',
        fontSize: 8,
      ))
    ]);
  }

  DataRow buildOpenBidOrdersRow(
    String? fullName,
    String orderTypeName,
    Int64 stockQuantity,
    Int64 stockQuantityFulfilled,
    Int64 price,
    Bid element,
  ) {
    return DataRow(cells: <DataCell>[
      DataCell(Text(
        fullName!,
        style: const TextStyle(fontSize: 12),
      )),
      DataCell(
        Text(orderTypeName, style: const TextStyle(fontSize: 12)),
      ),
      DataCell(
        Text(stockQuantity.toString(), style: const TextStyle(fontSize: 12)),
      ),
      DataCell(
        Text(stockQuantityFulfilled.toString(),
            style: const TextStyle(fontSize: 12)),
      ),
      DataCell(
        Text(price.toString(), style: const TextStyle(fontSize: 12)),
      ),
      DataCell(TertiaryButton(
        width: 45,
        height: 15,
        color: Colors.red,
        onPressed: () => buttonBidtap(element),
        title: 'cancel',
        fontSize: 8,
      )),
    ]);
  }

  buttonBidtap(Bid element) {
    if (!element.isClosed) {
      logger.i(element.id);
      context.read<OpenOrdersCubit>().cancelOpenOrders(element.id, false);
    }
  }

  buttonAsktap(Ask element) {
    if (!element.isClosed) {
      logger.i(element.id);
      context.read<OpenOrdersCubit>().cancelOpenOrders(element.id, true);
    }
  }
}
