part of 'stock_prices_bloc.dart';

abstract class StockPricesEvent extends Equatable {
  const StockPricesEvent();

  @override
  List<Object> get props => [];
}

class SubscribeToStockPrices extends StockPricesEvent {
  final SubscriptionId subscriptionId;
  const SubscribeToStockPrices(this.subscriptionId);

  @override
  List<Object> get props => [subscriptionId];
}
