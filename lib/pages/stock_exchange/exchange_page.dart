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
            primary: false,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
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

  Widget _exchangeBodyWeb() => BlocProvider(
        create: (_) => ListSelectionCubit(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Builder(builder: (context) => _companyListView(context)),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 1,
              child: BlocBuilder<ListSelectionCubit, ListSelectionState>(
                builder: (_, state) => StockDetail(
                  company: mapOfStocks.values.elementAt(state.selectedIndex),
                ),
              ),
            )
          ],
        ),
      );

  Widget _companyListView(BuildContext context) {
    final cubit = context.read<ListSelectionCubit>();
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
        itemBuilder: (context, index) => StreamBuilder<bool>(
          stream: cubit.selectedIndexStream
              .map((event) => event == index)
              .distinct(),
          initialData: index == 0,
          builder: (context, snapshot) => StockListItem(
            company: mapOfStocks.values.elementAt(index),
            selected: snapshot.data!,
            onClick: () => cubit.updateSelection(index),
          ),
        ),
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 20),
        itemCount: mapOfStocks.length,
      ),
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

  Widget _exchangeBodyMobile() {
    List<Widget> stockExchangeItems = mapOfStocks.entries
        .map((entry) => StockExchangeItem(company: entry.value))
        .toList();
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: mapOfStocks.length,
      itemBuilder: (context, index) => stockExchangeItems[index],
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 10,
        );
      },
    );
  }
}
