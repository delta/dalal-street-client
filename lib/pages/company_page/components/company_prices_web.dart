import 'package:dalal_street_client/config/config.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/pages/company_page/components/choose_buy_or_sell_bottom_sheet.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/streams/transformations.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat('#,##0.00', 'en_US');

Container companyPricesForWeb(Stock company, BuildContext context, int cash) {
  Int64 previousDayClose = company.previousDayClose;
  Int64 priceChange = company.currentPrice - previousDayClose;
  Stream<Int64> priceStream =
      getIt<GlobalStreams>().stockMapStream.priceStream(company.id);
  return Container(
      padding: const EdgeInsets.only(top: 40, left: 100, right: 100),
      color: background2,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      '$assetUrl${company.shortName}.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (company.givesDividends)
                      Row(
                        children: [
                          Text(
                            company.fullName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset(AppIcons.dollar)
                        ],
                      )
                    else
                      Text(
                        company.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    StreamBuilder<Int64>(
                        stream: priceStream,
                        initialData: company.currentPrice,
                        builder: (context, state) {
                          Int64 stockPrice = state.data!;
                          priceChange = stockPrice - previousDayClose;
                          bool isLowOrHigh = stockPrice > previousDayClose;

                          double percentageHighOrLow;

                          if (previousDayClose == 0) {
                            percentageHighOrLow = stockPrice.toDouble();
                          } else {
                            percentageHighOrLow = ((stockPrice.toDouble() -
                                        previousDayClose.toDouble()) /
                                    previousDayClose.toDouble()) *
                                100;
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '₹ ' + oCcy.format(state.data).toString(),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: white,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              !company.isBankrupt
                                  ? Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        Text(
                                            '+${oCcy.format(priceChange.abs()).toString()} ',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: isLowOrHigh
                                                    ? secondaryColor
                                                    : heartRed)),
                                        Text(
                                            '(${oCcy.format(percentageHighOrLow.abs()).toString()}%) ',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: isLowOrHigh
                                                    ? secondaryColor
                                                    : heartRed)),
                                      ],
                                    )
                                  : const SizedBox()
                            ],
                          );
                        }),
                  ],
                ),
                Container(
                  height: 70,
                  alignment: Alignment.centerRight,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 75),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        chooseBuyOrSellBottomSheet(context, company, cash);
                      },
                      child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 60),
                          child: Text('Place Your Order')),
                    ),
                  ),
                ),
              ],
            ),
          ]));
}
