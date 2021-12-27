part of 'stockbar_cubit.dart';

abstract class StockbarState extends Equatable {
  const StockbarState();

  @override
  List<Object> get props => [];
}

class StockbarInitial extends StockbarState {}

class StockPriceUpdate extends StockbarState {
  final Map<int, Int64> stockPrice;

  const StockPriceUpdate(this.stockPrice);
}
