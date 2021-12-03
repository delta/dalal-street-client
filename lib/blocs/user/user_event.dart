part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

/// Should be called at splash screen
class CheckUser extends UserEvent {
  const CheckUser();
}

class Subscribe extends UserEvent {
  final DataStreamType dataStreamType;
  const Subscribe(this.dataStreamType);

  @override
  List<Object> get props => [dataStreamType];
}

class GetUserData extends UserEvent {
  final String sessionId;

  const GetUserData(this.sessionId);

  @override
  List<Object> get props => [sessionId];
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
