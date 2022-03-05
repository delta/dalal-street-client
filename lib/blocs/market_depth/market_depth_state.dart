part of 'market_depth_bloc.dart';

abstract class MarketDepthState extends Equatable {
  const MarketDepthState();

  @override
  List<Object> get props => [];
}

class MarketDepthInitial extends MarketDepthState {}

class SubscriptionToMarketDepthFailed extends MarketDepthState {
  final String error;
  const SubscriptionToMarketDepthFailed(this.error);

  @override
  List<Object> get props => [error];
}

class MarketDepthUpdateState extends MarketDepthState {
  final List<MarketOrders> askDepth;
  final List<MarketOrders> bidDepth;

  const MarketDepthUpdateState(this.askDepth, this.bidDepth);

  @override
  List<Object> get props => [askDepth, bidDepth];
}

class TradeUpdateState extends MarketDepthState {
  final List<Trade> trades;

  const TradeUpdateState(this.trades);
  @override
  List<Object> get props => [trades];
}
