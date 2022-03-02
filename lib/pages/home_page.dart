import 'package:dalal_street_client/blocs/dalal/dalal_bloc.dart';
import 'package:dalal_street_client/blocs/notification/notifications_cubit.dart';
import 'package:dalal_street_client/components/graph/line_area.dart';
import 'package:dalal_street_client/blocs/news/news_bloc.dart';
import 'package:dalal_street_client/components/buttons/tertiary_button.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/models/dynamic_user_info.dart';
import 'package:dalal_street_client/proto_build/models/Notification.pb.dart'
    as notification;
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/pages/newsdetail_page.dart';
import 'package:dalal_street_client/proto_build/models/MarketEvent.pb.dart';
import 'package:dalal_street_client/streams/transformations.dart';
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
  List<MarketEvent> mapMarketEvents = [];
  int i = 1;
  final Map<int, Stock> stocks = getIt<GlobalStreams>().stockMapStream.value;
  final stockMapStream = getIt<GlobalStreams>().stockMapStream;

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(const GetNews());
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

  Center _desktopBody() {
    return Center(
        child: SingleChildScrollView(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox.square(
          dimension: 30,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            child: SingleChildScrollView(child: _companiesDesktop()),
            height: 500,
            width: 697,
          ),
          const SizedBox.square(
            dimension: 45,
          ),
          Column(
            children: [
              _notifications(),
              const SizedBox.square(
                dimension: 15,
              ),
              _userworth(),
            ],
          )
        ]),
        const SizedBox.square(
          dimension: 35,
        ),
        SizedBox(height: 770, width: 1230, child: _recentNewsDesktop()),
      ],
    )));
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
          ElevatedButton(
              onPressed: () {
                context.read<DalalBloc>().add(const DalalLogOut());
              },
              child: const Text('Logout')),
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
                      context.go('/news');
                    },
                  ),
                ],
              ),
              feedlist()
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
                    title: 'See All',
                    onPressed: () {
                      context.go('/news');
                    },
                  ),
                ],
              ),
              feedlist()
            ]));
  }

  Widget feedlist() =>
      BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
        if (state is GetNewsSucess) {
          mapMarketEvents.clear();
          mapMarketEvents.addAll(state.marketEventsList.marketEvents);
          // Sort MarketEvents according to there created time
          mapMarketEvents.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          if (mapMarketEvents.isNotEmpty) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mapMarketEvents.length,
              itemBuilder: (context, index) {
                MarketEvent marketEvent = mapMarketEvents[index];
                String headline = marketEvent.headline;
                String imagePath = marketEvent.imagePath;
                String createdAt = marketEvent.createdAt;
                String text = marketEvent.text;
                String dur = getdur(createdAt);
                return GestureDetector(
                    child: newsItem(headline, imagePath, createdAt),
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
            return const Center(
              child: Text(
                'No News',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryColor,
                ),
              ),
            );
          }
        } else if (state is GetNewsFailure) {
          return Column(
            children: [
              const Text('Failed to reach server'),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => context.read<NewsBloc>().add(GetMoreNews(
                      mapMarketEvents[mapMarketEvents.length - 1].id - 1)),
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

  Container _companiesDesktop() {
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
          const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Top Companies',
                style: TextStyle(fontSize: 24, color: whiteWithOpacity75),
              )),
          const SizedBox(
            height: 40,
          ),
          _stockList(),
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
          _stockList(),
        ],
      ),
    );
  }

  Widget _stockList() {
    List<Widget> stockItems = stocks.entries
        .map((entry) => StockItem(
            stock: entry.value,
            isBankruptStream: stockMapStream.isBankruptStream(entry.value.id),
            givesDividendStream: stockMapStream.givesDividents(entry.value.id),
            stockPriceStream: stockMapStream.priceStream(entry.key)))
        .toList();
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: stockItems,
    );
  }

  Widget newsItem(
    String text,
    String imagePath,
    String createdAt,
  ) {
    String dur = getdur(createdAt);
    return (Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              image: NetworkImage(imagePath),
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 100) * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(text,
                        style: const TextStyle(color: white, fontSize: 15)),
                  ),
                ),
                const SizedBox.square(
                  dimension: 5,
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text('Published on ' + dur,
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: lightGray,
                            fontSize: 12)))
              ]),
        ],
      ),
    ));
  }

  String getdur(String createdAt) {
    DateTime dt1 = DateTime.parse(createdAt);
    DateTime dt2 = DateTime.now();
    Duration diff = dt2.difference(dt1);
    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return (diff.inMinutes.toString() + ' minutes ago');
      } else {
        return (diff.inHours.toString() + ' hour ago');
      }
    } else {
      return (diff.inDays.toString() + ' day ago');
    }
  }

  Widget _userworth() {
    return Container(
      width: 489,
      height: 239,
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
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                ),
                const Text(
                  'Your Holdings',
                  style: TextStyle(
                    fontSize: 24,
                    color: whiteWithOpacity75,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
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
                          fontSize: 30,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.only(right: 25, top: 5),
                        child: Text(
                          '₹' + data.totalWorth.toString(),
                          style: TextStyle(
                              fontSize: 30,
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
        style: const TextStyle(fontSize: 30, color: whiteWithOpacity75),
      ),
      const Spacer(),
      Container(
        padding: const EdgeInsets.only(right: 25),
        child: Text(
          '₹' + value,
          style: const TextStyle(fontSize: 30, color: lightGray),
        ),
      )
    ]);
  }

  Widget _notifications() {
    List<notification.Notification> notifications = [];
    return Container(
        width: 489,
        height: 245,
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
          Center(child:
              BlocBuilder<NotificationsCubit, NotificationsCubitState>(
                  builder: (context, state) {
            if (state is GetNotificationSuccess) {
              notifications.addAll(state.notifications);

              return SizedBox(
                  width: 489,
                  height: 176,
                  child: ListView.separated(
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
                  ));
            } else if (state is GetNotificationFailure) {
              return Column(
                children: [
                  const Text('Failed to reach server'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () =>
                          context.read<NotificationsCubit>().getNotifications(),
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
          }))
        ]));
  }

  Widget notificationItem(String text) {
    return Padding(
      child: Text(
        text,
        style: const TextStyle(color: white, fontSize: 16),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      padding: const EdgeInsets.all(10),
    );
  }
}

class StockItem extends StatelessWidget {
  final Stock stock;
  final Stream<Int64> stockPriceStream;
  final Stream<bool> isBankruptStream;
  final Stream<bool> givesDividendStream;

  const StockItem(
      {Key? key,
      required this.stock,
      required this.isBankruptStream,
      required this.givesDividendStream,
      required this.stockPriceStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int cash = getIt<GlobalStreams>().dynamicUserInfoStream.value.cash;
    List<int> data = [stock.id, cash];
    return GestureDetector(
      onTap: () {
        context.push(
          '/company',
          extra: data,
        );
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            _stockNames(stock),
            _stockGraph(stock.id),
            _stockPrices(),
          ])),
    );
  }

  Expanded _stockNames(Stock company) {
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
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.lineThrough),
                        )
                      else if (givesDividends)
                        Text(
                          company.shortName,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        )
                      else
                        Text(
                          company.shortName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      Text(
                        company.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
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
