import 'package:dalal_street_client/blocs/my_orders/my_orders_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
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
            body: SingleChildScrollView(
                child: Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: background2),
              child: BlocBuilder<MyOrdersCubit, MyOrdersState>(
                builder: ((context, state) {
                  if (state is OpenOrdersSuccess) {
                    final openAskList = state.openAskArray;
                    final openBidList = state.openBidArray;
                    

                    return ListView.builder(
                        itemCount: openAskList.length,
                        itemBuilder: (context, index) {
                          final stockList =
                              getIt<GlobalStreams>().latestStockMap;
                          Stock? company =
                              stockList[openAskList[index].stockId];

                          return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                        child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Image.network(
                                              'https://assets.airtel.in/static-assets/new-home/img/favicon-32x32.png',
                                              height: 20,
                                              width: 20,
                                            )),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox.square(dimension: 20),
                                          Text(
                                            (company?.fullName.toUpperCase())!,
                                            style: const TextStyle(
                                                fontSize: 12, color: lightGray),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox.square(dimension: 10),
                                          Text(
                                            (company?.shortName.toUpperCase())!,
                                            style:
                                                const TextStyle(fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ),
                                        ])
                                  ],
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox.square(dimension: 20),
                                      const Text(
                                        'TYPE',
                                        style: TextStyle(
                                            fontSize: 9, color: lightGray),
                                      ),
                                      Text(
                                          'ASK / ' +
                                              openAskList[index]
                                                  .orderType
                                                  .name +
                                              ' ORDER',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white)),
                                      const SizedBox.square(dimension: 10),
                                      const Text('PRICE',
                                          style: TextStyle(
                                              fontSize: 9, color: lightGray)),
                                      Text(
                                        '\$' +
                                            openAskList[index].toString() +
                                            ' per stock',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ]),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox.square(dimension: 20),
                                      const Text(
                                        'COMPLETED',
                                        style: TextStyle(
                                            fontSize: 9, color: lightGray),
                                      ),
                                      Text(
                                          '${openAskList[index].stockQuantityFulfilled}/${openAskList[index].stockQuantity}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: secondaryColor)),
                                      const SizedBox.square(dimension: 10),
                                      const Text(
                                        'ORDERED',
                                        style: TextStyle(
                                            fontSize: 9, color: lightGray),
                                      ),
                                      Text(
                                        getdur(openAskList[index].createdAt),
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      )
                                    ])
                              ]);
                        });
                  }
                  else
                  {
                    return Text(state.toString());
                  }
                }),
              ),
            ))));
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
