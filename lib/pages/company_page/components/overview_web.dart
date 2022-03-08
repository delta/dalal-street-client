import 'package:dalal_street_client/components/graph/stock_chart.dart';
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

Widget _companyGraph(Stock stock, double height) {
  if (stock.isBankrupt) {
    return SizedBox(
      width: 800,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'This Company went Bankrupt',
            style: TextStyle(
                color: heartRed, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          Image.asset('assets/images/sad_bull.png', height: 200)
        ],
      ),
    );
  } else {
    return StockChart(stockId: stock.id, height: height);
  }
}

Widget overViewWeb(Stock company, BuildContext context) {
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
  var screenWidth = MediaQuery.of(context).size.width;
  var screenHeight = MediaQuery.of(context).size.height;
  return Padding(
    padding: const EdgeInsets.fromLTRB(50,20,30,10),
    child: Container(
      color: Colors.black,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: background2, borderRadius: BorderRadius.circular(20)),
              height: screenHeight * 0.3,
              width: screenWidth * 0.6,
              child: _companyGraph(
                  company, screenHeight * 0.3)),
          const SizedBox(width: 50),
          Container(
            padding: const EdgeInsets.all(20),
            width: screenWidth * 0.30,
            height: screenHeight * 0.3,
            decoration: BoxDecoration(
                color: background2, borderRadius: BorderRadius.circular(20)),
            child: Column(
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.description.toString(),
                      softWrap: true,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: lightGray,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    InkWell(
                      onTap: () =>
                          _showDescriptionBottomSheet(company, context),
                      child: const Text(
                        'Read more',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: secondaryColor,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
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
                StreamBuilder<Int64>(
                    stream: priceStream,
                    initialData: company.currentPrice,
                    builder: (context, state) {
                      return marketStatusTile(
                          AppIcons.currentPrice,
                          'Current Price',
                          oCcy.format(state.data).toString(),
                          false,
                          true);
                    }),
                StreamBuilder<Int64>(
                    stream: dayHighStream,
                    initialData: company.dayHigh,
                    builder: (context, state) {
                      return marketStatusTile(AppIcons.dayHigh, 'Day High',
                          oCcy.format(state.data).toString(), false, true);
                    }),
                StreamBuilder<Int64>(
                    stream: dayLowStream,
                    initialData: company.dayLow,
                    builder: (context, state) {
                      return marketStatusTile(AppIcons.dayHigh, 'Day Low',
                          oCcy.format(state.data).toString(), true, true);
                    }),
                StreamBuilder<Int64>(
                    stream: allTimeHighStream,
                    initialData: company.allTimeHigh,
                    builder: (context, state) {
                      return marketStatusTile(
                          AppIcons.alltimeHigh,
                          'All Time High',
                          oCcy.format(state.data).toString(),
                          false,
                          true);
                    }),
                StreamBuilder<Int64>(
                    stream: allTimeLowStream,
                    initialData: company.allTimeLow,
                    builder: (context, state) {
                      return marketStatusTile(
                          AppIcons.alltimeHigh,
                          'All Time Low',
                          oCcy.format(state.data).toString(),
                          true,
                          true);
                    }),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

_showDescriptionBottomSheet(Stock company, BuildContext context) {
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: background2,
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 150,
                      height: 4.5,
                      decoration: const BoxDecoration(
                        color: lightGray,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'About Company',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                company.description,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: lightGray,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        );
      });
}
