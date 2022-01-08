import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/AddDailyChallenge.pb.dart';
import 'package:dalal_street_client/proto_build/actions/AddDailyChallenge.pbenum.dart';
import 'package:equatable/equatable.dart';

part 'add_daily_challenge_state.dart';

class AddDailyChallengeCubit extends Cubit<AddDailyChallengeState> {
  AddDailyChallengeCubit() : super(AddDailyChallengeInitial());

  Future<void> addDailyChallenge(final market_day, final stockID, final reward,
      final value, ChallengeType) async {
    emit(const AddDailyChallengeLoading());
    try {
      final resp = await actionClient.addDailyChallenge(
          AddDailyChallengeRequest(
              marketDay: market_day,
              stockId: stockID,
              reward: reward,
              value: value,
              challengeType: ChallengeType));
      if (resp.statusCode == AddDailyChallengeResponse_StatusCode.OK) {
        emit(AddDailyChallengeSuccess(
            market_day, value, reward, stockID, ChallengeType));
      } else {
        emit(AddDailyChallengeFailure(resp.statusMessage));
        emit(AddDailyChallengeInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const AddDailyChallengeFailure(failedToReachServer));
    }
  }
}
