part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserLogIn extends UserEvent {
  final LoginResponse loginResponse;

  const UserLogIn(this.loginResponse);

  @override
  List<Object> get props => [loginResponse];
}

class UserLogOut extends UserEvent {
  const UserLogOut();
}
