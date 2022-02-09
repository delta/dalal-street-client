import 'package:dalal_street_client/blocs/mortgage/retrieve_sheet/retrieve_sheet_cubit.dart';
import 'package:dalal_street_client/components/sheet_pop_over.dart';
import 'package:dalal_street_client/constants/constants.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/proto_build/models/MortgageDetail.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class RetrieveBottomSheet extends StatefulWidget {
  final Stock company;
  final MortgageDetail mortgageDetail;
  const RetrieveBottomSheet(
      {Key? key, required this.company, required this.mortgageDetail})
      : super(key: key);

  @override
  _RetrieveBottomSheetState createState() => _RetrieveBottomSheetState();
}

class _RetrieveBottomSheetState extends State<RetrieveBottomSheet> {
  late int priceChange;
  int quantity = 1;
  late double totalPrice;
  @override
  Widget build(BuildContext context) {
    priceChange =
        (widget.company.currentPrice - widget.company.previousDayClose).toInt();
    quantity = 1;
    double mortgagePrice = widget.mortgageDetail.mortgagePrice.toDouble();
    totalPrice = mortgagePrice * RETRIEVE_DEPOSIT_RATE * quantity;
    return BlocProvider(
      create: (context) => RetrieveSheetCubit(),
      child: BlocConsumer<RetrieveSheetCubit, RetrieveSheetState>(
        listener: (context, state) {
          if (state is RetrieveSheetSuccess) {
            showSnackBar(context,
                'Successfully retrieved $quantity ${widget.company.fullName} stocks');
            Navigator.maybePop(context);
          } else if (state is RetrieveSheetFailure) {
            showSnackBar(context, state.msg);
            Navigator.maybePop(context);
          }
        },
        builder: (context, state) {
          if (state is RetrieveSheetLoading) {
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
                        _dynamicRetrieveDetails(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _retrieveStocks(context, quantity),
                            child: const Text('Retrieve'),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  )
                ]),
          );
        },
      ),
    );
  }

  void _retrieveStocks(BuildContext context, int quantity) {
    if (quantity > 0) {
      context.read<RetrieveSheetCubit>().retrieveStocks(widget.company.id,
          quantity, widget.mortgageDetail.mortgagePrice.toInt());
    }
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

  Widget _dynamicRetrieveDetails() {
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
                max: widget.mortgageDetail.stocksInBank.toDouble(),
                value: 01,
                onChanged: (value) {
                  setBottomSheetState(() {
                    quantity = value.toInt();
                    totalPrice = (widget.mortgageDetail.mortgagePrice.toInt() *
                        RETRIEVE_DEPOSIT_RATE *
                        quantity);
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
              'Total Amount',
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
        ],
      );
    });
  }
}
