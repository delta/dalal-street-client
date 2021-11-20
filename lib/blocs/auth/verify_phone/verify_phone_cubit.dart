import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/AddPhone.pb.dart';
import 'package:dalal_street_client/proto_build/actions/VerifyOTP.pb.dart';
import 'package:equatable/equatable.dart';

part 'verify_phone_state.dart';

class VerifyPhoneCubit extends Cubit<VerifyPhoneState> {
  final UserBloc userBloc;

  VerifyPhoneCubit(this.userBloc) : super(const EnteringPhone());

  void logout() => userBloc.add(const UserLogOut());

  Future<void> sendOTP(String phone) async {
    emit(const VerifyPhoneLoading());
    try {
      final resp = await actionClient.addPhone(
        AddPhoneRequest(phoneNumber: phone),
        options: sessionOptions(getIt()),
      );
      if (resp.statusCode == AddPhoneResponse_StatusCode.OK) {
        emit(EnteringOTP(phone));
      } else {
        emit(VerifyPhoneFailure(resp.statusMessage));
        emit(const EnteringPhone());
      }
    } catch (e) {
      logger.e(e);
      emit(const VerifyPhoneFailure('Failed to reach server. Try again later'));
      emit(const EnteringPhone());
    }
  }

  Future<void> resendOTP() async {}

  Future<void> verifyOTP(int otp, String phone) async {
    final String sessionId = getIt();
    emit(const VerifyPhoneLoading());
    try {
      final resp = await actionClient.verifyPhone(
        VerifyOTPRequest(otp: otp, phone: phone),
        options: sessionOptions(sessionId),
      );
      if (resp.statusCode == VerifyOTPResponse_StatusCode.OK) {
        emit(const VerifyPhoneSuccess());
        // sessionId will be registered again in the root BlocListener
        getIt.unregister<String>();
        userBloc.add(GetUserData(sessionId));
      } else {
        emit(VerifyPhoneFailure(resp.statusMessage));
        emit(EnteringOTP(phone));
      }
    } catch (e) {
      logger.e(e);
      emit(const VerifyPhoneFailure('Failed to reach server. Try again later'));
      emit(EnteringOTP(phone));
    }
  }
}
