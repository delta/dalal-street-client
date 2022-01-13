import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/MarketEvent.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/market_events/market_event_bloc.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int i = 1;
  final ScrollController _scrollController = ScrollController();
  List<MarketEvent> mapMarketEvents = [];
  @override
  void initState() {
    super.initState();
    context.read<MarketEventBloc>().add(const GetMarketEvent());

    context.read<SubscribeCubit>().subscribe(DataStreamType.MARKET_EVENTS);
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          context.read<MarketEventBloc>().add(GetMoreMarketEvent(10 * i));
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
                news(mapMarketEvents),
                const SizedBox.square(
                  dimension: 20,
                ),
                feed(mapMarketEvents, _scrollController),
              ],
            )));
  }
}

Widget feed(
    List<MarketEvent> mapMarketEvents, ScrollController _scrollController) {
  return Container(
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: <Widget>[
          Container(
            child: const Text(
              'Feed',
              style: TextStyle(fontSize: 20, color: lightGray),
              textAlign: TextAlign.left,
            ),
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.all(10),
          ),
          feedlist(mapMarketEvents, _scrollController)
        ],
      ));
}

Widget news(List<MarketEvent> mapMarketEvents) => Container(
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(10)),
      child: Column(children: <Widget>[
        Container(
          child: const Text(
            'News',
            style: TextStyle(fontSize: 20, color: lightGray),
            textAlign: TextAlign.left,
          ),
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.all(10),
        ),
        latestnews(mapMarketEvents)
      ]),
    );

Widget feedlist(List<MarketEvent> mapMarketEvents,
        ScrollController _scrollController) =>
    BlocBuilder<MarketEventBloc, MarketEventState>(builder: (context, state) {
      if (state is GetMarketEventSucess) {
        mapMarketEvents.addAll(state.marketEventsList.marketEvents);
        return BlocBuilder<SubscribeCubit, SubscribeState>(
            builder: (context, state) {
          if (state is SubscriptionDataLoaded) {
            context
                .read<MarketEventBloc>()
                .add(GetMarketEventFeed(state.subscriptionId));

            return SingleChildScrollView(
                child: SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: mapMarketEvents.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  MarketEvent marketEvent = mapMarketEvents[index];
                  String headline = marketEvent.headline;
                  String imagePath = marketEvent.imagePath;
                  String createdAt = marketEvent.createdAt;
                  return (newsItem(headline, imagePath, createdAt));
                },
              ),
              height: 500,
            ));
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
      } else if (state is GetMarketEventFailure) {
        return const Text('Error');
      } else {
        return const Center(
          child: CircularProgressIndicator(
            color: secondaryColor,
          ),
        );
      }
    });

Widget latestnews(List<MarketEvent> mapMarketEvents) =>
    BlocBuilder<MarketEventBloc, MarketEventState>(builder: (context, state) {
      if (state is GetMarketEventSucess) {
        if (mapMarketEvents.isEmpty) {
          mapMarketEvents.addAll(state.marketEventsList.marketEvents);
        }

        return BlocBuilder<SubscribeCubit, SubscribeState>(
            builder: (context, state) {
          if (state is SubscriptionDataLoaded) {
            context
                .read<MarketEventBloc>()
                .add(GetMarketEventFeed(state.subscriptionId));

            MarketEvent marketEvent = mapMarketEvents[0];
            String headline = marketEvent.headline;
            String imagePath = marketEvent.imagePath;
            String createdAt = marketEvent.createdAt;
            return newsItem(headline, imagePath, createdAt);
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
      } else if (state is GetMarketEventFailure) {
        return const Text('Error');
      } else {
        return const Center(
          child: CircularProgressIndicator(
            color: secondaryColor,
          ),
        );
      }
    });

Widget newsItem(String text, String imagePath, String createdAt) {
  return (Container(
    padding: const EdgeInsets.all(10),
    child: BlocBuilder<MarketEventBloc, MarketEventState>(
        builder: (context, state) {
      if (state is SubscriptionToMarketEventSuccess) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                width: 100,
                height: 100,
                image: NetworkImage(imagePath),
              ),
            ),
            Flexible(
                child: Text(text,
                    style: const TextStyle(color: Colors.white, fontSize: 15)),
                fit: FlexFit.loose),
          ],
        );
      } else if (state is SubscriptionToMarketEventFailed) {
        return const Center(
          child: Text(
            'Subscription To Market Event Failed',
          ),
        );
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                width: 100,
                height: 100,
                image: NetworkImage(imagePath),
              ),
            ),
            Flexible(
                child: Text(text,
                    style: const TextStyle(color: Colors.white, fontSize: 15)),
                fit: FlexFit.loose),
          ],
        );
      }
    }),
  ));
}
