part of 'stock_prices_bloc.dart';

abstract class StockPricesState extends Equatable {
  const StockPricesState();

  @override
  List<Object> get props => [];
}

class StockPricesInitial extends StockPricesState {}

class SubscriptionToStockPricesSuccess extends StockPricesState {
  final StockPricesUpdate stockPrices;
  const SubscriptionToStockPricesSuccess(this.stockPrices);

  @override
  List<Object> get props => [stockPrices];
}

class SubscriptionToStockPricesFailed extends StockPricesState {
  final String error;
  const SubscriptionToStockPricesFailed(this.error);

  @override
  List<Object> get props => [error];
}
