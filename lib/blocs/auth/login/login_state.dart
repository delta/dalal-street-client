part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginFailure extends LoginState {
  final String msg;
  final bool isMailVerified;

  const LoginFailure(this.msg, this.isMailVerified);

  @override
  List<Object> get props => [msg];
}

class LoginSuccess extends LoginState {
  final LoginResponse loginResponse;

  const LoginSuccess(this.loginResponse);

  @override
  List<Object> get props => [loginResponse];
}

class EmailNotVerified extends LoginState {
  final String msg;
  final String email;

  const EmailNotVerified(this.msg, this.email);

  @override
  List<Object> get props => [msg, email];
}
