part of 'market_event_bloc.dart';

// ignore: camel_case_types
abstract class MarketEvent_events extends Equatable {
  const MarketEvent_events();
  @override
  List<Object> get props => [];
}

class GetMarketEvent extends MarketEvent_events {
  const GetMarketEvent();
  
}

class GetMarketEventFeed extends MarketEvent_events {
  final SubscriptionId subscriptionId;
  const GetMarketEventFeed(this.subscriptionId);
  @override
  List<Object> get props => [subscriptionId];
}

class GetMoreMarketEvent extends MarketEvent_events {
  final int lasteventid;
  const GetMoreMarketEvent(this.lasteventid);
  
}

