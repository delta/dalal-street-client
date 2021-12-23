part of 'stockprice_cubit.dart';

abstract class StockpriceStreamState extends Equatable {
  const StockpriceStreamState();

  @override
  List<Object> get props => [];
}

class StockpriceStreamLoading extends StockpriceStreamState {}

class StockpriceStreamSuccess extends StockpriceStreamState {}

class StockpriceStreamUpdate extends StockpriceStreamState {
  final StockPricesUpdate stockPrices;

  const StockpriceStreamUpdate(this.stockPrices);
}

class StockpriceStreamError extends StockpriceStreamState {
  final String message;

  const StockpriceStreamError(this.message);
}
