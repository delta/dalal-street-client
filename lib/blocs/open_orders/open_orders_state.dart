part of 'open_orders_cubit.dart';

abstract class OpenOrdersState extends Equatable {
  const OpenOrdersState();

  @override
  List<Object> get props => [];
}

class OpenOrdersInitial extends OpenOrdersState {}
