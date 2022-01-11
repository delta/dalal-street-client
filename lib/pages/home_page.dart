import 'package:dalal_street_client/blocs/companies/companies_bloc.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/components/stock_bar.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalal_street_client/theme/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Unsubscribe to the streams when the widget is disposed
  @override
  void dispose() {
    SubscriptionId? _stockPricesSubscriptionId;
    final state = context.read<SubscribeCubit>().state;
    if (state is SubscriptionDataLoaded) {
      _stockPricesSubscriptionId = state.subscriptionId;
      context.read<SubscribeCubit>().unsubscribe(_stockPricesSubscriptionId);
    }
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    // Get List of Stocks
    context.read<CompaniesBloc>().add(const GetStockList());
    // Subscribe to the stream of Stock Prices
    context.read<SubscribeCubit>().subscribe(DataStreamType.STOCK_PRICES);
    // TODO : Subscribe to the stream of News and Prices Graph
  }

  @override
  Widget build(context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Responsive(
            mobile: _mobileBody(),
            tablet: _tabletBody(),
            desktop: _desktopBody(),
          ),
        ),
      ),
    );
  }

  Center _desktopBody() {
    return const Center(
      child: Text(
        'Web UI will design soon :)',
        style: TextStyle(
          fontSize: 14,
          color: secondaryColor,
        ),
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

  Padding _mobileBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          const StockBar(),
          const SizedBox(
            height: 10,
          ),
          _companies(),
          const SizedBox(
            height: 10,
          ),
          _recentNews(),
        ],
      ),
    );
  }

  Container _recentNews() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Recent News',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: white,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 20,
              )
            ]));
  }

  Container _companies() {
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
            'Home',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: whiteWithOpacity75),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Top Companies',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: white,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 20,
          ),
          _stockList(),
        ],
      ),
    );
  }

  BlocBuilder<CompaniesBloc, CompaniesState> _stockList() {
    return BlocBuilder<CompaniesBloc, CompaniesState>(
      builder: (context, state) {
        if (state is GetCompaniesSuccess) {
          var mapOfStocks = state.stockList.stockList;
          logger.i(state.stockList.stockList.length);
          return BlocBuilder<SubscribeCubit, SubscribeState>(
              builder: (context, state) {
            if (state is SubscriptionDataLoaded) {
              // Start the stream of Stock Prices
              context
                  .read<CompaniesBloc>()
                  .add(SubscribeToStockPrices(state.subscriptionId));
              return ListView.builder(
                shrinkWrap: true,
                itemCount: mapOfStocks.length,
                itemBuilder: (context, index) {
                  Stock? company = mapOfStocks[index];
                  int currentPrice = company?.currentPrice.toInt() ?? 0;
                  int previousDayPrice = company?.previousDayClose.toInt() ?? 0;
                  var priceChange = (currentPrice - previousDayPrice);
                  return _stockItem(company, index, priceChange, currentPrice);
                },
              );
            } else if (state is SubscriptonDataFailed) {
              logger.i('Stock Prices Stream Failed $state');
              return const Center(
                child: Text(
                  'Failed to load data \nReason : //',
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryColor,
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: secondaryColor,
                ),
              );
            }
          });
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: secondaryColor,
            ),
          );
        }
      },
    );
  }

  Container _stockItem(
      Stock? company, int index, int priceChange, int currentPrice) {
    return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          _stockNames(company),
          _stockGraph(),
          _stockPrices(index, priceChange, currentPrice),
        ]));
  }

  Expanded _stockNames(Stock? company) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          company?.shortName ?? 'Airtel',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        Text(
          company?.fullName ?? 'Airtel Pvt Ltd',
          style: const TextStyle(
            fontSize: 14,
            color: whiteWithOpacity50,
          ),
        ),
      ]),
    );
  }

  Expanded _stockGraph() {
    return Expanded(
      child: Image.network(
        'https://i.imgur.com/zrmdl8j.png',
        height: 23,
      ),
    );
  }

  Expanded _stockPrices(int index, int priceChange, int currentPrice) {
    return Expanded(
      child: BlocBuilder<CompaniesBloc, CompaniesState>(
        builder: (context, state) {
          if (state is SubscriptionToStockPricesSuccess) {
            var currentStockPrice = state.stockPrices.prices[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  oCcy.format(currentStockPrice).toString(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  priceChange >= 0
                      ? '+' + oCcy.format(priceChange).toString()
                      : oCcy.format(priceChange).toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: priceChange > 0 ? secondaryColor : heartRed,
                  ),
                ),
              ],
            );
          } else if (state is SubscriptionToStockPricesFailed) {
            return const Center(
              child: Text(
                'Failed to load data \nReason : //',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryColor,
                ),
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  oCcy.format(currentPrice).toString(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  priceChange >= 0
                      ? '+' + oCcy.format(priceChange).toString()
                      : oCcy.format(priceChange).toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: priceChange > 0 ? secondaryColor : heartRed,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  movetonews(context) {
    Navigator.of(context).pushNamed('/news_page');
  }
}
