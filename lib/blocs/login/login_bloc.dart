import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(const LoginLoading());
      await Future.delayed(const Duration(seconds: 1));
      emit(const LoginFailure("User Doesn't exist"));
    });
  }
}
