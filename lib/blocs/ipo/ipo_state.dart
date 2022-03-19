part of 'ipo_cubit.dart';

abstract class IpoState extends Equatable {
  const IpoState();

  @override
  List<Object> get props => [];
}

class IpoInitial extends IpoState {}

class GetIpoStockListSucess extends IpoState {
  Map<int, IpoStock> Ipostocklist;
  GetIpoStockListSucess(this.Ipostocklist);
  @override
  List<Object> get props => [Ipostocklist];
}

class GetIpoStockListFailure extends IpoState {
  String msg;
  GetIpoStockListFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class PlaceIpoSucess extends IpoState {
  const PlaceIpoSucess();
}

class PlaceIpoFailure extends IpoState {
  String msg;
  PlaceIpoFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
