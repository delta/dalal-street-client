part of 'subscribe_cubit.dart';

abstract class SubscribeState extends Equatable {
  const SubscribeState();

  @override
  List<Object> get props => [];
}

class SubscribeInitial extends SubscribeState {}

class SubscriptionDataLoaded extends SubscribeState {
  final SubscriptionId subscriptionId;
  const SubscriptionDataLoaded(this.subscriptionId);

  @override
  List<Object> get props => [subscriptionId];
}

class SubscriptonDataFailed extends SubscribeState {
  final String message;
  const SubscriptonDataFailed(this.message);

  @override
  List<Object> get props => [message];
}
