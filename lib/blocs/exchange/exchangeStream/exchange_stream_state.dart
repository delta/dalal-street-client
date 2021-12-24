part of 'exchange_stream_bloc.dart';

abstract class ExchangeStreamState extends Equatable {
  const ExchangeStreamState();

  @override
  List<Object> get props => [];
}

class ExchangeStreamInitial extends ExchangeStreamState {}

class SubscriptionToStockExchangeSuccess extends ExchangeStreamState {
  final StockExchangeUpdate stockExchangeUpdate;
  const SubscriptionToStockExchangeSuccess(this.stockExchangeUpdate);

  @override
  List<Object> get props => [stockExchangeUpdate];
}

class SubscriptionToStockExchangeFailed extends ExchangeStreamState {
  final String subscriptionId;
  const SubscriptionToStockExchangeFailed(this.subscriptionId);

  @override
  List<Object> get props => [subscriptionId];
}
