part of 'news_subscription_cubit.dart';

abstract class NewsSubscriptionState extends Equatable {
  const NewsSubscriptionState();

  @override
  List<Object> get props => [];
}

class NewsSubscriptionInitial extends NewsSubscriptionState {}
class SubscriptionToNewsSuccess extends NewsSubscriptionState {
  final MarketEventUpdate news;
  const SubscriptionToNewsSuccess(this.news);

  @override
  List<Object> get props => [news];
}

class SubscriptionToNewsFailed extends NewsSubscriptionState {
  final String subscriptionId;
  const SubscriptionToNewsFailed(this.subscriptionId);

  @override
  List<Object> get props => [subscriptionId];
}