import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends HydratedBloc<UserEvent, UserState> {
  UserBloc() : super(const UserLoggedOut()) {
    on<UserLogIn>(
        (event, emit) => emit(UserLoggedIn(event.loginResponse.user)));
    on<UserLogOut>((event, emit) => emit(const UserLoggedOut()));
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) {
    try {
      final user = User.fromJson(json['user']);
      return UserLoggedIn(user);
    } catch (_) {
      return const UserLoggedOut();
    }
  }

  @override
  Map<String, dynamic>? toJson(UserState state) {
    if (state is UserLoggedIn) {
      return {
        'user': state.user.writeToJson(),
      };
    }
    return {};
  }
}
