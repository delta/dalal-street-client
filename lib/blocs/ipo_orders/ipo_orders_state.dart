part of 'ipo_orders_cubit.dart';

abstract class IpoOrdersState extends Equatable {
  const IpoOrdersState();

  @override
  List<Object> get props => [];
}

class IpoOrdersInitial extends IpoOrdersState {}

class GetMyIpoOrdersSucess extends IpoOrdersState {
  List<IpoBid> Ipostocklist;
  GetMyIpoOrdersSucess(this.Ipostocklist);
}

class GetMyIpoOrdersFailure extends IpoOrdersState {
  String msg;
  GetMyIpoOrdersFailure(this.msg);
}

class CancelIpoBidSucess extends IpoOrdersState {
  const CancelIpoBidSucess();
}

class CancelIpoBidFailure extends IpoOrdersState {
  String msg;
  CancelIpoBidFailure(this.msg);
}