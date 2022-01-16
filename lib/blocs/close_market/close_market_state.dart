part of 'close_market_cubit.dart';

abstract class CloseMarketState extends Equatable {
  const CloseMarketState();

  @override
  List<Object> get props => [];
}

class CloseMarketInitial extends CloseMarketState {}

class CloseMarketLoading extends CloseMarketState {
  const CloseMarketLoading();
}

class CloseMarketFailure extends CloseMarketState {
  final String msg;

  const CloseMarketFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class CloseMarketSuccess extends CloseMarketState {
  final bool update_prev_day_close;

  const CloseMarketSuccess(this.update_prev_day_close);
}
