part of 'exchange_stream_bloc.dart';

abstract class ExchangeStreamEvent extends Equatable {
  const ExchangeStreamEvent();

  @override
  List<Object> get props => [];
}

class SubscribeToStockExchange extends ExchangeStreamEvent {
  final SubscriptionId subscriptionId;
  const SubscribeToStockExchange(this.subscriptionId);

  @override
  List<Object> get props => [subscriptionId];
}
