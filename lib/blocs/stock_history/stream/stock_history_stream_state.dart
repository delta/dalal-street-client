part of 'stock_history_stream_cubit.dart';

abstract class StockHistoryStreamState extends Equatable {
  const StockHistoryStreamState();

  @override
  List<Object> get props => [];
}

class StockHistoryStreamInitial extends StockHistoryStreamState {}

class StockHistoryStreamUpdate extends StockHistoryStreamState {
  final StockHistory stockHistory;

  const StockHistoryStreamUpdate(this.stockHistory);
}

class StockHistoryStreamError extends StockHistoryStreamState {
  final String message;

  const StockHistoryStreamError(this.message);
}
