part of 'set_bankruptcy_cubit.dart';

abstract class SetBankruptcyState extends Equatable {
  const SetBankruptcyState();

  @override
  List<Object> get props => [];
}

class SetBankruptcyInitial extends SetBankruptcyState {}

class SetBankruptcyLoading extends SetBankruptcyState {
  const SetBankruptcyLoading();
}

class SetBankruptcyFailure extends SetBankruptcyState {
  final String msg;

  const SetBankruptcyFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class SetBankruptcySuccess extends SetBankruptcyState {
  final bool is_bankrupt;
  final int stockID;

  const SetBankruptcySuccess(this.is_bankrupt, this.stockID);
}
