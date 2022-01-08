part of 'load_stocks_cubit.dart';

abstract class LoadStocksState extends Equatable {
  const LoadStocksState();

  @override
  List<Object> get props => [];
}

class LoadStocksInitial extends LoadStocksState {}

class LoadStocksLoading extends LoadStocksState {
  const LoadStocksLoading();
}

class LoadStocksFailure extends LoadStocksState {
  final String msg;

  const LoadStocksFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class LoadStocksSuccess extends LoadStocksState {
  const LoadStocksSuccess();
}
