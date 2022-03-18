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
}

class GetIpoStockListFailure extends IpoState {
  String msg;
  GetIpoStockListFailure(this.msg);
}

class PlaceIpoSucess extends IpoState {
  const PlaceIpoSucess();
}

class PlaceIpoFailure extends IpoState {
  String msg;
  PlaceIpoFailure(this.msg);
}
