part of 'my_orders_cubit.dart';

abstract class MyOrdersState extends Equatable {
  const MyOrdersState();

  @override
  List<Object> get props => [];
}

class OpenOrdersInitial extends MyOrdersState {}

// this state will be emitted on each open orders update as
// well as the initial fetch
class OpenOrdersSuccess extends MyOrdersState {
  final Map<int, Ask> openAskMap;
  final Map<int, Bid> openBidMap;

  const OpenOrdersSuccess(this.openAskMap, this.openBidMap);

  @override
  List<Object> get props => [openAskMap, openAskMap];
}

class OpenOrdersFailure extends MyOrdersState {
  final String error;

  const OpenOrdersFailure(this.error);

  @override
  List<Object> get props => [error];
}

class CancelOrderFailure extends MyOrdersState {
  final String error;

  const CancelOrderFailure(this.error);

  @override
  List<Object> get props => [error];
}
