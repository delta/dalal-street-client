import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/UnblockUser.pb.dart';
import 'package:equatable/equatable.dart';

part 'unblock_user_state.dart';

class UnblockUserCubit extends Cubit<UnblockUserState> {
  UnblockUserCubit() : super(UnblockUserInitial());

  Future<void> unblockUser(final userID) async {
    emit(const UnblockUserLoading());
    try {
      final resp = await actionClient.unBlockUser(
          UnblockUserRequest(userId: userID),
          options: sessionOptions(getIt()));
      if (resp.statusCode == UnblockUserResponse_StatusCode.OK) {
        emit(UnblockUserSuccess(resp.statusMessage));
      } else {
        emit(UnblockUserFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const UnblockUserFailure(failedToReachServer));
    }
  }
}
