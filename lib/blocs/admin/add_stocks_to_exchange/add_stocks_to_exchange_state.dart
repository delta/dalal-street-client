part of 'add_stocks_to_exchange_cubit.dart';

abstract class AddStocksToExchangeState extends Equatable {
  const AddStocksToExchangeState();

  @override
  List<Object> get props => [];
}

class AddStocksToExchangeInitial extends AddStocksToExchangeState {}

class AddStocksToExchangeLoading extends AddStocksToExchangeState {
  const AddStocksToExchangeLoading();
}

class AddStocksToExchangeFailure extends AddStocksToExchangeState {
  final String msg;

  const AddStocksToExchangeFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class AddStocksToExchangeSuccess extends AddStocksToExchangeState {
  final String msg;

  const AddStocksToExchangeSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}
