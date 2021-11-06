import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserBloc userBloc;

  LoginBloc(this.userBloc) : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(const LoginLoading());
      final resp = await actionClient
          .login(LoginRequest(email: event.email, password: event.password));
      if (resp.statusCode == LoginResponse_StatusCode.OK) {
        emit(LoginSuccess(resp));
        await Future.delayed(const Duration(milliseconds: 500));
        userBloc.add(UserLogIn(resp));
      } else {
        emit(LoginFailure(resp.statusMessage));
      }
    });
  }
}
