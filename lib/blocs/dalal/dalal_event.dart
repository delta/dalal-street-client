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

class DalalLogIn extends DalalEvent {
  final LoginResponse loginResponse;
  final Map<int, CompanyInfo> companies;
  final GlobalStreams globalStreams;

  const DalalLogIn(this.loginResponse, this.companies, this.globalStreams);

  @override
  List<Object> get props => [loginResponse, companies, globalStreams];
}

class DalalLogOut extends DalalEvent {
  const DalalLogOut();
}
