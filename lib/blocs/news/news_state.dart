part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();
  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class GetNewsSucess extends NewsState {
  final GetMarketEventsResponse marketEventsList;
  const GetNewsSucess(this.marketEventsList);
  @override
  List<Object> get props => [marketEventsList];
}

class GetNewsFailure extends NewsState {
  final String error;
  const GetNewsFailure(this.error);
  @override
  List<Object> get props => [error];
}

class GetMoreNewsSucess extends NewsState {
  final GetMarketEventsResponse marketEventsList;
  const GetMoreNewsSucess(this.marketEventsList);
  @override
  List<Object> get props => [marketEventsList];
}

class GetMoreNewsFailure extends NewsState {
  final String error;
  const GetMoreNewsFailure(this.error);
  @override
  List<Object> get props => [error];
}
