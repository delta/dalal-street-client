part of 'ipo_cubit.dart';

abstract class IpoState extends Equatable {
  const IpoState();

  @override
  List<Object> get props => [];
}

class IpoInitial extends IpoState {}

// ignore: must_be_immutable
class GetIpoStockListSucess extends IpoState {
  // ignore: non_constant_identifier_names
  Map<int, IpoStock> Ipostocklist;
  GetIpoStockListSucess(this.Ipostocklist);
}

// ignore: must_be_immutable
class GetIpoStockListFailure extends IpoState {
  String msg;
  GetIpoStockListFailure(this.msg);
}

class PlaceIpoSucess extends IpoState {
  const PlaceIpoSucess();
}

// ignore: must_be_immutable
class PlaceIpoFailure extends IpoState {
  String msg;
  PlaceIpoFailure(this.msg);
}
