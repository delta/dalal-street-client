import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/pages/auth/login_page.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockList.pb.dart';
import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

/// Handles the state for [LoginPage]
class LoginCubit extends Cubit<LoginState> {
  final UserBloc userBloc;

  LoginCubit(this.userBloc) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(const LoginLoading());
    try {
      final loginResp = await actionClient
          .login(LoginRequest(email: email, password: password));
      if (loginResp.statusCode != LoginResponse_StatusCode.OK) {
        emit(LoginFailure(loginResp.statusMessage));
        return;
      }
      final stockResponse = await actionClient.getStockList(
        GetStockListRequest(),
        options: sessionOptions(loginResp.sessionId),
      );
      if (stockResponse.statusCode != GetStockListResponse_StatusCode.OK) {
        emit(LoginFailure(stockResponse.statusMessage));
        return;
      }
      emit(LoginSuccess(loginResp));
      userBloc.add(UserLogIn(loginResp, stockResponse.stockList));
    } catch (e) {
      logger.e(e);
      emit(const LoginFailure(failedToReachServer));
    }
  }
}
