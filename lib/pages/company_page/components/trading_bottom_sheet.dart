import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/constants.dart';
import 'package:dalal_street_client/proto_build/models/OrderType.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:dalal_street_client/blocs/place_order/place_order_cubit.dart';
import 'package:dalal_street_client/components/buttons/primary_button.dart';
import 'package:dalal_street_client/components/buttons/secondary_button.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/pages/company_page/components/calculate_order_fee.dart';
import 'package:dalal_street_client/pages/company_page/components/show_price_window.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat('#,##0.00', 'en_US');

void tradingBottomSheet(
    BuildContext context, Stock company, String orderType, int cash) {
  int priceChange = (company.currentPrice - company.previousDayClose).toInt();
  int quantity = 1;
  int totalPrice = company.currentPrice.toInt() * quantity;
  int orderFee = calculateOrderFee(totalPrice);
  String error = 'false';
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return BlocProvider(
          create: (context) => PlaceOrderCubit(),
          child: BlocConsumer<PlaceOrderCubit, PlaceOrderState>(
            listener: (context, state) {
              if (state is PlaceOrderSuccess) {
                logger.i('order placed');
                Navigator.pop(context);
                showSnackBar(context,
                    'Order successfully placed with Order ID: ${state.orderId}');
              } else if (state is PlaceOrderFailure) {
                logger.i('unsuccessful');
                Navigator.pop(context);
                showSnackBar(context, state.statusMessage);
              }
            },
            builder: (context, state) {
              if (state is PlaceOrderLoading) {
                logger.i('loading');
                return const Center(child: CircularProgressIndicator());
              } else if (state is PlaceOrderFailure) {
                logger.i('unsuccessful');
              }
              return BottomSheet(
                backgroundColor: backgroundColor,
                builder: (context) {
                  List<String> priceTypeMap = [
                    'Limit',
                    'Market',
                    'Stop Loss',
                  ];
                  priceChange =
                      (company.currentPrice - company.previousDayClose).toInt();
                  quantity = 1;
                  totalPrice = company.currentPrice.toInt() * quantity;
                  orderFee = calculateOrderFee(totalPrice);
                  var selectedPriceType = 'Limit';
                  OrderType priceType = OrderType.LIMIT;
                  bool isAsk = true;
                  if (orderType == 'Sell') isAsk = false;
                  var orderPriceWindow = showPriceWindow(totalPrice);
                  return StatefulBuilder(builder:
                      (BuildContext context, StateSetter setBottomSheetState) {
                    return Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
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
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: SvgPicture.asset(
                                        AppIcons().crossWhite)),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              company.shortName,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            Wrap(
                                              spacing: 4,
                                              children: [
                                                Text(
                                                  oCcy
                                                      .format(
                                                          company.currentPrice)
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  priceChange >= 0
                                                      ? '+' +
                                                          oCcy
                                                              .format(
                                                                  priceChange)
                                                              .toString()
                                                      : oCcy
                                                          .format(priceChange)
                                                          .toString(),
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
                                      SecondaryButton(
                                        height: 25,
                                        width: 135,
                                        fontSize: 14,
                                        title: 'Order Type: ' + orderType,
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Number of Stocks',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          height: 30,
                                          child: SpinBox(
                                            min: 1,
                                            max: 100,
                                            value: 01,
                                            onChanged: (value) {
                                              setBottomSheetState(() {
                                                quantity = value.toInt();
                                                totalPrice = company
                                                        .currentPrice
                                                        .toInt() *
                                                    quantity;
                                                orderPriceWindow;
                                                orderFee = calculateOrderFee(
                                                    totalPrice);
                                              });
                                            },
                                            cursorColor: primaryColor,
                                            textAlign: TextAlign.center,
                                            iconColor:
                                                MaterialStateProperty.all(
                                                    primaryColor),
                                          ),
                                        )
                                      ]),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Wrap(
                                          spacing: 15,
                                          children: [
                                            const Text(
                                              'Price',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white70,
                                              ),
                                            ),
                                            DropdownButton(
                                              value: selectedPriceType,
                                              onChanged: (newValue) {
                                                setBottomSheetState(() {
                                                  selectedPriceType =
                                                      newValue.toString();
                                                  logger.i(selectedPriceType);
                                                  if (selectedPriceType ==
                                                      'Market') {
                                                    priceType =
                                                        OrderType.MARKET;
                                                  } else if (selectedPriceType ==
                                                      'Limit') {
                                                    priceType = OrderType.LIMIT;
                                                  } else if (selectedPriceType ==
                                                      'Stop Loss') {
                                                    priceType =
                                                        OrderType.STOPLOSS;
                                                  }
                                                  logger
                                                      .i(priceType.toString());
                                                });
                                              },
                                              items: priceTypeMap.map((type) {
                                                return DropdownMenuItem(
                                                  child: Text(
                                                    type,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            whiteWithOpacity75),
                                                  ),
                                                  value: type,
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                        if (selectedPriceType == 'Market') ...[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '₹' +
                                                    oCcy
                                                        .format(totalPrice)
                                                        .toString(),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          )
                                        ] else if (selectedPriceType ==
                                            'Limit') ...[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                  width: 150,
                                                  child: TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                'Price per stock',
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            errorStyle:
                                                                TextStyle(
                                                              fontSize: 11.0,
                                                              color: bronze,
                                                            )),
                                                    onChanged: (String? value) {
                                                      if (value != null) {
                                                        totalPrice =
                                                            int.parse(value);
                                                      } else {
                                                        totalPrice = 0;
                                                      }
                                                    },
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    validator: (text) {
                                                      if (text == null ||
                                                          text.isEmpty) {
                                                        return 'Can\'t be empty';
                                                      }
                                                      if (int.parse(text)
                                                                  .toDouble() <
                                                              company.currentPrice
                                                                      .toDouble() *
                                                                  (1 -
                                                                      ORDER_PRICE_WINDOW
                                                                              .toDouble() /
                                                                          100) ||
                                                          int.parse(text)
                                                                  .toDouble() >
                                                              company.currentPrice
                                                                      .toDouble() *
                                                                  (1 +
                                                                      ORDER_PRICE_WINDOW
                                                                              .toDouble() /
                                                                          100)) {
                                                        error = 'true';
                                                        return 'Out of range';
                                                      }
                                                      {
                                                        error = 'false';
                                                        return null;
                                                      }
                                                    },
                                                  )),
                                              Text(
                                                // orderPriceWindow,
                                                showPriceWindow(company
                                                    .currentPrice
                                                    .toInt()),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: bronze,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          )
                                        ] else ...[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: 200,
                                                child: TextField(
                                                    decoration: const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText:
                                                            'Price per stock',
                                                        contentPadding:
                                                            EdgeInsets.all(8),
                                                        labelStyle: TextStyle(
                                                            fontSize: 11.0)),
                                                    onChanged: (String? value) {
                                                      if (value != null) {
                                                        totalPrice =
                                                            int.parse(value);
                                                      } else {
                                                        totalPrice = 0;
                                                      }
                                                    }),
                                              ),
                                            ],
                                          )
                                        ],
                                      ]),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Order Fee',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '₹' +
                                                  oCcy
                                                      .format(orderFee)
                                                      .toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: primaryColor,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons().balance,
                                        ),
                                        const Text(
                                          ' Balance :',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        Text(
                                          ' ₹' + oCcy.format(cash).toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ]),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  PrimaryButton(
                                      height: 45,
                                      width: 340,
                                      fontSize: 18,
                                      title: 'Place Order',
                                      onPressed: () {
                                        error == 'true'
                                            ? null
                                            : [
                                                logger.i(cash),
                                                context
                                                    .read<PlaceOrderCubit>()
                                                    .placeOrder(
                                                        isAsk,
                                                        company.id,
                                                        priceType,
                                                        Int64(totalPrice),
                                                        Int64(quantity)),
                                                logger.i(cash),
                                                logger.i(
                                                    '$isAsk, ${company.id}, ${company.shortName}, $quantity, $totalPrice, $priceType.toString()'),
                                              ];
                                      })
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
                onClosing: () {},
              );
            },
          ),
        );
      });
}
