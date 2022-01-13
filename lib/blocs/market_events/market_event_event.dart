part of 'market_event_bloc.dart';

abstract class MarketEventEvents extends Equatable {
  const MarketEventEvents();
  @override
  List<Object> get props => [];
}

class GetMarketEvent extends MarketEventEvents {
  const GetMarketEvent();
}

class GetMarketEventFeed extends MarketEventEvents {
  final SubscriptionId subscriptionId;
  const GetMarketEventFeed(this.subscriptionId);
  @override
  List<Object> get props => [subscriptionId];
}

class GetMoreMarketEvent extends MarketEventEvents {
  final int lasteventid;
  const GetMoreMarketEvent(this.lasteventid);
}
