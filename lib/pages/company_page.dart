import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat('#,##0.00', 'en_US');

class CompanyPage extends StatefulWidget {
  final Stock company;
  const CompanyPage({Key? key, required this.company}) : super(key: key);

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  @override
  Widget build(BuildContext context) {
    logger.i(widget.company.toString());
    var priceChange =
        widget.company.currentPrice - widget.company.previousDayClose;
    var priceChangePercentage =
        priceChange.toInt() / widget.company.previousDayClose.toInt();
    return SafeArea(
      child: Responsive(
        mobile: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.company.fullName.toString(),
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
                          Text(
                            '₹ ' +
                                oCcy
                                    .format(widget.company.currentPrice)
                                    .toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            priceChange >= 0
                                ? '+' +
                                    oCcy.format(priceChange).toString() +
                                    '  (+' +
                                    (priceChangePercentage * 100)
                                        .toStringAsFixed(2) +
                                    '%)'
                                : oCcy.format(priceChange).toString() +
                                    '  (' +
                                    (priceChangePercentage * 100)
                                        .toStringAsFixed(2) +
                                    '%)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  priceChange > 0 ? secondaryColor : heartRed,
                            ),
                          ),
                        ]))
              ],
            ),
          ),
        ),
        tablet: Container(),
        desktop: Container(),
      ),
    );
  }
}
