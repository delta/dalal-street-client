part of 'set_market_day_cubit.dart';

abstract class SetMarketDayState extends Equatable {
  const SetMarketDayState();

  @override
  List<Object> get props => [];
}

class SetMarketDayInitial extends SetMarketDayState {}

class SetMarketDayLoading extends SetMarketDayState {
  const SetMarketDayLoading();
}

class SetMarketDayFailure extends SetMarketDayState {
  final String msg;

  const SetMarketDayFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class SetMarketDaySuccess extends SetMarketDayState {
  final String msg;

  const SetMarketDaySuccess(this.msg);

  @override
  List<Object> get props => [msg];
}
