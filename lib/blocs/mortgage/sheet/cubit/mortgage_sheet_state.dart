part of 'mortgage_sheet_cubit.dart';

abstract class MortgageSheetState extends Equatable {
  const MortgageSheetState();

  @override
  List<Object> get props => [];
}

class MortgageSheetInitial extends MortgageSheetState {}

class MortgageSheetLoading extends MortgageSheetState {
  const MortgageSheetLoading();
}

class MortgageSheetSuccess extends MortgageSheetState {
  const MortgageSheetSuccess();
}

class MortgageSheetFailure extends MortgageSheetState {
  final String msg;

  const MortgageSheetFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
