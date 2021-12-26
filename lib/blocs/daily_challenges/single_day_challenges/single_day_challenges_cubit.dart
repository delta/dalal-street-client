import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/models/daily_challenge_info.dart';
import 'package:dalal_street_client/proto_build/actions/GetDailyChallenges.pb.dart';
import 'package:dalal_street_client/proto_build/actions/GetMyUserState.pb.dart';
import 'package:dalal_street_client/proto_build/models/UserState.pb.dart';
import 'package:equatable/equatable.dart';

part 'single_day_challenges_state.dart';

class SingleDayChallengesCubit extends Cubit<SingleDayChallengesState> {
  SingleDayChallengesCubit() : super(SingleDayChallengesLoading());

  Future<void> getChallenges(int marketDay) async {
    try {
      final resp = await actionClient.getDailyChallenges(
        GetDailyChallengesRequest(marketDay: marketDay),
        options: sessionOptions(getIt()),
      );
      if (resp.statusCode == GetDailyChallengesResponse_StatusCode.OK) {
        final List<UserState> userStates = [];
        for (var challenge in resp.dailyChallenges) {
          final stateResp = await actionClient.getMyUserState(
            GetMyUserStateRequest(challengeId: challenge.challengeId),
            options: sessionOptions(getIt()),
          );
          if (stateResp.statusCode == GetMyUserStateResponse_StatusCode.OK) {
            userStates.add(stateResp.userState);
          } else {
            logger.e(stateResp.statusMessage);
            emit(SingleDayChallengesFailure(stateResp.statusMessage));
            return;
          }
        }
        final infos = [
          for (var i = 0; i < userStates.length; i++)
            DailyChallengeInfo(resp.dailyChallenges[i], userStates[i])
        ];
        emit(SingleDayChallengesLoaded(infos));
      } else {
        logger.e(resp.statusMessage);
        emit(SingleDayChallengesFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const SingleDayChallengesFailure(failedToReachServer));
    }
  }
}
