part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserLogIn extends UserEvent {
  final String email;
  final String password;

  const UserLogIn(this.email, this.password);
}

class UserLogOut extends UserEvent {
  const UserLogOut();
}
