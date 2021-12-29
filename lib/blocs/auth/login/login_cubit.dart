import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/blocs/dalal/dalal_bloc.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/models/company_info.dart';
import 'package:dalal_street_client/pages/auth/login_page.dart';
import 'package:dalal_street_client/global_streams.dart';
import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

/// Handles the state for [LoginPage]
class LoginCubit extends Cubit<LoginState> {
  final DalalBloc dalalBloc;

  LoginCubit(this.dalalBloc) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(const LoginLoading());
    try {
      final loginResp = await actionClient
          .login(LoginRequest(email: email, password: password));
      final sessionId = loginResp.sessionId;
      if (loginResp.statusCode != LoginResponse_StatusCode.OK) {
        emit(LoginFailure(loginResp.statusMessage));
        return;
      }
      final globalStreams = await subscribeToGlobalStreams(
        loginResp.user,
        sessionId,
      );
      emit(LoginSuccess(loginResp));
      dalalBloc.add(DalalLogIn(
        loginResp,
        stockMapToCompanyMap(globalStreams.stockList),
        globalStreams,
      ));
    } catch (e) {
      // Inavlid session id error not possible because this is first time login
      // No need to check for grpc error code 16
      logger.e(e);
      emit(const LoginFailure(failedToReachServer));
    }
  }
}
