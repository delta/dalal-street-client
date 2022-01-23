import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/InspectUser.pb.dart';
import 'package:equatable/equatable.dart';

part 'inspect_user_state.dart';

class InspectUserCubit extends Cubit<InspectUserState> {
  InspectUserCubit() : super(InspectUserInitial());

  Future<void> inspectUser(
      final userID, final transactionType, final day) async {
    emit(const InspectUserLoading());
    try {
      final resp = await actionClient.inspectUser(
          InspectUserRequest(
              userId: userID, transactionType: transactionType, day: day),
          options: sessionOptions(getIt()));
      if (resp.statusCode == InspectUserResponse_StatusCode.OK) {
        emit(InspectUserSuccess(resp.statusMessage));
      } else {
        emit(InspectUserFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const InspectUserFailure(failedToReachServer));
    }
  }
}
