import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:dalal_street_client/proto_build/actions/Logout.pb.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

/// Handles the Authentication State of User. Also persists the state using [HydratedBloc]
///
/// Must be provided at the root of the app widget tree
///
/// The [UserBloc] object can be accesed from anywhere in the widget tree easily using a [BuildContext] :
/// ```dart
/// final userBloc = context.read<UserBloc>();
/// userBloc.add(const UserLogOut());
/// ```
class UserBloc extends HydratedBloc<UserEvent, UserState> {
  // TODO: Use proper dependency injection to access sessionId
  late String sessionId;

  UserBloc() : super(const UserLoggedOut()) {
    on<CheckUser>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 800));
      if (state is UserLoggedIn) {
        add(GetUserData(sessionId));
      } else {
        // go to login page
        emit(const UserLoggedOut(showMsg: false));
      }
    });

    on<GetUserData>((event, emit) async {
      final loginResponse = await actionClient.login(LoginRequest(),
          options: sessionOptions(event.sessionId));
      emit(UserDataLoaded(loginResponse.user, loginResponse.sessionId));
    });

    on<UserLogIn>((event, emit) {
      sessionId = event.loginResponse.sessionId;
      emit(UserDataLoaded(
          event.loginResponse.user, event.loginResponse.sessionId));
    });

    on<UserLogOut>((event, emit) {
      try {
        actionClient.logout(LogoutRequest(),
            options: sessionOptions(sessionId));
      } catch (e) {
        // Cant do anything
        print(e);
      }
      emit(const UserLoggedOut());
    });
  }

  // Methods required by HydratedBloc to persist state
  @override
  UserState? fromJson(Map<String, dynamic> json) {
    try {
      sessionId = json['sessionId'];
      return UserLoggedIn(sessionId);
    } catch (_) {
      return const UserLoggedOut();
    }
  }

  @override
  Map<String, dynamic>? toJson(UserState state) {
    if (state is UserDataLoaded) {
      return {'sessionId': state.sessionId};
    } else if (state is UserLoggedIn) {
      return {'sessionId': state.sessionId};
    }
    return {};
  }
}
