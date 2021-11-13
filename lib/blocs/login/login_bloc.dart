import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/pages/auth/login_page.dart';
import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

/// Handles the state for [LoginPage]
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserBloc userBloc;

  LoginBloc(this.userBloc) : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(const LoginLoading());
      try {
        final resp = await actionClient
            .login(LoginRequest(email: event.email, password: event.password));
        if (resp.statusCode == LoginResponse_StatusCode.OK) {
          emit(LoginSuccess(resp));
          userBloc.add(UserLogIn(resp));
        } else {
          emit(LoginFailure(resp.statusMessage));
        }
      } catch (e) {
        logger.e(e);
        emit(const LoginFailure('Failed to reach server. Try again later'));
      }
    });
  }
}
