import 'package:dalal_street_client/blocs/my_orders/my_orders_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/proto_build/models/Ask.pb.dart';
import 'package:dalal_street_client/proto_build/models/Bid.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/utils/iso_to_datetime.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<MyOrdersCubit>().getMyOpenOrders();
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
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: background2),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                          padding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                          child: Align(
                            child: Text(
                              'Double click an order to close it',
                              style: TextStyle(fontSize: 11, color: lightGray),
                              textAlign: TextAlign.right,
                            ),
                            alignment: Alignment.bottomRight,
                          )),
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
                      Expanded(
                        child: BlocConsumer<MyOrdersCubit, MyOrdersState>(
                            listener: (context, state) {
                          if (state is CancelOrderSuccess) {
                            showSnackBar(
                                context, 'Order Cancelled Successfully',
                                type: SnackBarType.success);
                            context.read<MyOrdersCubit>().getMyOpenOrders();
                          } else if (state is CancelOrderFailure) {
                            showSnackBar(context, state.error,
                                type: SnackBarType.error);
                          }
                        }, builder: (context, state) {
                          if (state is OpenOrdersSuccess) {
                            final askOrders = state.openAskOrders;
                            final bidOrders = state.openBidOrders;
                            List<Widget> openOrders =
                                buildList(askOrders, bidOrders);

                            return SingleChildScrollView(
                              child: Column(children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: openOrders.length,
                                  itemBuilder: (context, index) {
                                    bool isAsk = index < askOrders.length;
                                    int orderId = isAsk
                                        ? askOrders[index].id
                                        : bidOrders[index - askOrders.length]
                                            .id;
                                    return GestureDetector(
                                      child: openOrders[index],
                                      onDoubleTap: () {
                                        context
                                            .read<MyOrdersCubit>()
                                            .cancelMyOrder(isAsk, orderId);
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(color: lightGray),
                                ),
                                const Divider(
                                  color: lightGray,
                                ),
                              ]),
                            );
                          } else if (state is NoOpenOrders) {
                            return (const Center(
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('No Open Orders',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white))),
                            ));
                          } else if (state is OpenOrdersFailure) {
                            return Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Failed to Reach the Server'),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      context
                                          .read<MyOrdersCubit>()
                                          .getMyOpenOrders();
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ),
                              ],
                            ));
                          } else {
                            return const Center(
                              child: DalalLoadingBar(),
                            );
                          }
                        }),
                      )
                    ]))));
  }

  List<Widget> buildList(List<Ask> askOrders, List<Bid> bidOrders) =>
      askOrders.map((e) => buildItem(e, 'ASK')).toList() +
      bidOrders.map((e) => buildItem(e, 'BID')).toList();

  // TODO: create an enum for ordertype
  Widget buildItem(openorder, ordertype) {
    final stockList = getIt<GlobalStreams>().latestStockMap;
    Stock? company = stockList[openorder.stockId];

    return Card(
        color: background2,
        child: Row(
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
                      width: 85,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox.square(dimension: 20),
                            Text(
                              (company?.fullName.toUpperCase())!,
                              style: const TextStyle(
                                  fontSize: 12, color: lightGray),
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
                        Text(
                            '$ordertype / ' +
                                openorder.orderType.name +
                                ' ORDER',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white)),
                        const SizedBox.square(dimension: 10),
                        const Text('PRICE',
                            style: TextStyle(fontSize: 9, color: lightGray)),
                        Text(
                          '₹' + openorder.price.toString() + ' per stock',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                        ),
                      ])),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox.square(dimension: 20),
                        const Text(
                          'COMPLETED',
                          style: TextStyle(fontSize: 9, color: lightGray),
                        ),
                        Text(
                            '${openorder.stockQuantityFulfilled}/${openorder.stockQuantity}',
                            style: const TextStyle(
                                fontSize: 12, color: secondaryColor)),
                        const SizedBox.square(dimension: 10),
                        const Text(
                          'ORDERED',
                          style: TextStyle(fontSize: 9, color: lightGray),
                        ),
                        SizedBox(
                            width: 60,
                            child: Text(
                              ISOtoDateTime(openorder.createdAt),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                              textAlign: TextAlign.right,
                            ))
                      ]))
            ]));
  }
}
