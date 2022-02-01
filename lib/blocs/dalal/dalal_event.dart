part of 'dalal_bloc.dart';

abstract class DalalEvent extends Equatable {
  const DalalEvent();

  @override
  List<Object> get props => [];
}

/// Check if a sessionId is stored in local and redirect accordingly
class CheckUser extends DalalEvent {
  const CheckUser();
}

/// Get the user data using the saved sessionId
class GetUserData extends DalalEvent {
  final String sessionId;

  const GetUserData(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}

/// User has logged in by entering creds. Check verification and redirect accordingly
class DalalCheckVerification extends DalalEvent {
  final LoginResponse loginResponse;

  const DalalCheckVerification(this.loginResponse);

  @override
  List<Object> get props => [loginResponse];
}

/// Logout the user
class DalalLogOut extends DalalEvent {
  const DalalLogOut();
}
