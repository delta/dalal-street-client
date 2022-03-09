import 'package:dalal_street_client/blocs/market_event/events/market_event_cubit.dart';
import 'package:dalal_street_client/blocs/market_event/stream/market_events_stream_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/pages/news/newsdetail_page.dart';
import 'package:dalal_street_client/proto_build/models/MarketEvent.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/iso_to_datetime.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsPageWrapper extends StatelessWidget {
  const NewsPageWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => MarketEventCubit()),
      BlocProvider(create: (context) => MarketEventsStreamCubit())
    ], child: const NewsPage());
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    context.read<MarketEventCubit>().getMarketEvents();
    context.read<MarketEventsStreamCubit>().getMarketEventsUpdates();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<MarketEventCubit>().getMarketEvents();
      }
    });
  }

  @override
  void dispose() {
    context.read<MarketEventsStreamCubit>().unsubscribe();
    _scrollController.dispose();
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
                      screenWidth * 0.15,
                      screenWidth * 0.03,
                      screenWidth * 0.15,
                      screenWidth * 0.03),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: newsBody(true),
                  )),
            )
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: Colors.black,
              child: SingleChildScrollView(
                  controller: _scrollController, child: newsBody(false)));
    }())));
  }

  BlocBuilder<MarketEventCubit, MarketEventState> newsBody(bool isWeb) {
    List<MarketEvent> marketEvents = [];
    return BlocBuilder<MarketEventCubit, MarketEventState>(
      builder: (context, state) {
        if (state is MarketEventInitial) {
          return const Center(child: DalalLoadingBar());
        }

        if (state is MarketEventFailure) {
          return Center(
            child: Column(
              children: [
                const Text('Failed to reach server'),
                const SizedBox(height: 20),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () =>
                        context.read<MarketEventCubit>().getMarketEvents(),
                    child: const Text('Retry'),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is MarketEventSuccess) {
          marketEvents.addAll(state.marketEvents);
          return BlocBuilder<MarketEventsStreamCubit, MarketEventsStreamState>(
            builder: (context, state) {
              if (state is MarketEventsStreamUpdate) {
                marketEvents.insert(0, state.marketEvent);
              }

              if (marketEvents.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        'No recent news',
                        style: TextStyle(
                            fontSize: 20,
                            color: white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                );
              }

              return Column(
                children: <Widget>[
                  topNewsContainer(marketEvents[0], isWeb),
                  const SizedBox.square(
                    dimension: 20,
                  ),
                  (marketEvents.length > 1
                      ? feed(marketEvents, isWeb)
                      : Container()),
                ],
              );
            },
          );
        }

        // this wont be returned hmm
        return Container();
      },
    );
  }

  Widget feedList(List<MarketEvent> marketEvents, bool isWeb) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: marketEvents.length,
      itemBuilder: (context, index) {
        // first news will be show in top news container
        // skipping here
        if (index == 0) {
          return Container();
        }
        MarketEvent marketEvent = marketEvents[index];
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
  }

  Widget feed(List<MarketEvent> marketEvents, bool isWeb) {
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
            feedList(marketEvents, isWeb)
          ],
        ));
  }

  Widget topNewsContainer(MarketEvent latestMarketEvent, bool isWeb) =>
      Container(
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
          topNewsItem(latestMarketEvent, isWeb),
        ]),
      );

  Widget topNewsItem(MarketEvent marketEvent, bool isWeb) {
    String headline = marketEvent.headline;
    String imagePath = marketEvent.imagePath;
    String createdAt = marketEvent.createdAt;
    String text = marketEvent.text;
    String dur = ISOtoDateTime(createdAt);
    return GestureDetector(
        child: () {
          return isWeb
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  alignment: Alignment.centerLeft,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: MediaQuery.of(context).size.height * 0.35,
                              fit: BoxFit.fill,
                              image: NetworkImage(imagePath),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(headline,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 24),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(text,
                                    style: const TextStyle(
                                        color: lightGray, fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text('Published on ' + dur,
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: lightGray,
                                        fontSize: 18))
                              ]),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  alignment: Alignment.centerLeft,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(headline,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  maxLines: 3),
                              SizedBox.square(
                                dimension: isWeb ? 20 : 10,
                              ),
                              Text(
                                'Published on ' + dur,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: lightGray,
                                    fontSize: 14),
                                textAlign: TextAlign.left,
                              )
                            ]),
                        SizedBox.square(
                          dimension: isWeb ? 30 : 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                              image: NetworkImage(imagePath),
                              width: MediaQuery.of(context).size.width * 0.65,
                              height: MediaQuery.of(context).size.height * 0.25,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ]));
        }(),
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
  }

  Widget newsItem(String text, String imagePath, String createdAt, bool isWeb) {
    String dur = ISOtoDateTime(createdAt);
    return (Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              width: isWeb ? 200 : 125,
              height: isWeb ? 100 : 75,
              fit: BoxFit.fill,
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
                            color: Colors.white, fontSize: isWeb ? 24 : 18),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3),
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
}
