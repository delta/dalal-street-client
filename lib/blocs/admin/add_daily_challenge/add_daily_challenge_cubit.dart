import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/AddDailyChallenge.pb.dart';
import 'package:dalal_street_client/proto_build/actions/AddDailyChallenge.pbenum.dart';
import 'package:equatable/equatable.dart';

part 'add_daily_challenge_state.dart';

class AddDailyChallengeCubit extends Cubit<AddDailyChallengeState> {
  AddDailyChallengeCubit() : super(AddDailyChallengeInitial());

  Future<void> addDailyChallenge(final marketDay, final stockID, final reward,
      final value, final challengeType) async {
    emit(const AddDailyChallengeLoading());
    try {
      final resp = await actionClient.addDailyChallenge(
          AddDailyChallengeRequest(
              marketDay: marketDay,
              stockId: stockID,
              reward: reward,
              value: value,
              challengeType: challengeType),
          options: sessionOptions(getIt()));
      if (resp.statusCode == AddDailyChallengeResponse_StatusCode.OK) {
        emit(AddDailyChallengeSuccess(resp.statusMessage));
      } else {
        emit(AddDailyChallengeFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const AddDailyChallengeFailure(failedToReachServer));
    }
  }
}
