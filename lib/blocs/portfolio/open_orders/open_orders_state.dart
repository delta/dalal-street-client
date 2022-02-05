part of 'open_orders_cubit.dart';

abstract class OpenOrdersState extends Equatable {
  const OpenOrdersState();

  @override
  List<Object> get props => [];
}

class OpenOrdersInitial extends OpenOrdersState {}

class OpenordersSucess extends OpenOrdersState {
  final GetMyOpenOrdersResponse res;
  const OpenordersSucess(this.res);
  @override
  List<Object> get props => [res];
}

class OpenorderFailure extends OpenOrdersState {
  final String msg;
  const OpenorderFailure(this.msg);
  @override
  List<Object> get props => [msg];
}

class CancelorderSucess extends OpenOrdersState{
  const CancelorderSucess();
}
class CancelorderFailure extends OpenOrdersState{
  final String msg;
  const CancelorderFailure(this.msg);
    @override
  List<Object> get props => [msg];
  
}
