import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/blocs/streams/gamestate/gamestate_cubit.dart';
import 'package:dalal_street_client/blocs/streams/notification/notification_cubit.dart';
import 'package:dalal_street_client/blocs/streams/stockprice/stockprice_cubit.dart';
import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/pages/auth/login_page.dart';
import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

/// Handles the state for [LoginPage]
class LoginCubit extends Cubit<LoginState> {
  final UserBloc userBloc;
  final GamestateStreamCubit gamestateStreamCubit;
  final NotificationStreamCubit notificationStreamCubit;
  final StockpriceStreamCubit stockpriceStreamCubit;

  LoginCubit(this.userBloc, this.gamestateStreamCubit,
      this.notificationStreamCubit, this.stockpriceStreamCubit)
      : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(const LoginLoading());
    try {
      final resp = await actionClient
          .login(LoginRequest(email: email, password: password));
      if (resp.statusCode == LoginResponse_StatusCode.OK) {
        emit(LoginSuccess(resp));

        // starting global streams
        await gamestateStreamCubit.start();
        await notificationStreamCubit.start();
        await stockpriceStreamCubit.start();

        userBloc.add(UserLogIn(resp));
      } else {
        emit(LoginFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const LoginFailure(failedToReachServer));
    }
  }
}
