part of 'open_orders_cubit.dart';

enum OpenOrderType { open, cancel }

abstract class OpenOrdersState extends Equatable {
  const OpenOrdersState();

  @override
  List<Object> get props => [];
}

class OpenOrdersInitial extends OpenOrdersState {}

class CancelOrderInitial extends OpenOrdersState {}

class GetOpenordersSuccess extends OpenOrdersState {
  final GetMyOpenOrdersResponse res;
  const GetOpenordersSuccess(this.res);
  @override
  List<Object> get props => [res];
}

class OrderFailure extends OpenOrdersState {
  final String msg;
  final OpenOrderType ordertype;
  const OrderFailure(this.msg, this.ordertype);
  @override
  List<Object> get props => [msg, ordertype];
}

class CancelorderSuccess extends OpenOrdersState {
  const CancelorderSuccess();
}
