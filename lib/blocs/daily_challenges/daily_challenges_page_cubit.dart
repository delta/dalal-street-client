import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetDailyChallengeConfig.pb.dart';
import 'package:equatable/equatable.dart';

part 'daily_challenges_page_state.dart';

class DailyChallengesPageCubit extends Cubit<DailyChallengesPageState> {
  DailyChallengesPageCubit() : super(DailyChallengesPageLoading());

  Future<void> getChallengesConfig() async {
    try {
      final resp = await actionClient.getDailyChallengeConfig(
        GetDailyChallengeConfigRequest(),
        options: sessionOptions(getIt()),
      );
      if (resp.statusCode == GetDailyChallengeConfigResponse_StatusCode.OK) {
        emit(DailyChallengesPageSuccess(
          resp.isDailyChallengOpen,
          resp.marketDay,
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
