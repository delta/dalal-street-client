import 'package:dalal_street_client/components/buttons/primary_button.dart';
import 'package:dalal_street_client/components/buttons/secondary_button.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          backgroundColor: Colors.black,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      _companyPrices(priceChange, priceChangePercentage),
                      const SizedBox(
                        height: 10,
                      ),
                      _companyTabView(context)
                    ],
                  ),
                ),
              ),
              Container(
                height: 70,
                decoration: const BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    )),
                alignment: Alignment.bottomCenter,
                child: const Center(
                  child: PrimaryButton(
                    height: 45,
                    width: 340,
                    title: 'Place Order',
                  ),
                ),
              ),
            ],
          ),
        ),
        tablet: Container(),
        desktop: Container(),
      ),
    );
  }

  Container _companyRecentNewsView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Recent News',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: white.withOpacity(0.75),
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Container _companyTabView(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: DefaultTabController(
          length: 3,
          child: Expanded(
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: lightGrey,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Market Depth',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: lightGrey,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'News',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: lightGrey,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                  indicatorColor: lightGray,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: TabBarView(
                      children: [_overView(), _marketDepth(), _news()]),
                )
              ],
            ),
          ),
        ));
  }

  Container _companyPrices(Int64 priceChange, double priceChangePercentage) {
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
              Image.network(
                'https://i.imgur.com/v5E2Cv7.png',
                width: 50,
                height: 50,
              ),
              const SizedBox(
                height: 5,
              ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        '₹ ' +
                            oCcy.format(widget.company.currentPrice).toString(),
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
                          color: priceChange > 0 ? secondaryColor : heartRed,
                        ),
                      ),
                    ],
                  ),
                  SecondaryButton(
                    height: 25,
                    width: 135,
                    fontSize: 14,
                    title: widget.company.shortName,
                    onPressed: () {},
                  ),
                ],
              ),
              _companyGraph()
            ]));
  }

  Image _companyGraph() => Image.network('https://i.imgur.com/Y6CBCX2.png');

  Container _news() {
    return Container();
  }

  Container _marketDepth() {
    return Container();
  }

  Column _overView() {
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
          height: 5,
        ),
        Text(
          widget.company.description.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: lightGrey,
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
        marketStatusTile(AppIcons().currentPrice, 'Current Price',
            oCcy.format(widget.company.currentPrice).toString(), false),
        marketStatusTile(AppIcons().dayHigh, 'Day High',
            oCcy.format(widget.company.dayHigh).toString(), false),
        marketStatusTile(AppIcons().dayHigh, 'Day Low',
            oCcy.format(widget.company.dayLow).toString(), true),
        marketStatusTile(AppIcons().alltimeHigh, 'All Time High',
            oCcy.format(widget.company.allTimeHigh).toString(), false),
        marketStatusTile(AppIcons().alltimeHigh, 'All Time Low',
            oCcy.format(widget.company.allTimeLow).toString(), true),
      ],
    );
  }
}

Widget marketStatusTile(String icon, String name, String value, bool isRed) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          spacing: 14,
          children: [
            SvgPicture.asset(
              icon,
              width: 18,
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: white,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        Text(
          '₹ ' + value,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: !isRed ? primaryColor : heartRed),
          textAlign: TextAlign.start,
        ),
      ],
    ),
  );
}
