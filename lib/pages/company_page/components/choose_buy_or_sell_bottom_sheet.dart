import 'package:dalal_street_client/blocs/place_order/place_order_cubit.dart';
import 'package:dalal_street_client/components/buttons/secondary_button.dart';
import 'package:dalal_street_client/components/buttons/tertiary_button.dart';
import 'package:dalal_street_client/pages/company_page/components/place_order.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat('#,##0.00', 'en_US');

void chooseBuyOrSellBottomSheet(BuildContext context, Stock company, int cash) {
  int priceChange = (company.currentPrice - company.previousDayClose).toInt();
  showModalBottomSheet(
      backgroundColor: background2,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            SizedBox(
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 150,
                            height: 4.5,
                            decoration: const BoxDecoration(
                              color: lightGray,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        company.shortName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        company.fullName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: whiteWithOpacity50,
                                        ),
                                      ),
                                    ]),
                              ),
                              Column(
                                children: [
                                  Text(
                                    oCcy
                                        .format(company.currentPrice)
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    priceChange >= 0
                                        ? '+' +
                                            oCcy.format(priceChange).toString()
                                        : oCcy.format(priceChange).toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: priceChange > 0
                                          ? secondaryColor
                                          : heartRed,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SecondaryButton(
                                height: 50,
                                width: 150,
                                title: 'Sell',
                                fontSize: 18,
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25.0))),
                                      backgroundColor: background2,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return PlaceOrder(
                                            isAsk: true, stockId: company.id);
                                      });
                                },
                              ),
                              TertiaryButton(
                                height: 50,
                                width: 150,
                                title: 'Buy',
                                fontSize: 18,
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25.0))),
                                      backgroundColor: background2,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return PlaceOrder(
                                            isAsk: false, stockId: company.id);
                                      });
                                  // await showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return Dialog(
                                  //         shape: const RoundedRectangleBorder(
                                  //             borderRadius: BorderRadius.all(
                                  //                 Radius.circular(10))),
                                  //         backgroundColor: background2,
                                  //         child: BlocProvider(
                                  //           create: (context) =>
                                  //               PlaceOrderCubit(),
                                  //           child: SizedBox.expand(
                                  //             child: PlaceOrder(
                                  //                 isAsk: false,
                                  //                 stockId: company.id),
                                  //           ),
                                  //         ),
                                  //       );
                                  //     });
                                },
                              ),
                            ]),
                      ],
                    )),
              ),
            ),
          ],
        );
      });
}
