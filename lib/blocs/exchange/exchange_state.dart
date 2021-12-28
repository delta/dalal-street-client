part of 'exchange_cubit.dart';

abstract class ExchangeState extends Equatable {
  const ExchangeState();

  @override
  List<Object> get props => [];
}

class ExchangeLoading extends ExchangeState {
  const ExchangeLoading();
}

class ExchangeDataLoaded extends ExchangeState {
  final Map<int, StockExchangeDataPoint> exchangeData;

  const ExchangeDataLoaded(this.exchangeData);

  @override
  List<Object> get props => [exchangeData];
}

class ExchangeFailure extends ExchangeState {
  final String msg;

  const ExchangeFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
