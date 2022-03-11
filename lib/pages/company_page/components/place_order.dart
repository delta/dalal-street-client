import 'package:dalal_street_client/blocs/place_order/place_order_cubit.dart';
import 'package:dalal_street_client/components/buttons/secondary_button.dart';
import 'package:dalal_street_client/components/sheet_pop_over.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/proto_build/models/OrderType.pb.dart';
import 'package:dalal_street_client/proto_build/models/OrderType.pbenum.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/calculations.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/format.dart';

class PlaceOrder extends StatefulWidget {
  final bool isAsk;
  final int stockId;

  PlaceOrder({Key? key, required this.isAsk, required this.stockId})
      : super(key: key);

  List<OrderType> orderTypes = [
    OrderType.LIMIT,
    OrderType.MARKET,
    OrderType.STOPLOSS
  ];

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  int _quantity = 1;
  int _price = 0;
  OrderType _orderType = OrderType.LIMIT;

  get orderTypeString => (OrderType orderType) {
        if (orderType == OrderType.LIMIT) {
          return 'Limit';
        }

        if (orderType == OrderType.MARKET) {
          return 'Market';
        }

        return 'Stoploss';
      };

  final priceTextController = TextEditingController();

  @override
  void dispose() {
    priceTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final company = getIt<GlobalStreams>().latestStockMap[widget.stockId]!;

    return SingleChildScrollView(
        child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                  _stockNameAndPrice(company, widget.isAsk),
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
                            value: 1,
                            onChanged: (value) {
                              setState(() {
                                _quantity = value.toInt();
                              });
                            },
                            readOnly: true,
                            iconColor: MaterialStateProperty.all(primaryColor),
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
                              width: 90,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: orderTypeString(_orderType),
                                  onChanged: (value) {
                                    logger.d(value);
                                    String orderTypeString = value.toString();
                                    OrderType selectedOrderType;

                                    if (orderTypeString == 'Market') {
                                      logger.i('market');
                                      selectedOrderType = OrderType.MARKET;

                                      setState(() {
                                        _price = company.currentPrice.toInt();
                                        _orderType = selectedOrderType;
                                      });
                                    } else if (orderTypeString == 'Stoploss') {
                                      logger.i('stoploss');
                                      selectedOrderType = OrderType.STOPLOSS;

                                      setState(() {
                                        _orderType = selectedOrderType;
                                        _price = 0;
                                      });
                                    } else if (orderTypeString == 'Limit') {
                                      logger.i('limit');
                                      selectedOrderType = OrderType.LIMIT;

                                      setState(() {
                                        _orderType = selectedOrderType;
                                        _price = 0;
                                      });
                                    }

                                    priceTextController.value =
                                        TextEditingValue.empty;
                                  },
                                  items: ['Limit', 'Market', 'Stoploss']
                                      .map((type) {
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
                        if (_orderType == OrderType.MARKET) ...[
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
                        ] else if (_orderType == OrderType.LIMIT) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                  width: 150,
                                  child: TextFormField(
                                    controller: priceTextController,
                                    initialValue: null,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Price per stock',
                                        labelStyle: TextStyle(fontSize: 14),
                                        contentPadding: EdgeInsets.all(8),
                                        errorStyle: TextStyle(
                                          fontSize: 11.0,
                                          color: bronze,
                                        )),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        setState(() {
                                          _price = int.parse(value);
                                        });
                                      }
                                    },
                                    validator: (String? value) {
                                      if (value == null || value == '0') {
                                        return 'Enter a positive value';
                                      }

                                      if (value.isNotEmpty && value[0] == '0') {
                                        return 'Enter a valid value';
                                      }

                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  )),
                            ],
                          )
                        ] else if (_orderType == OrderType.STOPLOSS) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 150,
                                child: TextFormField(
                                  controller: priceTextController,
                                  initialValue: null,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Price per stock',
                                      labelStyle: TextStyle(fontSize: 14),
                                      contentPadding: EdgeInsets.all(8),
                                      errorStyle: TextStyle(
                                        fontSize: 11.0,
                                        color: bronze,
                                      )),
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      setState(() {
                                        _price = int.parse(value);
                                      });
                                    }
                                  },
                                  validator: (String? value) {
                                    if (value == null) {
                                      return 'Enter a positive value';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ]),
                  const SizedBox(
                    height: 30,
                  ),
                  _orderFee(_price, _quantity),
                  _userBalance(),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<PlaceOrderCubit>().placeOrder(
                            widget.isAsk,
                            company.id,
                            _orderType,
                            Int64(_price),
                            Int64(_quantity));

                        Navigator.pop(context);
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
    ));
  }
}

Row _userBalance() {
  int cash = getIt<GlobalStreams>().dynamicUserInfoStream.value.cash;
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

Row _orderFee(int price, int quantity) {
  logger.d(price, quantity);
  var orderFee = calculateOrderFee(price * quantity);
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

Row _stockNameAndPrice(Stock company, bool isAsk) {
  var priceChange = company.currentPrice - company.previousDayClose;
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
