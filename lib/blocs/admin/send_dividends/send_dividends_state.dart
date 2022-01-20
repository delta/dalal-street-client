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
  final stockID;
  final dividend_amount;

  const SendDividendsSuccess(this.stockID, this.dividend_amount);
}
