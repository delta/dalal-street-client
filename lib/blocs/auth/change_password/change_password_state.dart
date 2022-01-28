part of 'change_password_cubit.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {
  const ChangePasswordLoading();
}

class ChangePasswordSuccess extends ChangePasswordState {
  final String msg;

  const ChangePasswordSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

class ChangePasswordFailure extends ChangePasswordState {
  final String msg;

  const ChangePasswordFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
