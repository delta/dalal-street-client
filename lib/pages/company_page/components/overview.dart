import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/pages/company_page/components/market_status_tile.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/streams/transformations.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat('#,##0.00', 'en_US');

Column overView(Stock company) {
  final Stream<Int64> priceStream =
      getIt<GlobalStreams>().stockMapStream.priceStream(company.id);
  final Stream<Int64> dayHighStream =
      getIt<GlobalStreams>().stockMapStream.dayHighStream(company.id);
  final Stream<Int64> dayLowStream =
      getIt<GlobalStreams>().stockMapStream.dayLowStream(company.id);
  final Stream<Int64> allTimeHighStream =
      getIt<GlobalStreams>().stockMapStream.allTimeHighStream(company.id);
  final Stream<Int64> allTimeLowStream =
      getIt<GlobalStreams>().stockMapStream.allTimeLowStream(company.id);
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
      StreamBuilder<Object>(
          stream: priceStream,
          builder: (context, state) {
            return marketStatusTile(AppIcons.currentPrice, 'Current Price',
                oCcy.format(state.data).toString(), false, false);
          }),
      StreamBuilder<Object>(
          stream: dayHighStream,
          builder: (context, state) {
            return marketStatusTile(AppIcons.dayHigh, 'Day High',
                oCcy.format(state.data).toString(), false, false);
          }),
      StreamBuilder<Object>(
          stream: dayLowStream,
          builder: (context, state) {
            return marketStatusTile(AppIcons.dayHigh, 'Day Low',
                oCcy.format(state.data).toString(), true, false);
          }),
      StreamBuilder<Object>(
          stream: allTimeHighStream,
          builder: (context, state) {
            return marketStatusTile(AppIcons.alltimeHigh, 'All Time High',
                oCcy.format(state.data).toString(), false, false);
          }),
      StreamBuilder<Object>(
          stream: allTimeLowStream,
          builder: (context, state) {
            return marketStatusTile(AppIcons.alltimeHigh, 'All Time Low',
                oCcy.format(state.data).toString(), true, false);
          }),
    ],
  );
}
