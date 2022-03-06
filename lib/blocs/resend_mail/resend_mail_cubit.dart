import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/ResendVerificationEmail.pb.dart';
import 'package:equatable/equatable.dart';

part 'resend_mail_state.dart';

class ResendMailCubit extends Cubit<ResendMailState> {
  ResendMailCubit() : super(ResendMailInitial());

  void resendVerificationLink(String email) async {
    emit(ResendMailLoading());

    try {
      var response = await actionClient.resendVerificationEmail(
          ResendVerificationEmailRequest(email: email));

      if (response.statusCode ==
          ResendVerificationEmailResponse_StatusCode.OK) {
        emit(const ResendMailSuccess('Mail successfully sent'));
      } else {
        emit(ResendMailFailure(response.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const ResendMailFailure(failedToReachServer));
    }
  }
}
