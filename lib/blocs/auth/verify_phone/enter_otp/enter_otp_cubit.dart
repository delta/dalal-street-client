import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/VerifyOTP.pb.dart';
import 'package:equatable/equatable.dart';

part 'enter_otp_state.dart';

class EnterOtpCubit extends Cubit<EnterOtpState> {
  final UserBloc userBloc;
  final String phone;

  EnterOtpCubit(this.userBloc, this.phone) : super(EnterOtpInitial(phone));

  void logout() => userBloc.add(const UserLogOut());

  Future<void> resendOTP() async {}

  Future<void> verifyOTP(int otp, String phone) async {
    final String sessionId = getIt();
    emit(const EnterOtpLoading());
    try {
      final resp = await actionClient.verifyPhone(
        VerifyOTPRequest(otp: otp, phone: phone),
        options: sessionOptions(sessionId),
      );
      if (resp.statusCode == VerifyOTPResponse_StatusCode.OK) {
        emit(const EnterOtpSuccess());
        // sessionId will be registered again in the root BlocListener
        getIt.unregister<String>();
        userBloc.add(GetUserData(sessionId));
      } else {
        emit(EnterOtpFailure(resp.statusMessage));
        emit(EnterOtpInitial(phone));
      }
    } catch (e) {
      logger.e(e);
      emit(const EnterOtpFailure('Failed to reach server. Try again later'));
      emit(EnterOtpInitial(phone));
    }
  }
}
