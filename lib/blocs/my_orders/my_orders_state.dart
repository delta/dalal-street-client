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
  final List<Ask> openAskArray;
  final List<Bid> openBidArray;

  const OpenOrdersSuccess(this.openAskArray, this.openBidArray);

  @override
  List<Object> get props => [openAskArray, openBidArray];
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

class CancelOrderSucess extends MyOrdersState {
  const CancelOrderSucess();
}
