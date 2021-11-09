part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserLoggedOut extends UserState {
  const UserLoggedOut();
}

class UserLoggedIn extends UserState {
  final User user;
  final String sessionId;

  const UserLoggedIn(this.user, this.sessionId);

  @override
  List<Object> get props => [user, sessionId];
}
