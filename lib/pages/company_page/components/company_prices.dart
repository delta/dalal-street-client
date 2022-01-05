import 'package:dalal_street_client/components/buttons/secondary_button.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat('#,##0.00', 'en_US');

Container companyPrices(Stock company) {
  var priceChange =
      company.currentPrice.toInt() - company.previousDayClose.toInt();
  var priceChangePercentage =
      priceChange.toInt() / company.previousDayClose.toInt();
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      'https://i.imgur.com/v5E2Cv7.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
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
                    Text(
                      '₹ ' + oCcy.format(company.currentPrice).toString(),
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
                              (priceChangePercentage * 100).toStringAsFixed(2) +
                              '%)'
                          : oCcy.format(priceChange).toString() +
                              '  (' +
                              (priceChangePercentage * 100).toStringAsFixed(2) +
                              '%)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: priceChange > 0 ? secondaryColor : heartRed,
                      ),
                    ),
                  ],
                ),
                SecondaryButton(
                  height: 25,
                  width: 135,
                  fontSize: 14,
                  title: company.shortName,
                  onPressed: () {},
                ),
              ],
            ),
            _companyGraph()
          ]));
}

// TODO : Add Graph
Image _companyGraph() => Image.network('https://i.imgur.com/Y6CBCX2.png');
