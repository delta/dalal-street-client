import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/ForgotPassword.pb.dart';
import 'package:equatable/equatable.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  Future<void> forgotPassword(String email) async {
    emit(const ForgotPasswordLoading());
    try {
      final resp = await actionClient
          .forgotPassword(ForgotPasswordRequest(email: email));
      if (resp.statusCode == ForgotPasswordResponse_StatusCode.OK) {
        emit(const ForgotPasswordSuccess());
      } else {
        emit(ForgotPasswordFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const ForgotPasswordFailure(failedToReachServer));
    }
  }
}
