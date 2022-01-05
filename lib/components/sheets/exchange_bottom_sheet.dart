import 'package:dalal_street_client/blocs/exchange/sheet/exchange_sheet_cubit.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/constants.dart';
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

// todo: svg error in mobile loading assets
// todo: bottom sheet transition animation not working
// todo: fix text input in mobile
class ExchangeBottomSheet extends StatefulWidget {
  final Stock company;
  const ExchangeBottomSheet({Key? key, required this.company})
      : super(key: key);

  @override
  _ExchangeBottomSheetState createState() => _ExchangeBottomSheetState();
}

class _ExchangeBottomSheetState extends State<ExchangeBottomSheet>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    int priceChange =
        (widget.company.currentPrice - widget.company.previousDayClose).toInt();
    int quantity = 1;
    int totalPrice = widget.company.currentPrice.toInt() * quantity;
    int orderFee = _calculateOrderFee(totalPrice);
    return BlocProvider(
      create: (context) => ExchangeSheetCubit(),
      child: BlocConsumer<ExchangeSheetCubit, ExchangeSheetState>(
        listener: (context, state) {
          if (state is ExchangeSheetSuccess) {
            showSnackBar(context,
                'Successfully bought $quantity ${widget.company.fullName} stocks');
            Navigator.maybePop(context);
          } else if (state is ExchangeSheetFailure) {
            showSnackBar(context, state.msg);
          }
        },
        builder: (context, state) {
          if (state is ExchangeSheetLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          } else if (state is ExchangeSheetFailure) {
            return Center(
              child: Text(state.msg),
            );
          }
          return BottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            enableDrag: true,
            backgroundColor: backgroundColor,
            animationController: BottomSheet.createAnimationController(this),
            builder: (context) {
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
                          _buildPopOver(),
                          const SizedBox(
                            height: 20,
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
                                            widget.company.shortName,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          Wrap(
                                            spacing: 4,
                                            children: [
                                              Text(
                                                '₹' +
                                                    oCcy
                                                        .format(widget.company
                                                            .currentPrice)
                                                        .toString(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                priceChange >= 0
                                                    ? '+' +
                                                        oCcy
                                                            .format(priceChange)
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
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                StatefulBuilder(
                                    builder: (context, setBottomSheetState) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
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
                                            Container(
                                              height: 30,
                                              width: 150,
                                              padding: EdgeInsets.zero,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                color: primaryColor
                                                    .withOpacity(0.2),
                                              ),
                                              child: SpinBox(
                                                min: 1,
                                                max: 100,
                                                value: 01,
                                                onChanged: (value) {
                                                  setBottomSheetState(() {
                                                    quantity = value.toInt();
                                                    totalPrice = widget.company
                                                            .currentPrice
                                                            .toInt() *
                                                        quantity;
                                                    orderFee =
                                                        _calculateOrderFee(
                                                            totalPrice);
                                                  });
                                                },
                                                iconColor:
                                                    MaterialStateProperty.all(
                                                        primaryColor),
                                                cursorColor: primaryColor,
                                                spacing: 10,
                                                readOnly: true,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        border:
                                                            InputBorder.none),
                                                textStyle: const TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              
                                            )
                                          ]),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Price',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white70,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    color: primaryColor
                                                        .withOpacity(0.2),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15,
                                                      vertical: 5),
                                                  child: Text(
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
                                                ),
                                              ],
                                            ),
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
                                    ],
                                  );
                                }),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                        ' ₹' +
                                            oCcy
                                                .format(
                                                    widget.company.currentPrice)
                                                .toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ]),
                                const SizedBox(
                                  height: 25,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (quantity > 0) {
                                      context
                                          .read<ExchangeSheetCubit>()
                                          .buyStocksFromExchange(
                                              widget.company.id, quantity);
                                    }
                                  },
                                  child: const Text('Buy Stocks from Exchange'),
                                )
                              ],
                            ),
                          )
                        ])),
              );
            },
            onClosing: () {},
          );
        },
      ),
    );
  }

  Widget _buildPopOver() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 150,
            height: 4.5,
            decoration: const BoxDecoration(
              color: lightGray,
              borderRadius: BorderRadius.all(Radius.circular(12)),
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
                child: SvgPicture.asset(AppIcons().crossWhite)),
          ],
        ),
      ],
    );
  }
}

int _calculateOrderFee(int totalPrice) {
  var orderFee = (ORDER_FEE_RATE * totalPrice);
  return orderFee.toInt();
}
