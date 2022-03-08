import 'package:dalal_street_client/blocs/news/news_bloc.dart';
import 'package:dalal_street_client/blocs/news_subscription/news_subscription_cubit.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/pages/newsdetail_page.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/MarketEvent.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final ScrollController _scrollController = ScrollController();
  List<MarketEvent> mapMarketEvents = [];
  List<MarketEvent> mapmarketEventsCopy = [];
  int i = 1;
  bool moreExists = false;
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(const GetNews());
    context.read<SubscribeCubit>().subscribe(DataStreamType.MARKET_EVENTS);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (mapMarketEvents[mapMarketEvents.length - 1].id > 0 && moreExists) {
          context.read<NewsBloc>().add(
              GetMoreNews(mapMarketEvents[mapMarketEvents.length - 1].id - 1));
        }
      }
    });
  }

  @override
  void dispose() {
    SubscriptionId? _marketEventsSubscriptionId;
    final state = context.read<SubscribeCubit>().state;
    _scrollController.dispose();
    if (state is SubscriptionDataLoaded) {
      _marketEventsSubscriptionId = state.subscriptionId;
      context.read<SubscribeCubit>().unsubscribe(_marketEventsSubscriptionId);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: (() {
      var screenWidth = MediaQuery.of(context).size.width;

      return screenWidth > 1000
          ? Center(
              child: Container(
                  margin: EdgeInsets.fromLTRB(
                      screenWidth * 0.20,
                      screenWidth * 0.03,
                      screenWidth * 0.20,
                      screenWidth * 0.03),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        news(true),
                        const SizedBox.square(
                          dimension: 20,
                        ),
                        feed(true),
                      ],
                    ),
                  )),
            )
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: Colors.black,
              child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      news(false),
                      const SizedBox.square(
                        dimension: 20,
                      ),
                      feed(false),
                    ],
                  )));
    }())));
  }

  Widget feedlist(bool isWeb) =>
      BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
        if (state is GetNewsSucess) {
          moreExists = state.marketEventsList.moreExists;
          mapMarketEvents.addAll(state.marketEventsList.marketEvents);
          if (i == 1) {
            mapMarketEvents.remove(mapMarketEvents[0]);
            i++;
          }
          if (mapMarketEvents.isEmpty) {
            return Column(
              children: const [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'No More News',
                  style: TextStyle(
                      fontSize: 20, color: white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                )
              ],
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: mapMarketEvents.length,
            itemBuilder: (context, index) {
              MarketEvent marketEvent = mapMarketEvents[index];
              String headline = marketEvent.headline;
              String imagePath = marketEvent.imagePath;
              String createdAt = marketEvent.createdAt;
              String text = marketEvent.text;
              String dur = getdur(createdAt);
              return GestureDetector(
                  child: newsItem(headline, imagePath, createdAt, false, isWeb),
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
          return const Center(child: DalalLoadingBar());
        }
      });

  Widget feed(bool isWeb) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            color: background2, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                'Feed',
                style: TextStyle(
                    fontSize: isWeb ? 36 : 18,
                    fontWeight: FontWeight.w500,
                    color: whiteWithOpacity75),
                textAlign: TextAlign.left,
              ),
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.all(10),
            ),
            const SizedBox(
              height: 10,
            ),
            feedlist(isWeb)
          ],
        ));
  }

  Widget news(bool isWeb) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            color: background2, borderRadius: BorderRadius.circular(10)),
        child: Column(children: <Widget>[
          Container(
            child: Text(
              'News',
              style: TextStyle(
                  fontSize: isWeb ? 36 : 18,
                  fontWeight: FontWeight.w500,
                  color: whiteWithOpacity75),
              textAlign: TextAlign.left,
            ),
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.all(10),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              child: latestnews(isWeb),
              height: MediaQuery.of(context).size.height * 0.40),
        ]),
      );

  Widget latestnews(bool isWeb) =>
      BlocBuilder<SubscribeCubit, SubscribeState>(builder: (context, state) {
        if (state is SubscriptionDataLoaded) {
          context
              .read<NewsSubscriptionCubit>()
              .getNewsFeed(state.subscriptionId);
          return BlocBuilder<NewsSubscriptionCubit, NewsSubscriptionState>(
              builder: (context, state) {
            if (state is SubscriptionToNewsSuccess) {
              MarketEvent marketEvent = state.news.marketEvent;
              String headline = marketEvent.headline;
              String imagePath = marketEvent.imagePath;
              String createdAt = marketEvent.createdAt;
              String text = marketEvent.text;
              String dur = getdur(createdAt);
              return GestureDetector(
                  child: newsItem(headline, imagePath, createdAt, true, isWeb),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetail(
                          text: text,
                          imagePath: imagePath,
                          headline: headline,
                          dur: dur,
                        ),
                      )));
            } else if (state is SubscriptionToNewsFailed) {
              return Column(
                children: [
                  const Text('Failed to reach server'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => context
                          .read<NewsSubscriptionCubit>()
                          .getNewsFeed(state.subscriptionId),
                      child: const Text('Retry'),
                    ),
                  ),
                ],
              );
            } else {
              return BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                if (state is GetNewsSucess) {
                  if (state.marketEventsList.marketEvents.isEmpty) {
                    return Align(
                        alignment: Alignment.center,
                        child: Text(
                          'No latest News',
                          style: TextStyle(
                              fontSize: isWeb ? 24 : 20,
                              color: white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ));
                  }
                  mapmarketEventsCopy
                      .addAll(state.marketEventsList.marketEvents);
                  MarketEvent marketEvent = mapmarketEventsCopy[0];
                  String headline = marketEvent.headline;
                  String imagePath = marketEvent.imagePath;
                  String createdAt = marketEvent.createdAt;
                  String text = marketEvent.text;
                  String dur = getdur(createdAt);
                  return GestureDetector(
                      child:
                          newsItem(headline, imagePath, createdAt, true, isWeb),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetail(
                              text: text,
                              imagePath: imagePath,
                              headline: headline,
                              dur: dur,
                            ),
                          )));
                } else if (state is GetNewsFailure) {
                  return Column(
                    children: [
                      const Text('Failed to reach server'),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => context.read<NewsBloc>().add(
                              GetMoreNews(
                                  mapMarketEvents[mapMarketEvents.length - 1]
                                          .id -
                                      1)),
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
            }
          });
        } else if (state is SubscriptonDataFailed) {
          return Column(
            children: [
              const Text('Failed to reach server'),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => context
                      .read<SubscribeCubit>()
                      .subscribe(DataStreamType.MARKET_EVENTS),
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

  Widget newsItem(String text, String imagePath, String createdAt,
      bool islatest, bool isWeb) {
    String dur = getdur(createdAt);
    if (!islatest) {
      return (Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                width: isWeb ? 200 : 150,
                height: isWeb ? 100 : 75,
                fit: BoxFit.contain,
                image: NetworkImage(imagePath),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(text,
                          style: TextStyle(
                              color: Colors.white, fontSize: isWeb ? 24 : 18)),
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
    } else {
      return Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(text,
                          style: TextStyle(
                              color: Colors.white, fontSize: isWeb ? 24 : 18)),
                      SizedBox.square(
                        dimension: isWeb ? 20 : 10,
                      ),
                      Text('Published on ' + dur,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: lightGray,
                              fontSize: isWeb ? 18 : 14))
                    ]),
                SizedBox.square(
                  dimension: isWeb ? 30 : 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: NetworkImage(imagePath),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.20,
                    fit: BoxFit.contain,
                  ),
                )
              ]));
    }
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
}
