part of 'place_order_cubit.dart';

abstract class PlaceOrderState extends Equatable {
  const PlaceOrderState();

  @override
  List<Object> get props => [];
}

class PlaceOrderInitial extends PlaceOrderState {}

class PlaceOrderLoading extends PlaceOrderState {
  const PlaceOrderLoading();
}

class PlaceOrderFailure extends PlaceOrderState {
  final String statusMessage;

  const PlaceOrderFailure(this.statusMessage);

  @override
  List<Object> get props => [statusMessage];
}

class PlaceOrderSuccess extends PlaceOrderState {
  final int orderId;

  const PlaceOrderSuccess(this.orderId);

  @override
  List<Object> get props => [orderId];
}
