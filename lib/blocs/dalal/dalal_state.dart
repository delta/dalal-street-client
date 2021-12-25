part of 'dalal_bloc.dart';

abstract class DalalState extends Equatable {
  const DalalState();

  @override
  List<Object> get props => [];
}

/// User is logged out
///
/// Show Login Page
class DalalLoggedOut extends DalalState {
  final bool fromSplash;

  const DalalLoggedOut({this.fromSplash = false});

  @override
  List<Object> get props => [fromSplash];
}

/// User is logged in but User data needs to fetched(already authenticated, just opened the app)
///
/// Show splash page and fetch user data, then go to home page
class DalalLoggedIn extends DalalState {
  final String sessionId;

  const DalalLoggedIn(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}

/// User is logged in(user is currently using the app)
///
/// Show home page
class DalalDataLoaded extends DalalState {
  final User user;
  // Extra Data
  final String sessionId;
  final Map<int, Stock> companies;
  final GlobalStreams globalStreams;

  const DalalDataLoaded(
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
class DalalLoginFailed extends DalalState {
  final String sessionId;

  const DalalLoginFailed(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}
