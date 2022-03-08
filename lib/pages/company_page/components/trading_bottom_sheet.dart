import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/components/sheet_pop_over.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/proto_build/models/OrderType.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/utils/calculations.dart';
import 'package:fixnum/fixnum.dart';
import 'package:dalal_street_client/blocs/place_order/place_order_cubit.dart';
import 'package:dalal_street_client/components/buttons/secondary_button.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat('#,##0.00', 'en_US');

// TODO: text field validation message
void tradingBottomSheet(BuildContext context, int stockId, bool isAsk) {
  // getting user cash and company data from global streams
  var cash = getIt<GlobalStreams>().dynamicUserInfoStream.value.cash;
  var company = getIt<GlobalStreams>().stockMapStream.value[stockId]!;

  // data variables related to buy/sell logics
  int quantity = 1;
  var price = 0;
  int orderFee = 0;
  var orderType = OrderType.LIMIT;
  var selectedOrderType = 'Limit';

  Widget _tradingBottomSheetBody() {
    return StatefulBuilder(
      builder: (context, setBottomSheetState) {
        List<String> orderTypes = [
          'Limit',
          'Market',
          'Stop Loss',
        ];

        var priceChange =
            (company.currentPrice - company.previousDayClose).toInt();

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setBottomSheetState) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SheetPopOver(),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Column(
                        children: [
                          _stockNameAndPrice(company, priceChange, isAsk),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Number of Stocks',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  width: 150,
                                  padding: EdgeInsets.zero,
                                  child: SpinBox(
                                    min: 1,
                                    max: 50,
                                    value: 01,
                                    onChanged: (value) {
                                      setBottomSheetState(() {
                                        quantity = value.toInt();

                                        orderFee =
                                            calculateOrderFee(price * quantity);
                                      });
                                    },
                                    readOnly: true,
                                    iconColor:
                                        MaterialStateProperty.all(primaryColor),
                                    cursorColor: primaryColor,
                                    spacing: 15,
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none),
                                    textStyle: const TextStyle(
                                      color: primaryColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              ]),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  spacing: 15,
                                  children: [
                                    const Text(
                                      'Price ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          isExpanded: true,
                                          value: selectedOrderType,
                                          onChanged: (newValue) {
                                            setBottomSheetState(() {
                                              selectedOrderType =
                                                  newValue.toString();

                                              if (selectedOrderType ==
                                                  'Market') {
                                                orderType = OrderType.MARKET;
                                                price = company.currentPrice
                                                    .toInt();
                                              } else if (selectedOrderType ==
                                                  'Limit') {
                                                orderType = OrderType.LIMIT;
                                                price = 0;
                                              } else if (selectedOrderType ==
                                                  'Stop Loss') {
                                                orderType = OrderType.STOPLOSS;
                                                price = 0;
                                              }

                                              orderFee = calculateOrderFee(
                                                  price * quantity);
                                            });
                                          },
                                          items: orderTypes.map((type) {
                                            return DropdownMenuItem(
                                              child: Text(
                                                type,
                                                style: const TextStyle(
                                                    fontSize: 14, color: gold),
                                              ),
                                              value: type,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (selectedOrderType == 'Market') ...[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '₹' +
                                            oCcy
                                                .format(company.currentPrice)
                                                .toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: primaryColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  )
                                ] else if (selectedOrderType == 'Limit') ...[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                          width: 150,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Price per stock',
                                                labelStyle:
                                                    TextStyle(fontSize: 14),
                                                contentPadding:
                                                    EdgeInsets.all(8),
                                                errorStyle: TextStyle(
                                                  fontSize: 11.0,
                                                  color: bronze,
                                                )),
                                            onChanged: (String? value) {
                                              if (value != null) {
                                                price = int.parse(value);
                                              } else {
                                                price = 0;
                                              }
                                              setBottomSheetState(() {
                                                orderFee = calculateOrderFee(
                                                    price * quantity);
                                              });
                                            },
                                          )),
                                    ],
                                  )
                                ] else ...[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: TextField(
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Price per stock',
                                                contentPadding:
                                                    EdgeInsets.all(8),
                                                labelStyle:
                                                    TextStyle(fontSize: 11.0)),
                                            onChanged: (String? value) {
                                              if (value != null) {
                                                price = int.parse(value);
                                              } else {
                                                price = 0;
                                              }
                                              setBottomSheetState(() {
                                                orderFee = calculateOrderFee(
                                                    price * quantity);
                                              });
                                            }),
                                      ),
                                    ],
                                  )
                                ],
                              ]),
                          const SizedBox(
                            height: 30,
                          ),
                          _orderFee(orderFee),
                          _userBalance(cash),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<PlaceOrderCubit>().placeOrder(
                                    isAsk,
                                    company.id,
                                    orderType,
                                    Int64(price),
                                    Int64(quantity));
                              },
                              child: const Text('Place Order'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: background2,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider(
          create: (context) => PlaceOrderCubit(),
          child: BlocConsumer<PlaceOrderCubit, PlaceOrderState>(
            listener: (context, state) {
              if (state is PlaceOrderSuccess) {
                Navigator.pop(context);
              } else if (state is PlaceOrderFailure) {
                Navigator.pop(context);
                showSnackBar(context, state.statusMessage,
                    type: SnackBarType.error);
              }
            },
            builder: (context, state) {
              if (state is PlaceOrderLoading) {
                return const Center(child: DalalLoadingBar());
              }

              return _tradingBottomSheetBody();
            },
          ),
        );
      });
}

Row _userBalance(int cash) {
  return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
    SvgPicture.asset(
      AppIcons.balance,
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
  ]);
}

Row _orderFee(int orderFee) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    const Text(
      'Order Fee',
      style: TextStyle(
        fontSize: 18,
        color: Colors.white70,
      ),
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '₹' + oCcy.format(orderFee).toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 18,
          ),
        ),
      ],
    ),
  ]);
}

Row _stockNameAndPrice(Stock company, int priceChange, bool isAsk) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  oCcy.format(company.currentPrice).toString(),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  priceChange >= 0
                      ? '+' + oCcy.format(priceChange).toString()
                      : oCcy.format(priceChange).toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: priceChange > 0 ? secondaryColor : heartRed,
                  ),
                ),
              ],
            ),
          ]),
      SecondaryButton(
        height: 25,
        width: 135,
        fontSize: 14,
        title: 'Order Type: ' + (isAsk ? 'Sell' : 'Buy'),
        onPressed: () {},
      ),
    ],
  );
}
