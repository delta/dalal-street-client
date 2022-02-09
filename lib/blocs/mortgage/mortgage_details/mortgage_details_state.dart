part of 'mortgage_details_cubit.dart';

abstract class MortgageDetailsState extends Equatable {
  const MortgageDetailsState();

  @override
  List<Object> get props => [];
}

class MortgageDetailsLoading extends MortgageDetailsState {}

class MortgageDetailsLoaded extends MortgageDetailsState {
  final List<MortgageDetail> mortgageDetails;

  const MortgageDetailsLoaded(this.mortgageDetails);

  @override
  List<Object> get props => [mortgageDetails];
}

class MortgageDetailsFailure extends MortgageDetailsState {
  final String msg;

  const MortgageDetailsFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
