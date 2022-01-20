part of 'send_news_cubit.dart';

abstract class SendNewsState extends Equatable {
  const SendNewsState();

  @override
  List<Object> get props => [];
}

class SendNewsInitial extends SendNewsState {}

class SendNewsLoading extends SendNewsState {
  const SendNewsLoading();
}

class SendNewsFailure extends SendNewsState {
  final String msg;

  const SendNewsFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class SendNewsSuccess extends SendNewsState {
  final String news;

  const SendNewsSuccess(this.news);
}
