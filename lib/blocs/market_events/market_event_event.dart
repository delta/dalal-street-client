part of 'market_event_bloc.dart';

// ignore: camel_case_types
abstract class MarketEventevents extends Equatable {
  const MarketEventevents();
  @override
  List<Object> get props => [];
}

class GetMarketEvent extends MarketEventevents {
  const GetMarketEvent();
}

class GetMarketEventFeed extends MarketEventevents {
  final SubscriptionId subscriptionId;
  const GetMarketEventFeed(this.subscriptionId);
  @override
  List<Object> get props => [subscriptionId];
}

class GetMoreMarketEvent extends MarketEventevents {
  final int lasteventid;
  const GetMoreMarketEvent(this.lasteventid);
}
