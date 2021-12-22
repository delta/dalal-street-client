import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/GetDailyChallengeConfig.pb.dart';
import 'package:equatable/equatable.dart';

part 'daily_challenges_page_state.dart';

class DailyChallengesPageCubit extends Cubit<DailyChallengesPageState> {
  DailyChallengesPageCubit() : super(DailyChallengesPageLoading());

  Future<void> getConfig() async {
    try {
      final resp = await actionClient.getDailyChallengeConfig(
        GetDailyChallengeConfigRequest(),
        options: sessionOptions(getIt()),
      );
      if (resp.statusCode == GetDailyChallengeConfigResponse_StatusCode.OK) {
        emit(DailyChallengesPageSuccess(
          resp.marketDay,
          resp.isDailyChallengOpen,
          resp.totalMarketDays,
        ));
      } else {
        emit(DailyChallengesPageFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const DailyChallengesPageFailure(failedToReachServer));
    }
  }
}
