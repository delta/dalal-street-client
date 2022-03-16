
import 'dart:html';

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
                    tabs: [
                       Tab(
                        child: Text('Listings'),
                      ),
                      Tab(
                        child: Text('My Orders'),
                      ),
                    ]),
                preferredSize: Size.fromHeight(30.0)),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(child: Center(child: BlocConsumer<IpoCubit, IpoState>(
                listener: (context, state)
                {
                  if(state is PlaceIpoSucess)
                  {
                      context.read<IpoCubit>().getipostocklist();
                       context.read<IpoOrdersCubit>().getmyipoorders();
                  }

                },
                builder: (context, state) {
                  if (state is GetIpoStockListSucess) {
                    Map<int, IpoStock> ipoStockList = state.Ipostocklist;
                    List<IpoStock> ipolist = ipoStockList.values.toList();

                    logger.i(state.toString());
                    logger.i(ipoStockList.length);
                    for (int i = 0; i < 2; i++) {
                      logger.i(ipolist[i].isBiddable);
                    }
                    return ListView.builder(
                        itemCount: ipolist.length,
                        itemBuilder: (context, index) {
                          return buildIpoItem(ipolist[index]);
                        });
                  } else {
                    logger.i(state.toString());
                   return const Center(
            child: DalalLoadingBar(),
          );
                  }
                },
              ))),
              Container(child: Center(child: BlocBuilder<IpoOrdersCubit,IpoOrdersState>(builder: (context, state)
              {
                if(state is GetMyIpoOrdersSucess)
                {
                  List<IpoBid> ipoStockList = state.Ipostocklist;
                  logger.i(ipoStockList.length);
                return ListView.builder(
                  itemCount: ipoStockList.length,
                  itemBuilder: (context, index) {
                    return Text(ipoStockList[index].id.toString());
                  });
                 
                
                  
                }
                else
                {
                  return(Text(state.toString()));
                }

              })
              ))
            ],
          ),
        ));
  }

  Widget buildIpoItem(IpoStock? ipoStock) {
    // return Text('${ipoStock?.fullName}',);
    if (ipoStock!.isBiddable) {
      return Card(
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
                              child:  Text('Open for Bids',
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
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Full Name',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              SizedBox.square(
                                dimension: 10,
                              ),
                              Text(
                                'Short Name',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              SizedBox.square(
                                dimension: 10,
                              ),
                              Text(
                                'Slot Price',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              SizedBox.square(
                                dimension: 10,
                              ),
                              Text(
                                'Slot Quantity',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              SizedBox.square(
                                dimension: 10,
                              ),
                              Text(
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
                         const   SizedBox.square(
                              dimension: 10,
                            ),
                            Text(
                              ipoStock.shortName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: white,
                              ),
                            ),
                         const   SizedBox.square(
                              dimension: 10,
                            ),
                            Text(
                              '₹' + ipoStock.slotPrice.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: white,
                              ),
                            ),
                          const  SizedBox.square(
                              dimension: 10,
                            ),
                            Text(
                              ipoStock.slotQuantity.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: white,
                              ),
                            ),
                         const   SizedBox.square(
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
                  padding: EdgeInsets.all(20),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<IpoCubit>().placeipobid(ipoStock.id,
                                  ipoStock.slotQuantity, ipoStock.stockPrice);
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
                            // const Align(alignment: Alignment.centerLeft,

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
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Full Name',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              SizedBox.square(
                                dimension: 10,
                              ),
                              Text(
                                'Short Name',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              SizedBox.square(
                                dimension: 10,
                              ),
                              Text(
                                'Slot Price',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              SizedBox.square(
                                dimension: 10,
                              ),
                              Text(
                                'Slot Quantity',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: lightGray,
                                ),
                              ),
                              SizedBox.square(
                                dimension: 10,
                              ),
                              Text(
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
}
