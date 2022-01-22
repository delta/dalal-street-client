import 'package:dalal_street_client/blocs/mortgage/sheet/cubit/mortgage_sheet_cubit.dart';
import 'package:dalal_street_client/constants/constants.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MortgageBottomSheet extends StatefulWidget {
  final Stock company;
  const MortgageBottomSheet({Key? key, required this.company})
      : super(key: key);

  @override
  _MortgageBottomSheetState createState() => _MortgageBottomSheetState();
}

class _MortgageBottomSheetState extends State<MortgageBottomSheet> {
  late int priceChange;
  int quantity = 1;
  late double totalPrice;

  @override
  Widget build(BuildContext context) {
    priceChange =
        (widget.company.currentPrice - widget.company.previousDayClose).toInt();
    quantity = 1;
    double mortgagePrice =
        widget.company.currentPrice.toInt() * MORTGAGE_DEPOSIT_RATE;
    totalPrice = mortgagePrice * quantity;
    return BlocProvider(
      create: (context) => MortgageSheetCubit(),
      child: BlocConsumer<MortgageSheetCubit, MortgageSheetState>(
        listener: (context, state) {
          if (state is MortgageSheetSuccess) {
            showSnackBar(context,
                'Successfully mortgaged $quantity ${widget.company.fullName} stocks');
            Navigator.maybePop(context);
          } else if (state is MortgageSheetFailure) {
            showSnackBar(context, state.msg);
            Navigator.maybePop(context);
          }
        },
        builder: (context, state) {
          if (state is MortgageSheetLoading) {
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
                  _buildPopOver(),
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
                        _dynamicMortgageDetails(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (quantity > 0) {
                                context
                                    .read<MortgageSheetCubit>()
                                    .mortgageStocks(
                                        widget.company.id, quantity);
                              }
                            },
                            child: const Text('Mortgage'),
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
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(AppIcons.crossWhite)),
            ],
          ),
        ),
      ],
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

  Widget _dynamicMortgageDetails() {
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
                    totalPrice = (widget.company.currentPrice.toInt() *
                        MORTGAGE_DEPOSIT_RATE *
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
