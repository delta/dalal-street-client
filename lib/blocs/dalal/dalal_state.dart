part of 'dalal_bloc.dart';

abstract class DalalState extends Equatable {
  const DalalState();

  @override
  List<Object> get props => [];
}

/// User is logged out
class DalalLoggedOut extends DalalState {
  /// Wether logged out by user action, or automatically because of some session
  /// issue
  final bool manualLogout;

  const DalalLoggedOut({this.manualLogout = true});

  @override
  List<Object> get props => [manualLogout];
}

/// User is logged in but User data needs to fetched(already authenticated, just opened the app)
class DalalLoggedIn extends DalalState {
  final String sessionId;

  const DalalLoggedIn(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}

/// Fetching user data with sessionId
class DalalDataLoading extends DalalState {
  final String sessionId;

  const DalalDataLoading(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}

/// User is logged in but verifiction is not done
class DalalVerificationPending extends DalalState {
  final String sessionId;

  const DalalVerificationPending(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}

/// User is logged in and verified
class DalalDataLoaded extends DalalState {
  final User user;
  final String sessionId;
  final GlobalStreams globalStreams;

  const DalalDataLoaded(
    this.user,
    this.sessionId,
    this.globalStreams,
  );

  @override
  List<Object> get props => [user, sessionId, globalStreams];
}

/// Failure happened when getting user data
class DalalLoginFailed extends DalalState {
  final String sessionId;

  const DalalLoginFailed(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}
