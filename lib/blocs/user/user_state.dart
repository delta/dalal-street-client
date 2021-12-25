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
  // Extra Data
  final String sessionId;
  final Map<int, CompanyInfo> companies;
  final GlobalStreams globalStreams;

  const UserDataLoaded(
    this.user,
    this.sessionId,
    this.companies,
    this.globalStreams,
  );

  @override
  List<Object> get props => [user, sessionId, companies, globalStreams];
}

/// When failure happens in getting user data
///
/// Stays in splash page. Shows snackbar with retry button
class UserLoginFailed extends UserState {
  final String sessionId;

  const UserLoginFailed(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}
