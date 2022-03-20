part of 'ipo_orders_cubit.dart';

abstract class IpoOrdersState extends Equatable {
  const IpoOrdersState();

  @override
  List<Object> get props => [];
}

class IpoOrdersInitial extends IpoOrdersState {}

class GetMyIpoOrdersSucess extends IpoOrdersState {
  final List<IpoBid> ipostocklist;
  const GetMyIpoOrdersSucess(this.ipostocklist);

  @override
  List<Object> get props => [ipostocklist];
}

class GetMyIpoOrdersFailure extends IpoOrdersState {
  final String msg;
  const GetMyIpoOrdersFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class CancelIpoBidSucess extends IpoOrdersState {
  const CancelIpoBidSucess();
}

class CancelIpoBidFailure extends IpoOrdersState {
  final String msg;
  const CancelIpoBidFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
