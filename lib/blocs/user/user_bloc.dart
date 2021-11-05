import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserLoggedOut()) {
    on<UserLogIn>((event, emit) {
      print('email: ${event.email}, password: ${event.password}');
    });
    on<UserLogOut>((event, emit) {});
  }
}
