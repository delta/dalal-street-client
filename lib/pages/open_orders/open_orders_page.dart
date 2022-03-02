import 'package:dalal_street_client/blocs/my_orders/my_orders_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/models/open_order_type.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/pages/open_orders/components/open_order_table.dart';
import 'package:dalal_street_client/proto_build/models/Ask.pb.dart';
import 'package:dalal_street_client/proto_build/models/Bid.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/utils/iso_to_datetime.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/colors.dart';

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
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
            primary: false,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Responsive(
              desktop: _desktopBody(),
              mobile: _mobileBody(),
              tablet: _tabletBody(),
            )),
      ),
    );
  }

  Widget _desktopBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          _openOrdersWeb(),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget _openOrdersWeb() => Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Open Orders',
                style: TextStyle(
                    fontSize: 48, fontWeight: FontWeight.w700, color: white),
                textAlign: TextAlign.end,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Carefully manage the open orders to make some gains and stay in the game.',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: lightGray),
                textAlign: TextAlign.end,
              ),
              SizedBox(
                height: 20,
              ),
              OpenOrderTable()
            ]),
      );

  Widget _mobileBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          _openOrdersMobile(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _openOrdersMobile() => Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: background2),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Open Orders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: lightGray,
              ),
              textAlign: TextAlign.end,
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                child: Align(
                  child: Text(
                    'Double click an order to close it',
                    style: TextStyle(fontSize: 11, color: lightGray),
                    textAlign: TextAlign.right,
                  ),
                  alignment: Alignment.bottomRight,
                )),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Expanded(
                  child: Text(
                    'ACTION',
                    style: TextStyle(
                      color: blurredGray,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'DETAIL',
                    style: TextStyle(
                      color: blurredGray,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'STATUS',
                    style: TextStyle(
                      color: blurredGray,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            BlocConsumer<MyOrdersCubit, MyOrdersState>(
                listener: (context, state) {
              if (state is CancelOrderSuccess) {
                showSnackBar(context, 'Order Cancelled Successfully',
                    type: SnackBarType.success);
                context.read<MyOrdersCubit>().getMyOpenOrders();
              } else if (state is CancelOrderFailure) {
                showSnackBar(context, state.error, type: SnackBarType.error);
              }
            }, builder: (context, state) {
              if (state is OpenOrdersSuccess) {
                final askOrders = state.openAskOrders;
                final bidOrders = state.openBidOrders;
                List<Widget> openOrders = buildList(askOrders, bidOrders);

                return Column(children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: openOrders.length,
                    itemBuilder: (context, index) {
                      bool isAsk = index < askOrders.length;
                      int orderId = isAsk
                          ? askOrders[index].id
                          : bidOrders[index - askOrders.length].id;
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
                ]);
              } else if (state is NoOpenOrders) {
                return (const Center(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('No Open Orders',
                          style: TextStyle(fontSize: 14, color: Colors.white))),
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
                          context.read<MyOrdersCubit>().getMyOpenOrders();
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
            })
          ]));

  List<Widget> buildList(List<Ask> askOrders, List<Bid> bidOrders) =>
      askOrders.map((e) => buildItem(e, OpenOrderType.ASK)).toList() +
      bidOrders.map((e) => buildItem(e, OpenOrderType.BID)).toList();

  Widget buildItem(openorder, OpenOrderType ordertype) {
    final stockList = getIt<GlobalStreams>().latestStockMap;
    Stock? company = stockList[openorder.stockId];

    return Card(
        color: background2,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Image.network(
                        'https://assets.airtel.in/static-assets/new-home/img/favicon-32x32.png',
                        height: 25,
                        width: 25,
                      )),
                  borderRadius: BorderRadius.circular(10)),
              Expanded(
                flex: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox.square(dimension: 10),
                      SizedBox(
                        width: 80,
                        child: Text(
                          (company?.fullName.toUpperCase())!,
                          style:
                              const TextStyle(fontSize: 12, color: lightGray),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox.square(dimension: 10),
                      Text(
                        (company?.shortName.toUpperCase())!,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox.square(dimension: 10),
                    ]),
              ),
              Expanded(
                flex: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox.square(dimension: 10),
                      const Text(
                        'TYPE',
                        style: TextStyle(fontSize: 9, color: lightGray),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                            '${ordertype.asString()} / ' +
                                openorder.orderType.name +
                                ' ORDER',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white)),
                      ),
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
                      const SizedBox.square(dimension: 10),
                    ]),
              ),
              Expanded(
                flex: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox.square(dimension: 10),
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
                          width: 80,
                          child: Text(
                            ISOtoDateTime(openorder.createdAt),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                            textAlign: TextAlign.right,
                          )),
                      const SizedBox.square(dimension: 10),
                    ]),
              )
            ]));
  }

  Center _tabletBody() {
    return const Center(
      child: Text(
        'Tablet UI will design soon :)',
        style: TextStyle(
          fontSize: 14,
          color: secondaryColor,
        ),
      ),
    );
  }
}
