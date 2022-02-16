part of 'openorders_subscription_cubit.dart';

abstract class OpenordersSubscriptionState extends Equatable {
  const OpenordersSubscriptionState();

  @override
  List<Object> get props => [];
}

class OpenordersSubscriptionInitial extends OpenordersSubscriptionState {}

class SubscriptionToOpenOrderSuccess extends OpenordersSubscriptionState {
  final MyOrderUpdate orderUpdate;
  const SubscriptionToOpenOrderSuccess(this.orderUpdate);

  @override
  List<Object> get props => [orderUpdate];
}

class SubscriptionToOpenOrderFailed extends OpenordersSubscriptionState {
  final SubscriptionId subscriptionId;
  const SubscriptionToOpenOrderFailed(this.subscriptionId);

  @override
  List<Object> get props => [subscriptionId];
}
