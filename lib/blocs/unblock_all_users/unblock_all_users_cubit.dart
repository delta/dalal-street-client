import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/UnblockAllUsers.pb.dart';
import 'package:equatable/equatable.dart';

part 'unblock_all_users_state.dart';

class UnblockAllUsersCubit extends Cubit<UnblockAllUsersState> {
  UnblockAllUsersCubit() : super(UnblockAllUsersInitial());

  Future<void> unblockAllUsers(final userID, final penalty) async {
    emit(const UnblockAllUsersLoading());
    try {
      final resp = await actionClient.unBlockAllUsers(UnblockAllUsersRequest());
      if (resp.statusCode == UnblockAllUsersResponse_StatusCode.OK) {
        emit(const UnblockAllUsersSuccess());
      } else {
        emit(UnblockAllUsersFailure(resp.statusMessage));
        emit(UnblockAllUsersInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const UnblockAllUsersFailure(failedToReachServer));
    }
  }
}
