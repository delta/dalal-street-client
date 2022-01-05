import 'dart:html';

import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/GetMarketEvents.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/MarketDepth.pbjson.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/MarketEvent.pb.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/market_event/market_event_bloc.dart';

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
    context.read<MarketEventBloc>().add(const GetMarketEvent());

    context.read<SubscribeCubit>().subscribe(DataStreamType.MARKET_EVENTS);
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          context.read<MarketEventBloc>().add(const GetMoreMarketEvent(10));
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
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    news(),
                    const SizedBox.square(
                      dimension: 20,
                    ),
                    feed(_scrollController)
                  ]),
            )));
  }
}

SingleChildScrollView feed(ScrollController _scrollController) {
  return SingleChildScrollView(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  'Feed',
                  style: TextStyle(fontSize: 20, color: lightGray),
                  textAlign: TextAlign.left,
                ),
                alignment: Alignment.topLeft,
                margin: EdgeInsets.all(10),
              ),
              feedlist(_scrollController)
            ],
          )),
    ],
  ));
}

Widget news() => Container(
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(10)),
      child: Column(children: <Widget>[
        Container(
          child: Text(
            'News',
            style: TextStyle(fontSize: 20, color: lightGray),
            textAlign: TextAlign.left,
          ),
          alignment: Alignment.topLeft,
          margin: EdgeInsets.all(10),
        ),
        latestnews()
      ]),
    );

Widget feedlist(ScrollController _scrollController) =>
    BlocBuilder<MarketEventBloc, MarketEventState>(builder: (context, state) {
      // final ScrollController _scrollController = ScrollController();
      if (state is GetMarketEventSucess) {
        List<MarketEvent> mapMarketEvents = state.marketEventsList.marketEvents;
        logger.i(state.marketEventsList.moreExists);
        return BlocBuilder<SubscribeCubit, SubscribeState>(
            builder: (context, state) {
          if (state is SubscriptionDataLoaded) {
            context
                .read<MarketEventBloc>()
                .add(GetMarketEventFeed(state.subscriptionId));

            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: mapMarketEvents.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                MarketEvent marketEvent = mapMarketEvents[index];
                String headline = marketEvent.headline;
                String text = marketEvent.text;
                String imagePath = marketEvent.imagePath;
                String createdAt = marketEvent.createdAt;
                return (newsItem(headline, imagePath, createdAt));
              },
            );
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

Widget latestnews() =>
    BlocBuilder<MarketEventBloc, MarketEventState>(builder: (context, state) {
      if (state is GetMarketEventSucess) {
        List<MarketEvent> mapMarketEvents = state.marketEventsList.marketEvents;

        return BlocBuilder<SubscribeCubit, SubscribeState>(
            builder: (context, state) {
          if (state is SubscriptionDataLoaded) {
            context
                .read<MarketEventBloc>()
                .add(GetMarketEventFeed(state.subscriptionId));

            MarketEvent marketEvent = mapMarketEvents[0];
            String headline = marketEvent.headline;
            String text = marketEvent.text;
            String imagePath = marketEvent.imagePath;
            String createdAt = marketEvent.createdAt;
            return newsItem(headline, imagePath, createdAt);
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
            'SubscriptionToMarketEventFailed',
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
