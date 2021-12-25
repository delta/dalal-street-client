part of 'market_depth_bloc.dart';

abstract class MarketDepthState extends Equatable {
  const MarketDepthState();

  @override
  List<Object> get props => [];
}

class MarketDepthInitial extends MarketDepthState {}

class SubscriptionToMarketDepthSuccess extends MarketDepthState {
  final MarketDepthUpdate marketDepthUpdate;
  const SubscriptionToMarketDepthSuccess(this.marketDepthUpdate);

  @override
  List<Object> get props => [marketDepthUpdate];
}

class SubscriptionToMarketDepthFailed extends MarketDepthState {
  final String error;
  const SubscriptionToMarketDepthFailed(this.error);

  @override
  List<Object> get props => [error];
}
