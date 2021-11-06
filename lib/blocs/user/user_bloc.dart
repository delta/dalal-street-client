import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserLoggedOut()) {
    on<UserLogIn>(
        (event, emit) => emit(UserLoggedIn(event.loginResponse.user)));
    on<UserLogOut>((event, emit) => emit(const UserLoggedOut()));
  }
}
