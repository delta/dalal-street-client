import 'package:dalal_street_client/blocs/exchange/sheet/exchange_sheet_cubit.dart';
import 'package:dalal_street_client/components/sheet_pop_over.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/streams/transformations.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/calculations.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_svg/flutter_svg.dart';

// todo: fix text input in mobile in future if flutter fixes it in its update
class ExchangeBottomSheet extends StatefulWidget {
  final Stock company;
  const ExchangeBottomSheet({Key? key, required this.company})
      : super(key: key);

  @override
  _ExchangeBottomSheetState createState() => _ExchangeBottomSheetState();
}

class _ExchangeBottomSheetState extends State<ExchangeBottomSheet> {
  late int priceChange;
  late int quantity;
  late int totalPrice;
  late int orderFee;
  final userInfoStream = getIt<GlobalStreams>().dynamicUserInfoStream;
  Stream<int> get cashStream => userInfoStream.cashStream();

  @override
  void initState() {
    super.initState();
    quantity = 1;
    cashStream.listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    priceChange =
        (widget.company.currentPrice - widget.company.previousDayClose).toInt();
    quantity = 1;
    totalPrice = widget.company.currentPrice.toInt() * quantity;
    orderFee = calculateOrderFee(totalPrice);
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
            Navigator.maybePop(context);
          }
        },
        builder: (context, state) {
          if (state is ExchangeSheetLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SheetPopOver(),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Column(
                      children: [
                        _staticCompanyDetails(),
                        const SizedBox(
                          height: 20,
                        ),
                        _dynamicExchangeDetails(),
                        _buyStocksFooter(context)
                      ],
                    ),
                  )
                ]),
          );
        },
      ),
    );
  }

  Widget _staticCompanyDetails() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    '₹' + oCcy.format(widget.company.currentPrice).toString(),
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
      ],
    );
  }

  Widget _dynamicExchangeDetails() {
    return StatefulBuilder(builder: (context, setBottomSheetState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: primaryColor.withOpacity(0.2),
              ),
              child: SpinBox(
                min: 1,
                max: 20,
                value: 01,
                onChanged: (value) {
                  setBottomSheetState(() {
                    quantity = value.toInt();
                    totalPrice = widget.company.currentPrice.toInt() * quantity;
                    orderFee = calculateOrderFee(totalPrice);
                  });
                },
                readOnly: true,
                iconColor: MaterialStateProperty.all(primaryColor),
                cursorColor: primaryColor,
                spacing: 15,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero, border: InputBorder.none),
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Price',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: primaryColor.withOpacity(0.2),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    '₹' + oCcy.format(totalPrice).toString(),
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
          ]),
        ],
      );
    });
  }

  Widget _buyStocksFooter(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
          StreamBuilder<int>(
              stream: cashStream,
              initialData: userInfoStream.value.cash,
              builder: (_, snapshot) {
                return Text(
                  ' ₹' + oCcy.format(snapshot.data).toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                );
              }),
        ]),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _buyStocksFromExchange(context),
            child: const Text('Buy Stocks from Exchange'),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  void _buyStocksFromExchange(BuildContext context) {
    if (quantity > 0) {
      context
          .read<ExchangeSheetCubit>()
          .buyStocksFromExchange(widget.company.id, quantity);
    }
  }
}
