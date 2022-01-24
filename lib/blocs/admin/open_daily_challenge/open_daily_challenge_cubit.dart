import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/OpenDailyChallenge.pb.dart';
import 'package:equatable/equatable.dart';

part 'open_daily_challenge_state.dart';

class OpenDailyChallengeCubit extends Cubit<OpenDailyChallengeState> {
  OpenDailyChallengeCubit() : super(OpenDailyChallengeInitial());

  Future<void> openDailyChallenge() async {
    emit(const OpenDailyChallengeLoading());
    try {
      final resp = await actionClient.openDailyChallenge(
          OpenDailyChallengeRequest(),
          options: sessionOptions(getIt()));
      if (resp.statusCode == OpenDailyChallengeResponse_StatusCode.OK) {
        emit(OpenDailyChallengeSuccess(resp.statusMessage));
      } else {
        emit(OpenDailyChallengeFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const OpenDailyChallengeFailure(failedToReachServer));
    }
  }
}
