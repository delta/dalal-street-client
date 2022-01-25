import 'package:dalal_street_client/blocs/news/news_bloc.dart';
import 'package:dalal_street_client/blocs/news/news_subscription_cubit.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/pages/newsdetail_page.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/MarketEvent.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(const GetNews());
    context.read<SubscribeCubit>().subscribe(DataStreamType.MARKET_EVENTS);
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          logger.i(mapMarketEvents.length);
          context.read<NewsBloc>().add(GetMoreNews(mapMarketEvents.length + 1));
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
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                color: Colors.black,
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        news(),
                        const SizedBox.square(
                          dimension: 20,
                        ),
                        feed(),
                      ],
                    )))));
  }

  Widget feedlist() =>
      BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
        if (state is GetNewsSucess) {
          if(state.marketEventsList.moreExists)
          {
            
          mapMarketEvents.addAll(state.marketEventsList.marketEvents);
          }
          logger.i(state.marketEventsList.moreExists);
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
                      child: newsItem(headline, imagePath, createdAt, false),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
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
        }
        else if (state is GetNewsFailure) {
          return const Text('Error');
        }
        else {
          return const Center(
            child: CircularProgressIndicator(
              color: secondaryColor,
            ),
          );
        }
      });

  Widget feed() {
    return Container(
        decoration: BoxDecoration(
            color: background2, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            Container(
              child: const Text(
                'Feed',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: whiteWithOpacity75),
                textAlign: TextAlign.left,
              ),
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.all(10),
            ),
            feedlist()
          ],
        ));
  }

  Widget news() => Container(
        decoration: BoxDecoration(
            color: background2, borderRadius: BorderRadius.circular(10)),
        child: Column(children: <Widget>[
          Container(
            child: const Text(
              'News',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: whiteWithOpacity75),
              textAlign: TextAlign.left,
            ),
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.all(10),
          ),
          SizedBox(
              child: latestnews(),
              height: MediaQuery.of(context).size.height * 0.4),
        ]),
      );
  Widget latestnews() =>
      BlocBuilder<SubscribeCubit, SubscribeState>(builder: (context, state) {
        if (state is SubscriptionDataLoaded) {
          subscribetonews(state.subscriptionId);
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
                  child: newsItem(headline, imagePath, createdAt, true),
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
              return const Center(
                child: Text(
                  'Subscription To News Failed to load data \nReason : //',
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryColor,
                  ),
                ),
              );
            } else {
              return Text(state.toString());
            }
          });
        } else if (state is SubscriptonDataFailed) {
          logger.i('Market Event Stream Failed $state');
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

  void subscribetonews(SubscriptionId subscriptionId) {
    context.read<NewsSubscriptionCubit>().GetNewsFeed(subscriptionId);
  }

  Widget newsItem(
    String text,
    String imagePath,
    String createdAt,
    bool islatest,
  ) {
    String dur = getdur(createdAt);
    if (!islatest) {
      return (Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(text,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15)),
                      ),
                      fit: FlexFit.loose,
                    ),
                  ),
                  const SizedBox.square(
                    dimension: 5,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(dur,
                          style:
                              const TextStyle(color: lightGray, fontSize: 12)))
                ]),
          ],
        ),
      ));
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Flexible(
                        child: Text(text,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15)),
                        fit: FlexFit.loose),
                  ),
                  const SizedBox.square(
                    dimension: 5,
                  ),
                  Text(dur,
                      style: const TextStyle(color: lightGray, fontSize: 12)),
                ]),
            const SizedBox.square(
              dimension: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(imagePath),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                fit: BoxFit.contain,
              ),
            )
          ]);
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
