part of 'market_event_bloc.dart';

abstract class MarketEvent_Events extends Equatable {
  const MarketEvent_Events();
  @override
  List<Object> get props => [];
}

class GetMarketEvent extends MarketEvent_Events {
  const GetMarketEvent();
}

class GetMarketEventFeed extends MarketEvent_Events {
  final SubscriptionId subscriptionId;
  const GetMarketEventFeed(this.subscriptionId);
  @override
  List<Object> get props => [subscriptionId];
}
