import 'package:dalal_street_client/blocs/news/news_bloc.dart';
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
    int i = 1;
    super.initState();
    context.read<NewsBloc>().add(const GetNews());
    context.read<SubscribeCubit>().subscribe(DataStreamType.MARKET_EVENTS);
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          context.read<NewsBloc>().add(GetMoreNews(10 * i));
          i++;
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
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            color: Colors.black,
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
            )));
  }

  Widget feedlist() =>
      BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
        if (state is GetNewsSucess) {
          mapMarketEvents.addAll(state.marketEventsList.marketEvents);
          return BlocBuilder<SubscribeCubit, SubscribeState>(
              builder: (context, state) {
            if (state is SubscriptionDataLoaded) {
              context.read<NewsBloc>().add(GetNewsFeed(state.subscriptionId));

              return SingleChildScrollView(
                  child: SizedBox(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: mapMarketEvents.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          MarketEvent marketEvent = mapMarketEvents[index];
                          String headline = marketEvent.headline;
                          String imagePath = marketEvent.imagePath;
                          String createdAt = marketEvent.createdAt;
                          String text = marketEvent.text;
                          return GestureDetector(
                              child: newsItem(
                                  headline, imagePath, createdAt, false),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewsDetail(
                                        index: index,
                                        text: text,
                                        imagePath: imagePath,
                                        headline: headline),
                                  )));
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                      height: MediaQuery.of(context).size.height * 0.5));
            } else if (state is SubscriptonDataFailed) {
              logger.i('Stream Failed $state');
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
        } else if (state is GetNewsFailure) {
          return const Text('Error');
        } else {
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
              child: latestnews(mapMarketEvents),
              height: MediaQuery.of(context).size.height * 0.3),
        ]),
      );
  Widget latestnews(List<MarketEvent> mapMarketEvents) =>
      BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
        if (state is GetNewsSucess) {
          if (mapMarketEvents.isEmpty) {
            mapMarketEvents.addAll(state.marketEventsList.marketEvents);
          }

          return BlocBuilder<SubscribeCubit, SubscribeState>(
              builder: (context, state) {
            if (state is SubscriptionDataLoaded) {
              context.read<NewsBloc>().add(GetNewsFeed(state.subscriptionId));

              MarketEvent marketEvent = mapMarketEvents[0];
              String headline = marketEvent.headline;
              String imagePath = marketEvent.imagePath;
              String createdAt = marketEvent.createdAt;
              return newsItem(headline, imagePath, createdAt, true);
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
        } else if (state is GetNewsFailure) {
          return const Text('Error');
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: secondaryColor,
            ),
          );
        }
      });

  Widget newsItem(
      String text, String imagePath, String createdAt, bool islatest) {
    return (Container(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
        String dur;
        DateTime dt1 = DateTime.parse(createdAt);
        DateTime dt2 = DateTime.now();
        Duration diff = dt2.difference(dt1);
        if (diff.inDays == 0) {
          if (diff.inHours == 0) {
            dur = diff.inMinutes.toString() + ' minutes ago';
          } else {
            dur = diff.inHours.toString() + ' hour ago';
          }
        } else {
          dur = diff.inDays.toString() + ' day ago';
        }
        if (state is SubscriptionToNewsSuccess) {
          if (!islatest) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
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
                              style: const TextStyle(
                                  color: lightGray, fontSize: 12)))
                    ]),
              ],
            );
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
                            style: const TextStyle(
                                color: lightGray, fontSize: 12)),
                      ]),
                  const SizedBox.square(
                    dimension: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: NetworkImage(imagePath),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.15,
                      fit: BoxFit.fill,
                    ),
                  )
                ]);
          }
        } else if (state is SubscriptionToNewsFailed) {
          return const Center(
            child: Text(
              'Subscription To Market Event Failed',
            ),
          );
        } else {
          if (!islatest) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
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
                              style: const TextStyle(
                                  color: lightGray, fontSize: 12))),
                    ]),
              ],
            );
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
                            style: const TextStyle(
                                color: lightGray, fontSize: 12)),
                      ]),
                  const SizedBox.square(
                    dimension: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: NetworkImage(imagePath),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.15,
                      fit: BoxFit.fill,
                    ),
                  )
                ]);
          }
        }
      }),
    ));
  }
}
