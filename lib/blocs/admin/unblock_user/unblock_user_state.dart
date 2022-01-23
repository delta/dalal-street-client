part of 'unblock_user_cubit.dart';

abstract class UnblockUserState extends Equatable {
  const UnblockUserState();

  @override
  List<Object> get props => [];
}

class UnblockUserInitial extends UnblockUserState {}

class UnblockUserLoading extends UnblockUserState {
  const UnblockUserLoading();
}

class UnblockUserFailure extends UnblockUserState {
  final String msg;

  const UnblockUserFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class UnblockUserSuccess extends UnblockUserState {
  final String msg;

  const UnblockUserSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}
