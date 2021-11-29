import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/Register.pb.dart';
import 'package:equatable/equatable.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> register(
    String email,
    String password,
    String name, {
    String? referralCode,
  }) async {
    emit(const RegisterLoading());
    try {
      final resp = await actionClient.register(RegisterRequest(
        email: email,
        password: password,
        fullName: name,
        referralCode: referralCode,
      ));
      if (resp.statusCode == RegisterResponse_StatusCode.OK) {
        emit(RegisterSuccess(email));
      } else {
        emit(RegisterFailure(resp.statusMessage));
        emit(RegisterInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const RegisterFailure(failedToReachServer));
    }
  }
}
