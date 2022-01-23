import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/UnblockAllUsers.pb.dart';
import 'package:equatable/equatable.dart';

part 'unblock_all_users_state.dart';

class UnblockAllUsersCubit extends Cubit<UnblockAllUsersState> {
  UnblockAllUsersCubit() : super(UnblockAllUsersInitial());

  Future<void> unblockAllUsers() async {
    emit(const UnblockAllUsersLoading());
    try {
      final resp = await actionClient.unBlockAllUsers(UnblockAllUsersRequest(),
          options: sessionOptions(getIt()));
      if (resp.statusCode == UnblockAllUsersResponse_StatusCode.OK) {
        emit(UnblockAllUsersSuccess(resp.statusMessage));
      } else {
        emit(UnblockAllUsersFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const UnblockAllUsersFailure(failedToReachServer));
    }
  }
}
