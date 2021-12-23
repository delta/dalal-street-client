part of 'market_depth_bloc.dart';

abstract class MarketDepthEvent extends Equatable {
  const MarketDepthEvent();

  @override
  List<Object> get props => [];
}

class SubscribeToMarketDepthUpdates extends MarketDepthEvent {
  final SubscriptionId subscriptionId;
  const SubscribeToMarketDepthUpdates(this.subscriptionId);

  @override
  List<Object> get props => [subscriptionId];
}
