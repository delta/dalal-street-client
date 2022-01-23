part of 'open_market_cubit.dart';

abstract class OpenMarketState extends Equatable {
  const OpenMarketState();

  @override
  List<Object> get props => [];
}

class OpenMarketInitial extends OpenMarketState {}

class OpenMarketLoading extends OpenMarketState {
  const OpenMarketLoading();
}

class OpenMarketFailure extends OpenMarketState {
  final String msg;

  const OpenMarketFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class OpenMarketSuccess extends OpenMarketState {
  final String msg;

  const OpenMarketSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}
