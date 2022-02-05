import 'package:dalal_street_client/blocs/exchange/exchange_cubit.dart';
import 'package:dalal_street_client/blocs/list_selection/list_selection_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/pages/stock_exchange/components/stock_detail.dart';
import 'package:dalal_street_client/pages/stock_exchange/components/stock_exchange_item.dart';
import 'package:dalal_street_client/pages/stock_exchange/components/stock_list_item.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({Key? key}) : super(key: key);

  @override
  _ExchangePageState createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage>
    with AutomaticKeepAliveClientMixin {
  Map<int, Stock> mapOfStocks = getIt<GlobalStreams>().latestStockMap;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<ExchangeCubit>().listenToExchangeStream(mapOfStocks);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
            child: Responsive(
          desktop: _desktopBody(),
          mobile: _mobileBody(),
          tablet: _tabletBody(),
        )),
      ),
    );
  }

  Widget _desktopBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          _companiesExchangeWeb(),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget _companiesExchangeWeb() {
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
            const Text(
              'Delta Stock Exchange',
              style: TextStyle(
                  fontSize: 48, fontWeight: FontWeight.w700, color: white),
              textAlign: TextAlign.end,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Buy stocks directly from the exchange, and trade your way to glory',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w500, color: lightGray),
              textAlign: TextAlign.end,
            ),
            const SizedBox(
              height: 20,
            ),
            _exchangeBodyWeb()
          ]),
    );
  }

  Widget _exchangeBodyWeb() {
    return BlocProvider(
      create: (context) => ListSelectedItemCubit(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(flex: 1, child: _companyListView()),
          const SizedBox(width: 10,),
          const Flexible(flex: 1, child: StockDetail())
        ],
      ),
    );
  }

  Widget _companyListView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: background3,
      ),
      child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Stock? company = mapOfStocks[index + 1];
            int currentPrice =
                mapOfStocks[index + 1]?.currentPrice.toInt() ?? 0;
            return StockListItem(
                company: company ?? Stock(),
                stockId: index + 1,
                currentPrice: currentPrice);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 20,
            );
          },
          itemCount: mapOfStocks.length),
    );
  }

  Center _tabletBody() {
    return const Center(
      child: Text(
        'Tablet UI will design soon :)',
        style: TextStyle(
          fontSize: 14,
          color: secondaryColor,
        ),
      ),
    );
  }

  Widget _mobileBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          _companiesExchangeMobile(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _companiesExchangeMobile() => Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delta Stock Exchange',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w500, color: lightGray),
              textAlign: TextAlign.end,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Companies in DSE',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: white,
              ),
              textAlign: TextAlign.end,
            ),
            const SizedBox(
              height: 20,
            ),
            _exchangeBodyMobile(),
          ],
        ),
      );

  Widget _exchangeBodyMobile() => ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: mapOfStocks.length,
        itemBuilder: (context, index) {
          Stock? company = mapOfStocks[index + 1];
          int currentPrice = mapOfStocks[index + 1]?.currentPrice.toInt() ?? 0;
          return StockExchangeItem(
              company: company ?? Stock(),
              stockId: index + 1,
              currentPrice: currentPrice);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 10,
          );
        },
      );
}
