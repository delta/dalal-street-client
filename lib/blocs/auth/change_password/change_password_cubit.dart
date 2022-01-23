import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:equatable/equatable.dart';
import 'package:dalal_street_client/proto_build/actions/ChangePassword.pb.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  Future<void> changePassword(
      String tempPassword, String newPassword, String confirmPassword) async {
    emit(const ChangePasswordLoading());
    try {
      final resp = await actionClient.changePassword(ChangePasswordRequest(
          tempPassword: tempPassword,
          newPassword: newPassword,
          confirmPassword: confirmPassword));
      if (resp.statusCode == ChangePasswordResponse_StatusCode.OK) {
        emit(ChangePasswordSuccess(resp.statusMessage));
      } else {
        emit(ChangePasswordFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const ChangePasswordFailure(failedToReachServer));
    }
  }
}
