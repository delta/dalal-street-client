import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/GetDailyChallenges.pb.dart';
import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
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
        emit(SingleDayChallengesLoaded(resp.dailyChallenges));
      } else {
        emit(SingleDayChallengesFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const SingleDayChallengesFailure(failedToReachServer));
    }
  }
}
