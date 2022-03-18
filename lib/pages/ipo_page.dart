// ignore_for_file: invalid_use_of_protected_member

import 'package:dalal_street_client/blocs/ipo/ipo_cubit.dart';
import 'package:dalal_street_client/blocs/ipo_orders/ipo_orders_cubit.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/proto_build/models/IpoStock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../components/loading.dart';
import '../proto_build/models/IpoBid.pb.dart';

class IpoPage extends StatefulWidget {
  const IpoPage({Key? key}) : super(key: key);

  @override
  _IpoPageState createState() => _IpoPageState();
}

class _IpoPageState extends State<IpoPage> {
  List<IpoStock> ipolist = [];
  @override
  void initState() {
    context.read<IpoCubit>().getipostocklist();
    context.read<IpoOrdersCubit>().getmyipoorders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('IPO Listings', style: TextStyle(fontSize: 20.0)),
            bottom: PreferredSize(
                child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    isScrollable: true,
                    unselectedLabelColor: Colors.white.withOpacity(0.3),
                    indicatorColor: Colors.white,
                    // ignore: prefer_const_literals_to_create_immutables
                    tabs: [
                      const Tab(
                        child: Text('Listings'),
                      ),
                      const Tab(
                        child: Text('My Orders'),
                      ),
                    ]),
                preferredSize: const Size.fromHeight(30.0)),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: BlocConsumer<IpoCubit, IpoState>(
                    listener: (context, state) {
                      if (state is PlaceIpoSucess) {
                        context.read<IpoCubit>().getipostocklist();
                        // ignore: invalid_use_of_visible_for_testing_member
                        context.read<IpoOrdersCubit>().emit(IpoOrdersInitial());
                      }
                    },
                    builder: (context, state) {
                      if (state is GetIpoStockListSucess) {
                        Map<int, IpoStock> ipoStockList = state.Ipostocklist;

                        ipolist = ipoStockList.values.toList();

                        return ListView.builder(
                            itemCount: ipolist.length,
                            itemBuilder: (context, index) {
                              return buildIpoItem(ipolist[index]);
                            });
                      } else {
                        return const Center(
                          child: DalalLoadingBar(),
                        );
                      }
                    },
                  ))),
              Column(children: [
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
                const SizedBox(height: 20),
                Center(
                    child: BlocConsumer<IpoOrdersCubit, IpoOrdersState>(
                        listener: (context, state) {
                  if (state is CancelIpoBidSucess) {
                    context.read<IpoOrdersCubit>().getmyipoorders();
                  }
                }, builder: (context, state) {
                  if (state is GetMyIpoOrdersSucess) {
                    List<IpoBid> myipoStockList = state.Ipostocklist;

                    if (myipoStockList.isEmpty) {
                      return (const Center(
                          child: Text(
                        'No IPO Orders',
                        style: TextStyle(color: white, fontSize: 16),
                      )));
                    } else {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height - 183,
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: myipoStockList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  child:
                                      buildIpoOrderItem(myipoStockList[index]),
                                  onDoubleTap: () {
                                    context
                                        .read<IpoOrdersCubit>()
                                        .cancelipobids(
                                            myipoStockList[index].id);
                                  });
                            },
                            separatorBuilder: (context, index) => const Divider(
                              color: white,
                            ),
                          ));
                    }
                  } else if (state is GetMyIpoOrdersFailure) {
                    logger.e(state.msg);
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
                              context.read<IpoOrdersCubit>().getmyipoorders();
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
                }))
              ])
            ],
          ),
        ));
  }

  Widget buildIpoItem(IpoStock? ipoStock) {
    if (ipoStock!.isBiddable) {
      return Card(
        margin:const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: background2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(children: [
                  SvgPicture.network(
                    'https://upload.wikimedia.org/wikipedia/commons/9/9a/BTC_Logo.svg',
                    height: 50,
                    width: 50,
                  ),
                  const SizedBox.square(
                    dimension: 10,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ipoStock.fullName,
                          style: const TextStyle(fontSize: 16, color: white),
                        ),
                        const SizedBox.square(
                          dimension: 10,
                        ),
                        Container(
                          child: const Padding(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: Text('Open for Bids',
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 14,
                                  ))),
                          decoration: BoxDecoration(
                            color: baseColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ]),
                ]),
              ),
              const SizedBox.square(
                dimension: 10,
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    ipoStock.description,
                    style: const TextStyle(
                        fontSize: 13,
                        color: white,
                        overflow: TextOverflow.ellipsis),
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Text(
                                'Full Name',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              const SizedBox.square(
                                dimension: 10,
                              ),
                              const Text(
                                'Short Name',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              const SizedBox.square(
                                dimension: 10,
                              ),
                              const Text(
                                'Slot Price',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              const SizedBox.square(
                                dimension: 10,
                              ),
                              const Text(
                                'Slot Quantity',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              const SizedBox.square(
                                dimension: 10,
                              ),
                              const Text(
                                'Stocks per slot',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              )
                            ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              ipoStock.fullName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: white,
                              ),
                            ),
                            const SizedBox.square(
                              dimension: 10,
                            ),
                            Text(
                              ipoStock.shortName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: white,
                              ),
                            ),
                            const SizedBox.square(
                              dimension: 10,
                            ),
                            Text(
                              '₹' + ipoStock.slotPrice.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: white,
                              ),
                            ),
                            const SizedBox.square(
                              dimension: 10,
                            ),
                            Text(
                              ipoStock.slotQuantity.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: white,
                              ),
                            ),
                            const SizedBox.square(
                              dimension: 10,
                            ),
                            Text(
                              ipoStock.stocksPerSlot.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: white,
                              ),
                            )
                          ],
                        ),
                      ])),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: ()async {
                              await context.read<IpoCubit>().placeipobid(
                                  ipoStock.id, 1, ipoStock.stockPrice);

                                   await context.read<IpoOrdersCubit>().getmyipoorders();

                            },
                            child: const Text(
                              'Place Bid',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.black),
                            ),
                          )))),
              const Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    child: Text(
                      'NOTE: If your IPO bid is closed, the bid amount is returned back to the user',
                      style: TextStyle(
                        fontSize: 9,
                        color: lightGray,
                      ),
                    ),
                    alignment: Alignment.center,
                  ))
            ],
          ));
    } else {
      return Card(
        margin:const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: background2,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SvgPicture.network(
                        'https://upload.wikimedia.org/wikipedia/commons/9/9a/BTC_Logo.svg',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox.square(
                        dimension: 10,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ipoStock.fullName,
                              style:
                                  const TextStyle(fontSize: 16, color: white),
                            ),
                            const SizedBox.square(
                              dimension: 10,
                            ),

                            const Text('Bids Closed',
                                style: TextStyle(color: red, fontSize: 11))
                            // )
                          ])
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    ipoStock.description,
                    style: const TextStyle(
                        fontSize: 13,
                        color: white,
                        overflow: TextOverflow.ellipsis),
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Text(
                                'Full Name',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              const SizedBox.square(
                                dimension: 10,
                              ),
                              const Text(
                                'Short Name',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              const SizedBox.square(
                                dimension: 10,
                              ),
                              const Text(
                                'Slot Price',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              const SizedBox.square(
                                dimension: 10,
                              ),
                              const Text(
                                'Slot Quantity',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              const SizedBox.square(
                                dimension: 10,
                              ),
                              const Text(
                                'Stocks per slot',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              )
                            ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              ipoStock.fullName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: white,
                              ),
                            ),
                            const SizedBox.square(
                              dimension: 10,
                            ),
                            Text(
                              ipoStock.shortName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: white,
                              ),
                            ),
                            const SizedBox.square(
                              dimension: 10,
                            ),
                            Text(
                              '₹' + ipoStock.slotPrice.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: white,
                              ),
                            ),
                            const SizedBox.square(
                              dimension: 10,
                            ),
                            Text(
                              ipoStock.slotQuantity.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: white,
                              ),
                            ),
                            const SizedBox.square(
                              dimension: 10,
                            ),
                            Text(
                              ipoStock.stocksPerSlot.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: white,
                              ),
                            )
                          ],
                        ),
                      ])),
              const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Bids are closed',
                    style: TextStyle(fontSize: 13, color: red),
                  ))
            ],
          ));
    }
  }

  getipo(List<IpoStock> ipolist, int ipoStockId) {
    for (var ipo in ipolist) {
      if (ipo.id == ipoStockId) {
        return ipo;
      }
    }
  }

  Widget buildIpoOrderItem(IpoBid myipoStock) {
    return Card(
        color: background2,
        child: Padding(
            padding: const EdgeInsets.all(10),

            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.network(
                        'https://upload.wikimedia.org/wikipedia/commons/9/9a/BTC_Logo.svg',
                        height: 25,
                        width: 25,
                      )),
                  SizedBox(
                      width: 50,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getipo(ipolist, myipoStock.ipoStockId)
                                  .fullName
                                  .toString()
                                  .toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 11, color: lightGray),
                            ),
                            const SizedBox.square(
                              dimension: 10,
                            ),
                            Text(
                              getipo(ipolist, myipoStock.ipoStockId)
                                  .shortName
                                  .toString()
                                  .toUpperCase(),
                              style:
                                  const TextStyle(fontSize: 13, color: white),
                            ),
                          ]))
                ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'QUANTITY',
                      style: TextStyle(color: lightGray, fontSize: 9),
                    ),
                    Text(
                      myipoStock.slotQuantity.toString(),
                      style: const TextStyle(color: white, fontSize: 11),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'PRICE',
                      style: TextStyle(color: lightGray, fontSize: 9),
                    ),
                    Text(
                      '₹' '${myipoStock.slotPrice}' ' per slot',
                      style: const TextStyle(
                        fontSize: 11,
                        color: white,
                      ),
                    ),
                  ],
                ),
                checkmyIpoStatus(myipoStock)
              ],
            )));
  }

  Widget checkmyIpoStatus(IpoBid myipoStock) {
    if (!myipoStock.isClosed && !myipoStock.isFulfilled) {
      return pending();
    } else if (myipoStock.isFulfilled) {
      return fullfilled();
    } else {
      return closed();
    }
  }

  Widget pending() {
    return Container(
      child: const Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Text('Pending',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 9,
              ))),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget fullfilled() {
    return Container(
      child: const Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Text('Fulfilled',
              style: TextStyle(
                color: secondaryColor,
                fontSize: 9,
              ))),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget closed() {
    return Container(
      child: const Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Text('Closed',
              style: TextStyle(
                color: red,
                fontSize: 9,
              ))),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
