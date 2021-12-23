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

class GetUserData extends UserEvent {
  final String sessionId;

  const GetUserData(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}

class UserLogIn extends UserEvent {
  final LoginResponse loginResponse;
  final Map<int, Stock> stockList;

  const UserLogIn(this.loginResponse, this.stockList);

  @override
  List<Object> get props => [loginResponse];
}

class UserLogOut extends UserEvent {
  const UserLogOut();
}
