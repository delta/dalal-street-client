part of 'send_dividends_cubit.dart';

abstract class SendDividendsState extends Equatable {
  const SendDividendsState();

  @override
  List<Object> get props => [];
}

class SendDividendsInitial extends SendDividendsState {}

class SendDividendsLoading extends SendDividendsState {
  const SendDividendsLoading();
}

class SendDividendsFailure extends SendDividendsState {
  final String msg;

  const SendDividendsFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class SendDividendsSuccess extends SendDividendsState {
  final String msg;

  const SendDividendsSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}
