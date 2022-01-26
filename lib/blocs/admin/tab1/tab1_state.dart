part of 'tab1_cubit.dart';

abstract class Tab1State extends Equatable {
  const Tab1State();
  @override
  List<Object> get props => [];
}

class Tab1Initial extends Tab1State {}

abstract class SendNewsState extends Equatable {
  const SendNewsState();

  @override
  List<Object> get props => [];
}

class SendNewsInitial extends Tab1State {}

class SendNewsLoading extends Tab1State {
  const SendNewsLoading();
}

class SendNewsFailure extends Tab1State {
  final String msg;

  const SendNewsFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class SendNewsSuccess extends Tab1State {
  final String msg;

  const SendNewsSuccess(this.msg);
}

abstract class SendNotificationsState extends Equatable {
  const SendNotificationsState();

  @override
  List<Object> get props => [];
}

class SendNotificationsInitial extends Tab1State {}

class SendNotificationsLoading extends Tab1State {
  const SendNotificationsLoading();
}

class SendNotificationsFailure extends Tab1State {
  final String msg;

  const SendNotificationsFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class SendNotificationsSuccess extends Tab1State {
  final String msg;

  const SendNotificationsSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class SetMarketDayState extends Equatable {
  const SetMarketDayState();

  @override
  List<Object> get props => [];
}

class SetMarketDayInitial extends Tab1State {}

class SetMarketDayLoading extends Tab1State {
  const SetMarketDayLoading();
}

class SetMarketDayFailure extends Tab1State {
  final String msg;

  const SetMarketDayFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class SetMarketDaySuccess extends Tab1State {
  final String msg;

  const SetMarketDaySuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class SendDividendsState extends Equatable {
  const SendDividendsState();

  @override
  List<Object> get props => [];
}

class SendDividendsInitial extends Tab1State {}

class SendDividendsLoading extends Tab1State {
  const SendDividendsLoading();
}

class SendDividendsFailure extends Tab1State {
  final String msg;

  const SendDividendsFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class SendDividendsSuccess extends Tab1State {
  final String msg;

  const SendDividendsSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class SetGivesDividendsState extends Equatable {
  const SetGivesDividendsState();

  @override
  List<Object> get props => [];
}

class SetGivesDividendsInitial extends Tab1State {}

class SetGivesDividendsLoading extends Tab1State {
  const SetGivesDividendsLoading();
}

class SetGivesDividendsFailure extends Tab1State {
  final String msg;

  const SetGivesDividendsFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class SetGivesDividendsSuccess extends Tab1State {
  final String msg;

  const SetGivesDividendsSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class SetBankruptcyState extends Equatable {
  const SetBankruptcyState();

  @override
  List<Object> get props => [];
}

class SetBankruptcyInitial extends Tab1State {}

class SetBankruptcyLoading extends Tab1State {
  const SetBankruptcyLoading();
}

class SetBankruptcyFailure extends Tab1State {
  final String msg;

  const SetBankruptcyFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class SetBankruptcySuccess extends Tab1State {
  final String msg;

  const SetBankruptcySuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class LoadStocksState extends Equatable {
  const LoadStocksState();

  @override
  List<Object> get props => [];
}

class LoadStocksInitial extends Tab1State {}

class LoadStocksLoading extends Tab1State {
  const LoadStocksLoading();
}

class LoadStocksFailure extends Tab1State {
  final String msg;

  const LoadStocksFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class LoadStocksSuccess extends Tab1State {
  final String msg;

  const LoadStocksSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}
