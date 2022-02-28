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
  final int stockId;
  final int stockQuantity;

  const MortgageSheetSuccess(this.stockId,this.stockQuantity);

  @override
  List<Object> get props => [stockId,stockQuantity];
}

class MortgageSheetFailure extends MortgageSheetState {
  final String msg;

  const MortgageSheetFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
