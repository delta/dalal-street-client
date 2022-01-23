part of 'add_market_event_cubit.dart';

abstract class AddMarketEventState extends Equatable {
  const AddMarketEventState();

  @override
  List<Object> get props => [];
}

class AddMarketEventInitial extends AddMarketEventState {}

class AddMarketEventLoading extends AddMarketEventState {
  const AddMarketEventLoading();
}

class AddMarketEventFailure extends AddMarketEventState {
  final String msg;

  const AddMarketEventFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class AddMarketEventSuccess extends AddMarketEventState {
  final String msg;

  const AddMarketEventSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}
