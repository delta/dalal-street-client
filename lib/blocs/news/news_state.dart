part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();
  @override
  List<Object> get props => [];
}

class MarketEventInitial extends NewsState {}

class GetMarketEventSucess extends NewsState {
  final GetMarketEventsResponse marketEventsList;
  const GetMarketEventSucess(this.marketEventsList);
  @override
  List<Object> get props => [marketEventsList];
}

class GetMarketEventFailure extends NewsState {
  final String error;
  const GetMarketEventFailure(this.error);
  @override
  List<Object> get props => [error];
}

class SubscriptionToMarketEventSuccess extends NewsState {
  final MarketEventUpdate news;
  const SubscriptionToMarketEventSuccess(this.news);

  @override
  List<Object> get props => [news];
}

class SubscriptionToMarketEventFailed extends NewsState {
  final String subscriptionId;
  const SubscriptionToMarketEventFailed(this.subscriptionId);

  @override
  List<Object> get props => [subscriptionId];
}
