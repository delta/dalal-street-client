part of 'stock_history_cubit.dart';

abstract class StockHistoryState extends Equatable {
  const StockHistoryState();

  @override
  List<Object> get props => [];
}

class StockHistoryInitial extends StockHistoryState {}

class StockHistoryError extends StockHistoryState {
  final String message;

  const StockHistoryError(this.message);
}

class StockHistorySuccess extends StockHistoryState {
  final Map<String, StockHistory> stockHistoryMap;

  const StockHistorySuccess(this.stockHistoryMap);
}
