part of 'stock_history_stream_cubit.dart';

abstract class StockHistoryStreamState extends Equatable {
  const StockHistoryStreamState();

  @override
  List<Object> get props => [];
}

class StockHistoryStreamInitial extends StockHistoryStreamState {}
