part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
  @override
  List<Object> get props => [];
}

class GetNews extends NewsEvent {
  const GetNews();
}

class GetNewsFeed extends NewsEvent {
  final SubscriptionId subscriptionId;
  const GetNewsFeed(this.subscriptionId);
  @override
  List<Object> get props => [subscriptionId];
}

class GetMoreNews extends NewsEvent {
  final int lasteventid;
  const GetMoreNews(this.lasteventid);
  @override
  List<Object> get props => [lasteventid];
}
