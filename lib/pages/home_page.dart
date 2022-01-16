import 'package:dalal_street_client/components/graph/line_area.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/streams/transformations.dart';
import 'package:fixnum/fixnum.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:dalal_street_client/theme/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final Map<int, Stock> stocks = getIt<GlobalStreams>().stockMapStream.value;
  final stockMapStream = getIt<GlobalStreams>().stockMapStream;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(context) {
    super.build(context);
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
          const SizedBox(
            height: 5,
          ),
          _companies(),
          const SizedBox(
            height: 10,
          ),
          _recentNews(),
          const SizedBox(
            child: LineAreaGraph(stockId: 2),
            height: 50,
          ),
        ],
      ),
    );
  }

  Container _recentNews() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: background2,
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
        color: background2,
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

  Widget _stockList() {
    List<Widget> stockItems = stocks.entries
        .map((entry) => StockItem(
            stock: entry.value,
            stockPriceStream: stockMapStream.priceStream(entry.key)))
        .toList();
    return ListView(
      shrinkWrap: true,
      children: stockItems,
    );
  }
}

class StockItem extends StatelessWidget {
  final Stock stock;
  final Stream<Int64> stockPriceStream;

  const StockItem(
      {Key? key, required this.stock, required this.stockPriceStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int cash = getIt<GlobalStreams>().dynamicUserInfoStream.value.cash;
    List<int> data = [stock.id, cash];
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/company', arguments: data);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            _stockNames(stock),
            _stockGraph(),
            _stockPrices(),
          ])),
    );
  }

  Expanded _stockNames(Stock company) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          company.shortName,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        Text(
          company.fullName,
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
        'https://i.imgur.com/lOQyGGe.png',
        height: 23,
      ),
    );
  }

  Widget _stockPrices() {
    return Expanded(
      child: StreamBuilder<Int64>(
        stream: stockPriceStream,
        initialData: stock.currentPrice,
        builder: (context, state) {
          Int64 stockPrice = state.data!;

          bool isLowOrHigh = stockPrice > stock.previousDayClose;

          double percentageHighOrLow;

          if (stock.previousDayClose == 0) {
            percentageHighOrLow = stockPrice.toDouble();
          } else {
            percentageHighOrLow =
                ((stockPrice.toDouble() - stock.previousDayClose.toDouble()) /
                    stock.previousDayClose.toDouble());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹' + oCcy.format(stockPrice).toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                isLowOrHigh
                    ? '+' + oCcy.format(percentageHighOrLow).toString() + '%'
                    : oCcy.format(percentageHighOrLow).toString() + '%',
                style: TextStyle(
                  fontSize: 14,
                  color: isLowOrHigh ? secondaryColor : heartRed,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
