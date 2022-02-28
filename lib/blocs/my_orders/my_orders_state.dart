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
  final List<Ask> openAskOrders;
  final List<Bid> openBidOrders;

  const OpenOrdersSuccess(this.openAskOrders, this.openBidOrders);

  @override
  List<Object> get props => [openAskOrders, openBidOrders];
}

class NoOpenOrders extends MyOrdersState {
  const NoOpenOrders();
  @override
  List<Object> get props => [];
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

class CancelOrderSuccess extends MyOrdersState {
  const CancelOrderSuccess();
}
