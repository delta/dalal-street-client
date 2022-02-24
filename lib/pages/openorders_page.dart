import 'package:dalal_street_client/blocs/my_orders/my_orders_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/proto_build/models/Ask.pb.dart';
import 'package:dalal_street_client/proto_build/models/Bid.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/colors.dart';

class OpenOrdersPage extends StatefulWidget {
  const OpenOrdersPage({Key? key}) : super(key: key);

  @override
  _OpenOrdersPageState createState() => _OpenOrdersPageState();
}

class _OpenOrdersPageState extends State<OpenOrdersPage> {
  List<Widget> openOrdersList = [];
  List<bool> isAskList = [];
  List<int> orderIdList = [];
  @override
  void initState() {
    context.read<MyOrdersCubit>().getMyOpenOrders();
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
            body: Container(
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: background2),
                child: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      Center(
                          child: Row(
                        children: const [
                          Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 60, 0),
                              child: Text(
                                'ACTION',
                                style: TextStyle(
                                  color: blurredGray,
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.left,
                              )),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 40, 0),
                              child: Text(
                                'DETAIL',
                                style: TextStyle(
                                  color: blurredGray,
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.left,
                              )),
                          Padding(
                              padding: EdgeInsets.fromLTRB(80, 10, 0, 0),
                              child: Text(
                                'STATUS',
                                style: TextStyle(
                                  color: blurredGray,
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.right,
                              ))
                        ],
                      )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child: BlocBuilder<MyOrdersCubit, MyOrdersState>(
                              builder: ((context, state) {
                                if (state is OpenOrdersSuccess) {
                                  logger.d('open order updates');
                                  final openAskList = state.openAskArray;
                                  final openBidList = state.openBidArray;
                                  logger.i('AskOpenOrders' +
                                      openAskList.length.toString());
                                  logger.i('BidOpenOrders' +
                                      openBidList.length.toString());

                                  List<Widget> openOrders =
                                      buildList(openAskList, openBidList);
                                  openOrdersList = [];
                                  if (openOrders.isNotEmpty) {
                                    return SingleChildScrollView(
                                        child: ListView.separated(
                                            shrinkWrap: true,
                                            itemCount: openOrders.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                  child: openOrders[index],
                                                  onDoubleTap: () {
                                                    context
                                                        .read<MyOrdersCubit>()
                                                        .cancelMyOrder(
                                                            isAskList[index],
                                                            orderIdList[index]);
                                                    showSnackBar(context,
                                                        'Order Cancelled Sucessfully ${orderIdList[index]} ${isAskList[index]}');
                                                    context
                                                        .read<MyOrdersCubit>()
                                                        .getMyOpenOrders();
                                                  });
                                            },
                                            separatorBuilder: (context, index) {
                                              return const Divider(
                                                color: lightGray,
                                              );
                                            }));
                                  } else {
                                    return (const Center(
                                      child: Text('No Open Orders',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                    ));
                                  }
                                } else {
                                  return Text(state.toString());
                                }
                              }),
                            ),
                          ))
                    ])))));
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

  List<Widget> buildList(List<Ask> openAskList, List<Bid> openBidList) {
    for (var openAsk in openAskList) {
      openOrdersList.add(buildItemAsk(openAsk));
      isAskList.add(true);
      orderIdList.add(openAsk.id);
    }
    for (var openBid in openBidList) {
      openOrdersList.add(buildItemBid(openBid));
      isAskList.add(false);
      orderIdList.add(openBid.id);
    }
    return openOrdersList;
  }

  Widget buildItemAsk(Ask openAsk) {
    final stockList = getIt<GlobalStreams>().latestStockMap;
    Stock? company = stockList[openAsk.stockId];

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
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
          Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                  width: 80,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox.square(dimension: 20),
                        Text(
                          (company?.fullName.toUpperCase())!,
                          style:
                              const TextStyle(fontSize: 12, color: lightGray),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                        const SizedBox.square(dimension: 10),
                        Text(
                          (company?.shortName.toUpperCase())!,
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.left,
                        ),
                      ]))),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox.square(dimension: 20),
                    const Text(
                      'TYPE',
                      style: TextStyle(fontSize: 9, color: lightGray),
                    ),
                    Text('ASK / ' + openAsk.orderType.name + ' ORDER',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white)),
                    const SizedBox.square(dimension: 10),
                    const Text('PRICE',
                        style: TextStyle(fontSize: 9, color: lightGray)),
                    Text(
                      '\$' + openAsk.price.toString() + ' per stock',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                    ),
                  ])),
          Padding(
              padding: const EdgeInsets.all(10),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const SizedBox.square(dimension: 20),
                const Text(
                  'COMPLETED',
                  style: TextStyle(fontSize: 9, color: lightGray),
                ),
                Text(
                    '${openAsk.stockQuantityFulfilled}/${openAsk.stockQuantity}',
                    style:
                        const TextStyle(fontSize: 12, color: secondaryColor)),
                const SizedBox.square(dimension: 10),
                const Text(
                  'ORDERED',
                  style: TextStyle(fontSize: 9, color: lightGray),
                ),
                Text(
                  getdur(openAsk.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                )
              ]))
        ]);
  }

  Widget buildItemBid(Bid openBid) {
    final stockList = getIt<GlobalStreams>().latestStockMap;
    Stock? company = stockList[openBid.stockId];

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
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
          Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                  width: 80,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox.square(dimension: 20),
                        Text(
                          (company?.fullName.toUpperCase())!,
                          style:
                              const TextStyle(fontSize: 12, color: lightGray),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox.square(dimension: 10),
                        Text(
                          (company?.shortName.toUpperCase())!,
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.left,
                        ),
                      ]))),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox.square(dimension: 20),
                    const Text(
                      'TYPE',
                      style: TextStyle(fontSize: 9, color: lightGray),
                    ),
                    Text('BID / ' + openBid.orderType.name + ' ORDER',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white)),
                    const SizedBox.square(dimension: 10),
                    const Text('PRICE',
                        style: TextStyle(fontSize: 9, color: lightGray)),
                    Text(
                      '\$' + openBid.price.toString() + ' per stock',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                    ),
                  ])),
          Padding(
              padding: const EdgeInsets.all(10),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const SizedBox.square(dimension: 20),
                const Text(
                  'COMPLETED',
                  style: TextStyle(fontSize: 9, color: lightGray),
                ),
                Text(
                    '${openBid.stockQuantityFulfilled}/${openBid.stockQuantity}',
                    style:
                        const TextStyle(fontSize: 12, color: secondaryColor)),
                const SizedBox.square(dimension: 10),
                const Text(
                  'ORDERED',
                  style: TextStyle(fontSize: 9, color: lightGray),
                ),
                Text(
                  getdur(openBid.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                )
              ]))
        ]);
  }
}
