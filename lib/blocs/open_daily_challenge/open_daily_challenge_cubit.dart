import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/OpenDailyChallenge.pb.dart';
import 'package:equatable/equatable.dart';

part 'open_daily_challenge_state.dart';

class OpenDailyChallengeCubit extends Cubit<OpenDailyChallengeState> {
  OpenDailyChallengeCubit() : super(OpenDailyChallengeInitial());

  Future<void> openDailyChallenge(final userID, final penalty) async {
    emit(const OpenDailyChallengeLoading());
    try {
      final resp =
          await actionClient.openDailyChallenge(OpenDailyChallengeRequest());
      if (resp.statusCode == OpenDailyChallengeResponse_StatusCode.OK) {
        emit(const OpenDailyChallengeSuccess());
      } else {
        emit(OpenDailyChallengeFailure(resp.statusMessage));
        emit(OpenDailyChallengeInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const OpenDailyChallengeFailure(failedToReachServer));
    }
  }
}
