import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/components/stock_bar.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/pages/company_page/components/company_tab_view.dart';
import 'package:dalal_street_client/pages/company_page/components/company_prices.dart';
import 'package:dalal_street_client/pages/company_page/components/choose_buy_or_sell_bottom_sheet.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final oCcy = NumberFormat('#,##0.00', 'en_US');

class CompanyPage extends StatefulWidget {
  final List<int> data;
  const CompanyPage({Key? key, required this.data}) : super(key: key);

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  initState() {
    super.initState();
    // Subscribe to the stream of Market Depth Updates
    context.read<SubscribeCubit>().subscribe(DataStreamType.MARKET_DEPTH,
        dataStreamId: widget.data[0].toString());
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    final stockList = getIt<GlobalStreams>().latestStockMap;
    final int stockId = widget.data.first;
    final int cash = widget.data.last;
    Stock company = stockList[stockId]!;
    return SafeArea(
      child: Responsive(
        mobile: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Column(
                      children: [
                        const StockBar(),
                        const SizedBox(
                          height: 5,
                        ),
                        companyPrices(company),
                        const SizedBox(
                          height: 10,
                        ),
                        companyTabView(context, company)
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          chooseBuyOrSellBottomSheet(context, company, cash);
                        },
                        child: const Text('Place Your Order'),
                      ),
                    ),
                  ),
                ),
              ],
            )),
        tablet: Container(),
        desktop: Container(),
      ),
    );
  }
}
