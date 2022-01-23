part of 'unblock_all_users_cubit.dart';

abstract class UnblockAllUsersState extends Equatable {
  const UnblockAllUsersState();

  @override
  List<Object> get props => [];
}

class UnblockAllUsersInitial extends UnblockAllUsersState {}

class UnblockAllUsersLoading extends UnblockAllUsersState {
  const UnblockAllUsersLoading();
}

class UnblockAllUsersFailure extends UnblockAllUsersState {
  final String msg;

  const UnblockAllUsersFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class UnblockAllUsersSuccess extends UnblockAllUsersState {
  final String msg;

  const UnblockAllUsersSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}
