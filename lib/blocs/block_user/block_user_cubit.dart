import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/BlockUser.pb.dart';
import 'package:equatable/equatable.dart';

part 'block_user_state.dart';

class BlockUserCubit extends Cubit<BlockUserState> {
  BlockUserCubit() : super(BlockUserInitial());

  Future<void> blockUser(final userID, final penalty) async {
    emit(const BlockUserLoading());
    try {
      final resp = await actionClient
          .blockUser(BlockUserRequest(userId: userID, penalty: penalty));
      if (resp.statusCode == BlockUserResponse_StatusCode.OK) {
        emit(BlockUserSuccess(userID, penalty));
      } else {
        emit(BlockUserFailure(resp.statusMessage));
        emit(BlockUserInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const BlockUserFailure(failedToReachServer));
    }
  }
}
