part of 'exchange_sheet_cubit.dart';

abstract class ExchangeSheetState extends Equatable {
  const ExchangeSheetState();

  @override
  List<Object> get props => [];
}

class ExchangeSheetInitial extends ExchangeSheetState {}

class ExchangeSheetLoading extends ExchangeSheetState {
  const ExchangeSheetLoading();
}

class ExchangeSheetSuccess extends ExchangeSheetState {
  const ExchangeSheetSuccess();
}

class ExchangeSheetFailure extends ExchangeSheetState {
  final String msg;

  const ExchangeSheetFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
