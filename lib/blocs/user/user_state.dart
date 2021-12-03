part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

/// User is logged out
///
/// Show Login Page
class UserLoggedOut extends UserState {
  final bool fromSplash;

  const UserLoggedOut({this.fromSplash = false});

  @override
  List<Object> get props => [fromSplash];
}

/// User is logged in but User data needs to fetched(already authenticated, just opened the app)
///
/// Show splash page and fetch user data, then go to home page
class UserLoggedIn extends UserState {
  final String sessionId;

  const UserLoggedIn(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}

/// User is logged in(user is currently using the app)
///
/// Show home page
class UserDataLoaded extends UserState {
  final User user;
  final String sessionId;

  const UserDataLoaded(this.user, this.sessionId);

  @override
  List<Object> get props => [sessionId, user];
}

class SubscriptionDataLoaded extends UserState {
  final SubscriptionId subscriptionId;
  const SubscriptionDataLoaded(this.subscriptionId);

  @override
  List<Object> get props => [subscriptionId];
}

class SubscriptonDataFailed extends UserState {
  final String message;
  const SubscriptonDataFailed(this.message);

  @override
  List<Object> get props => [message];
}
