part of 'exchange_cubit.dart';

abstract class ExchangeState extends Equatable {
  const ExchangeState();

  @override
  List<Object> get props => [];
}

class ExchangeInitial extends ExchangeState {}

class ExchangeLoading extends ExchangeState {
  const ExchangeLoading();  
}

class ExchangeFailure extends ExchangeState {
  final String msg;

  const ExchangeFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class ExchangeSuccess extends ExchangeState {
  final BuyStocksFromExchangeResponse exchangeResponse;

  const ExchangeSuccess(this.exchangeResponse);

  @override
  List<Object> get props => [exchangeResponse];
}
