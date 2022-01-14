part of 'dalal_bloc.dart';

abstract class DalalEvent extends Equatable {
  const DalalEvent();

  @override
  List<Object> get props => [];
}

/// Should be called at splash screen if sessionId is present
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

class DalalCheckVerification extends DalalEvent {
  final User user;
  final String sessionId;

  const DalalCheckVerification(this.user, this.sessionId);

  @override
  List<Object> get props => [user, sessionId];
}

class DalalLogOut extends DalalEvent {
  const DalalLogOut();
}
