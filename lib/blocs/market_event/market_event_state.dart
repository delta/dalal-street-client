part of 'market_event_bloc.dart';

abstract class MarketEventState extends Equatable {
  const MarketEventState();
  @override
  List<Object> get props => [];
}

class MarketEventInitial extends MarketEventState {}

class GetMarketEventSucess extends MarketEventState {
  final GetMarketEventsResponse marketEventsList;
  const GetMarketEventSucess(this.marketEventsList);
  @override
  List<Object> get props => [marketEventsList];
}

class GetMarketEventFailure extends MarketEventState {
  final String error;
  const GetMarketEventFailure(this.error);
  @override
  List<Object> get props => [error];
}

class SubscriptionToMarketEventSuccess extends MarketEventState {
  final MarketEventUpdate news;
  const SubscriptionToMarketEventSuccess(this.news);

  @override
  List<Object> get props => [news];
}

class SubscriptionToMarketEventFailed extends MarketEventState {
  final String subscriptionId;
  const SubscriptionToMarketEventFailed(this.subscriptionId);

  @override
  List<Object> get props => [subscriptionId];
}

class MarketEventsLoaded extends MarketEventState {
  final List<MarketEvent> marketevents;

  MarketEventsLoaded(this.marketevents);
}

class MarketEventsLoading extends MarketEventState {
  final List<MarketEvent> oldmarketevents;
  final bool isFirstFetch;

  MarketEventsLoading(this.oldmarketevents, {this.isFirstFetch = false});
}
