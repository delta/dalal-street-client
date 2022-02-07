import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/pages/company_page/components/market_status_tile.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat('#,##0.00', 'en_US');

Column overView(Stock company) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 15,
      ),
      const Text(
        'About Company',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: white,
        ),
        textAlign: TextAlign.start,
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        company.description.toString(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: lightGray,
        ),
        textAlign: TextAlign.start,
      ),
      const SizedBox(
        height: 30,
      ),
      const Text(
        'Market Status',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: lightGray,
        ),
        textAlign: TextAlign.start,
      ),
      const SizedBox(
        height: 10,
      ),
      marketStatusTile(AppIcons.currentPrice, 'Current Price',
          oCcy.format(company.currentPrice).toString(), false, false),
      marketStatusTile(AppIcons.dayHigh, 'Day High',
          oCcy.format(company.dayHigh).toString(), false, false),
      marketStatusTile(AppIcons.dayHigh, 'Day Low',
          oCcy.format(company.dayLow).toString(), true, false),
      marketStatusTile(AppIcons.alltimeHigh, 'All Time High',
          oCcy.format(company.allTimeHigh).toString(), false, false),
      marketStatusTile(AppIcons.alltimeHigh, 'All Time Low',
          oCcy.format(company.allTimeLow).toString(), true, false),
    ],
  );
}
