import 'package:dalal_street_client/blocs/market_event/events/market_event_cubit.dart';
import 'package:dalal_street_client/blocs/notification/notifications_cubit.dart';
import 'package:dalal_street_client/components/graph/line_area.dart';
import 'package:dalal_street_client/components/buttons/tertiary_button.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/config/config.dart';
import 'package:dalal_street_client/models/dynamic_user_info.dart';
import 'package:dalal_street_client/pages/ipo_page.dart';
import 'package:dalal_street_client/proto_build/models/Notification.pb.dart'
    as notification;
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/pages/news/newsdetail_page.dart';
import 'package:dalal_street_client/proto_build/models/MarketEvent.pb.dart';
import 'package:dalal_street_client/streams/transformations.dart';
import 'package:dalal_street_client/utils/iso_to_datetime.dart';
import 'package:fixnum/fixnum.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final userInfoStream = getIt<GlobalStreams>().dynamicUserInfoStream;
  final Map<int, Stock> stocks = getIt<GlobalStreams>().stockMapStream.value;
  final stockMapStream = getIt<GlobalStreams>().stockMapStream;

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    context.read<MarketEventCubit>().getLatestEvents();
    context.read<NotificationsCubit>().getNotifications();
  }

  @override
  Widget build(context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Responsive(
            mobile: _mobileBody(),
            tablet: _tabletBody(),
            desktop: _desktopBody(),
          ),
        ),
      ),
    );
  }

  Widget _desktopBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox.square(
            dimension: 20,
          ),
          IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    child: _companiesDesktop(),
                    width: MediaQuery.of(context).size.width * 0.55,
                  ),
                  const SizedBox.square(
                    dimension: 25,
                  ),
                  Column(
                    children: [
                      _notifications(),
                      const SizedBox.square(
                        dimension: 10,
                      ),
                      _userworth(),
                    ],
                  )
                ]),
          ),
          const SizedBox.square(
            dimension: 35,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              child: _recentNewsDesktop()),
        ],
      ),
    );
  }

  Widget _tabletBody() {
    return _mobileBody();
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
        ],
      ),
    );
  }

  Container _recentNews() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: background2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent News',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: white,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  TertiaryButton(
                    width: 80,
                    height: 25,
                    fontSize: 12,
                    title: 'See All',
                    onPressed: () {
                      context.push('/news');
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              newsFeed(false)
            ]));
  }

  Container _recentNewsDesktop() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: background2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Recent News',
                        style: TextStyle(
                          fontSize: 24,
                          color: whiteWithOpacity75,
                        ),
                        textAlign: TextAlign.start,
                      )),
                  TertiaryButton(
                    width: 80,
                    height: 25,
                    fontSize: 12,
                    title: 'See More',
                    onPressed: () {
                      context.go('/news');
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: SingleChildScrollView(
                      primary: false, child: newsFeed(true)))
            ]));
  }

  Widget newsFeed(bool isWeb) =>
      BlocBuilder<MarketEventCubit, MarketEventState>(
          builder: (context, state) {
        if (state is MarketEventSuccess) {
          if (state.marketEvents.isNotEmpty) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: state.marketEvents.length,
              itemBuilder: (context, index) {
                MarketEvent marketEvent = state.marketEvents[index];
                String headline = marketEvent.headline;
                String imagePath = marketEvent.imagePath;
                String createdAt = marketEvent.createdAt;
                String text = marketEvent.text;
                String dur = ISOtoDateTime(createdAt);
                return GestureDetector(
                    child: newsItem(headline, imagePath, createdAt, isWeb),
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => NewsDetail(
                              text: text,
                              imagePath: imagePath,
                              headline: headline,
                              dur: dur),
                        )));
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          } else {
            return SizedBox(
              height: 150,
              child: Center(
                child: Text(
                  'No recent news',
                  style: TextStyle(
                    fontSize: isWeb ? 24 : 14,
                    color: secondaryColor,
                  ),
                ),
              ),
            );
          }
        } else if (state is MarketEventFailure) {
          return Column(
            children: [
              const Text('Failed to load latest news'),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                height: 50,
                child: OutlinedButton(
                  onPressed: () =>
                      context.read<MarketEventCubit>().getLatestEvents(),
                  child: const Text('Retry'),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: DalalLoadingBar(),
          );
        }
      });

  Widget _companiesDesktop() {
    return Container(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height / 2),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: background2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Top Companies',
                style: TextStyle(fontSize: 24, color: whiteWithOpacity75),
              )),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: SingleChildScrollView(
                    primary: false, child: _stockList(true))),
          ),
        ],
      ),
    );
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
          _stockList(false),
        ],
      ),
    );
  }

  Widget _stockList(bool isWeb) {
    List<Widget> stockItems = stocks.entries
        .map((entry) => StockItem(
            stock: entry.value,
            isBankruptStream: stockMapStream.isBankruptStream(entry.value.id),
            givesDividendStream: stockMapStream.givesDividents(entry.value.id),
            stockPriceStream: stockMapStream.priceStream(entry.key),
            isWeb: isWeb))
        .toList();
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: stockItems,
    );
  }

  Widget newsItem(String text, String imagePath, String createdAt, bool isWeb) {
    String dur = ISOtoDateTime(createdAt);
    return (Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              width: isWeb ? 200 : 125,
              height: 100,
              fit: BoxFit.contain,
              image: NetworkImage(assetUrl + imagePath),
            ),
          ),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      text,
                      style: TextStyle(color: white, fontSize: isWeb ? 24 : 18),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox.square(
                    dimension: 5,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text('Published on ' + dur,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: lightGray,
                              fontSize: isWeb ? 18 : 14)))
                ]),
          ),
        ],
      ),
    ));
  }

  Widget _userworth() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.30,
      //  height: MediaQuery.of(context).size.height * 0.25,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: background2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: StreamBuilder<DynamicUserInfo>(
        stream: userInfoStream,
        initialData: userInfoStream.value,
        builder: (context, snapshot) {
          dynamic data = snapshot.data!;
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Holdings',
                  style: TextStyle(
                    fontSize: 24,
                    color: whiteWithOpacity75,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    const SizedBox(height: 10),
                    _eachField('Cash in Hand', data.cash.toString()),
                    const SizedBox(height: 10),
                    _eachField('Stock Worth', data.stockWorth.toString()),
                    const SizedBox(height: 10),
                    Row(children: [
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      const Text(
                        'Total Worth',
                        style: TextStyle(
                          fontSize: 26,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.only(right: 25, top: 5),
                        child: Text(
                          '₹' + data.totalWorth.toString(),
                          style: TextStyle(
                              fontSize: 26,
                              color: data.totalWorth.toInt() >= 0
                                  ? secondaryColor
                                  : heartRed),
                        ),
                      )
                    ])
                  ],
                ),
              ]);
        },
      ),
    );
  }

  Widget _eachField(String field, String value) {
    return Row(children: [
      const Padding(padding: EdgeInsets.all(10)),
      Text(
        field,
        style: const TextStyle(fontSize: 26, color: whiteWithOpacity75),
      ),
      const Spacer(),
      Container(
        padding: const EdgeInsets.only(right: 25),
        child: Text(
          '₹' + value,
          style: const TextStyle(fontSize: 26, color: lightGray),
        ),
      )
    ]);
  }

  Widget _notifications() {
    List<notification.Notification> notifications = [];
    return Container(
        width: MediaQuery.of(context).size.width * 0.30,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: background2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Notifications',
              style: TextStyle(color: whiteWithOpacity75, fontSize: 24),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: SingleChildScrollView(
              primary: false,
              child: Center(child:
                  BlocBuilder<NotificationsCubit, NotificationsCubitState>(
                      builder: (context, state) {
                if (state is GetNotificationSuccess) {
                  notifications.addAll(state.notifications);
                  if (notifications.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: const Center(
                        child: Text(
                          'No recent notifications',
                          style: TextStyle(
                            fontSize: 18,
                            color: secondaryColor,
                          ),
                          softWrap: true,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      var notification = notifications[index];

                      return notificationItem(notification.text);
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: lightGray,
                      );
                    },
                  );
                } else if (state is GetNotificationFailure) {
                  return Column(
                    children: [
                      const Text('Failed to reach server'),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => context
                              .read<NotificationsCubit>()
                              .getNotifications(),
                          child: const Text('Retry'),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: DalalLoadingBar(),
                  );
                }
              })),
            ),
          )
        ]));
  }

  Widget notificationItem(String text) {
    return Padding(
      child: Text(
        text,
        style: const TextStyle(color: white, fontSize: 16),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
    );
  }
}

movettoipo(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const IpoPage()));
}

class StockItem extends StatelessWidget {
  final Stock stock;
  final Stream<Int64> stockPriceStream;
  final Stream<bool> isBankruptStream;
  final Stream<bool> givesDividendStream;
  final bool isWeb;

  const StockItem(
      {Key? key,
      required this.stock,
      required this.isBankruptStream,
      required this.givesDividendStream,
      required this.stockPriceStream,
      required this.isWeb})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/company/${stock.id}'),
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            _stockNames(stock, isWeb),
            _stockGraph(stock.id),
            _stockPrices(isWeb),
          ])),
    );
  }

  Expanded _stockNames(Stock company, bool isWeb) {
    return Expanded(
      child: StreamBuilder<bool>(
        stream: isBankruptStream,
        initialData: company.isBankrupt,
        builder: (context, state) {
          bool isBankrupt = state.data!;
          return StreamBuilder<bool>(
              stream: givesDividendStream,
              initialData: company.givesDividends,
              builder: (context, state) {
                bool givesDividends = state.data!;
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isBankrupt)
                        Text(
                          company.shortName,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: isWeb ? 22 : 18,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.lineThrough),
                        )
                      else if (givesDividends)
                        Text(
                          company.shortName,
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: isWeb ? 22 : 18,
                          ),
                        )
                      else
                        Text(
                          company.shortName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: isWeb ? 22 : 18,
                          ),
                        ),
                      Text(
                        company.fullName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: isWeb ? 18 : 14,
                          color: whiteWithOpacity50,
                        ),
                      ),
                    ]);
              });
        },
      ),
    );
  }

  Expanded _stockGraph(int stockId) {
    return Expanded(
      child: SizedBox(
        child: LineAreaGraph(stockId: stockId),
        height: 50,
        width: 10,
      ),
    );
  }

  Widget _stockPrices(bool isWeb) {
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
                        stock.previousDayClose.toDouble()) *
                    100;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹' + oCcy.format(stockPrice).toString(),
                style: TextStyle(
                  fontSize: isWeb ? 22 : 18,
                ),
              ),
              Text(
                isLowOrHigh
                    ? '+' + oCcy.format(percentageHighOrLow).toString() + '%'
                    : oCcy.format(percentageHighOrLow).toString() + '%',
                style: TextStyle(
                  fontSize: isWeb ? 18 : 14,
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
