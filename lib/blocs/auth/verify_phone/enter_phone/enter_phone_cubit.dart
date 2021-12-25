import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/blocs/dalal/dalal_bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/AddPhone.pb.dart';
import 'package:equatable/equatable.dart';

part 'enter_phone_state.dart';

class EnterPhoneCubit extends Cubit<EnterPhoneState> {
  final DalalBloc dalalBloc;

  EnterPhoneCubit(this.dalalBloc) : super(const EnterPhoneInitial());

  void logout() => dalalBloc.add(const DalalLogOut());

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
      emit(const EnterPhoneFailure(failedToReachServer));
      emit(const EnterPhoneInitial());
    }
  }
}
