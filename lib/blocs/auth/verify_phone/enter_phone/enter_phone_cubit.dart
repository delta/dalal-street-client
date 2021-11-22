import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/AddPhone.pb.dart';
import 'package:equatable/equatable.dart';

part 'enter_phone_state.dart';

class EnterPhoneCubit extends Cubit<EnterPhoneState> {
  final UserBloc userBloc;

  EnterPhoneCubit(this.userBloc) : super(const EnterPhoneInitial());

  void logout() => userBloc.add(const UserLogOut());

  Future<void> sendOTP(String phone) async {
    emit(const EnterPhoneLoading());
    try {
      final resp = await actionClient.addPhone(
        AddPhoneRequest(phoneNumber: phone),
        options: sessionOptions(getIt()),
      );
      if (resp.statusCode == AddPhoneResponse_StatusCode.OK) {
        emit(EnterPhoneSuccess(phone));
      } else {
        emit(EnterPhoneFailure(resp.statusMessage));
        emit(const EnterPhoneInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const EnterPhoneFailure('Failed to reach server. Try again later'));
      emit(const EnterPhoneInitial());
    }
  }
}
