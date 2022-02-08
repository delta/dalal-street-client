part of 'retrieve_sheet_cubit.dart';

abstract class RetrieveSheetState extends Equatable {
  const RetrieveSheetState();

  @override
  List<Object> get props => [];
}

class RetrieveSheetInitial extends RetrieveSheetState {}

class RetrieveSheetLoading extends RetrieveSheetState {
  const RetrieveSheetLoading();
}

class RetrieveSheetSuccess extends RetrieveSheetState {
  const RetrieveSheetSuccess();
}

class RetrieveSheetFailure extends RetrieveSheetState {
  final String msg;

  const RetrieveSheetFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
