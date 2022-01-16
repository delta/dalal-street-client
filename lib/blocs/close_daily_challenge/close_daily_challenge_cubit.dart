import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/CloseDailyChallenge.pb.dart';
import 'package:equatable/equatable.dart';

part 'close_daily_challenge_state.dart';

class CloseDailyChallengeCubit extends Cubit<CloseDailyChallengeState> {
  CloseDailyChallengeCubit() : super(CloseDailyChallengeInitial());

  Future<void> closeDailyChallenges() async {
    emit(const CloseDailyChallengeLoading());
    try {
      final resp =
          await actionClient.closeDailyChallenge(CloseDailyChallengeRequest());
      if (resp.statusCode == CloseDailyChallengeResponse_StatusCode.OK) {
        emit(const CloseDailyChallengeSuccess());
      } else {
        emit(CloseDailyChallengeFailure(resp.statusMessage));
        emit(CloseDailyChallengeInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const CloseDailyChallengeFailure(failedToReachServer));
    }
  }
}
