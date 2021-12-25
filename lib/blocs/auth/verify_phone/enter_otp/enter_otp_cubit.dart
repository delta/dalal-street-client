import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/blocs/dalal/dalal_bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/AddPhone.pb.dart';
import 'package:dalal_street_client/proto_build/actions/VerifyOTP.pb.dart';
import 'package:equatable/equatable.dart';

part 'enter_otp_state.dart';

class EnterOtpCubit extends Cubit<OtpState> {
  final DalalBloc dalalBloc;
  final String phone;

  EnterOtpCubit(this.dalalBloc, this.phone) : super(OtpInitial(phone));

  void logout() => dalalBloc.add(const DalalLogOut());

  Future<void> resendOTP() async {
    emit(const OtpLoading());
    try {
      final resp = await actionClient.addPhone(
        AddPhoneRequest(phoneNumber: phone),
        options: sessionOptions(getIt()),
      );
      if (resp.statusCode == AddPhoneResponse_StatusCode.OK) {
        emit(const OtpResent());
      } else {
        emit(OtpFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const OtpFailure(failedToReachServer));
    }
    emit(OtpInitial(phone));
  }

  Future<void> verifyOTP(int otp, String phone) async {
    final String sessionId = getIt();
    emit(const OtpLoading());
    try {
      final resp = await actionClient.verifyPhone(
        VerifyOTPRequest(otp: otp, phone: phone),
        options: sessionOptions(sessionId),
      );
      if (resp.statusCode == VerifyOTPResponse_StatusCode.OK) {
        emit(const OtpSuccess());
        // sessionId will be registered again in the root BlocListener
        getIt.unregister<String>();
        dalalBloc.add(GetUserData(sessionId));
      } else {
        emit(OtpFailure(resp.statusMessage));
        emit(OtpInitial(phone));
      }
    } catch (e) {
      logger.e(e);
      emit(const OtpFailure(failedToReachServer));
      emit(OtpInitial(phone));
    }
  }
}
