import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetMyReward.pb.dart';
import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:dalal_street_client/proto_build/models/UserState.pb.dart';
import 'package:equatable/equatable.dart';

part 'challenge_reward_state.dart';

class ChallengeRewardCubit extends Cubit<ChallengeRewardState> {
  final DailyChallenge challenge;
  final UserState userState;

  ChallengeRewardCubit(this.challenge, this.userState)
      : super(() {
          if (!userState.isCompleted) {
            return const ChallengeIncomplete();
          } else if (userState.isCompleted && !userState.isRewardClamied) {
            return const ChallengeComplete();
          } else {
            return ChallengeRewardCalimed(challenge.reward);
          }
        }());

  Future<void> claimReward() async {
    final initialState = state;
    emit(const ChallengeRewardLoading());
    try {
      final resp = await actionClient.getMyReward(
        GetMyRewardRequest(userStateId: userState.id),
        options: sessionOptions(getIt()),
      );
      if (resp.statusCode == GetMyRewardResponse_StatusCode.OK) {
        emit(ChallengeRewardCalimed(resp.reward.toInt()));
      } else {
        emit(ChallengeRewardFailure(resp.statusMessage));
        emit(initialState);
      }
    } catch (e) {
      logger.e(e);
      emit(const ChallengeRewardFailure(failedToReachServer));
      emit(initialState);
    }
  }
}
