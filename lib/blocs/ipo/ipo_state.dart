part of 'ipo_cubit.dart';

abstract class IpoState extends Equatable {
  const IpoState();

  @override
  List<Object> get props => [];
}

class IpoInitial extends IpoState {}

class GetIpoStockListSucess extends IpoState {
  final Map<int, IpoStock> ipostocklist;
  const GetIpoStockListSucess(this.ipostocklist);
  @override
  List<Object> get props => [ipostocklist];
}

class GetIpoStockListFailure extends IpoState {
  final String msg;
  const GetIpoStockListFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class PlaceIpoSucess extends IpoState {
  const PlaceIpoSucess();
}

class PlaceIpoFailure extends IpoState {
  final String msg;
  const PlaceIpoFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
