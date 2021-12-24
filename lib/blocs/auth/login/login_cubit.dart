import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/models/company_info.dart';
import 'package:dalal_street_client/pages/auth/login_page.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockList.pb.dart';
import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
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
      final sessionId = loginResp.sessionId;
      if (loginResp.statusCode != LoginResponse_StatusCode.OK) {
        emit(LoginFailure(loginResp.statusMessage));
        return;
      }
      final stockResponse = await actionClient.getStockList(
        GetStockListRequest(),
        options: sessionOptions(sessionId),
      );
      if (stockResponse.statusCode != GetStockListResponse_StatusCode.OK) {
        emit(LoginFailure(stockResponse.statusMessage));
        return;
      }
      final gameStateResp = await streamClient.subscribe(
        SubscribeRequest(dataStreamType: DataStreamType.GAME_STATE),
        options: sessionOptions(sessionId),
      );
      if (gameStateResp.statusCode != SubscribeResponse_StatusCode.OK) {
        emit(LoginFailure(gameStateResp.statusMessage));
        return;
      }
      final gameStateStream = streamClient.getGameStateUpdates(
        gameStateResp.subscriptionId,
        options: sessionOptions(sessionId),
      );
      emit(LoginSuccess(loginResp));
      userBloc.add(UserLogIn(
        loginResp,
        stockMapToCompanyMap(stockResponse.stockList),
        gameStateStream,
      ));
    } catch (e) {
      logger.e(e);
      emit(const LoginFailure(failedToReachServer));
    }
  }
}
