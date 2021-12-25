import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/GetDailyChallengeConfig.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/GameState.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

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
          resp.marketDay,
          resp.isDailyChallengOpen,
          resp.totalMarketDays,
        ));
        listenToGameStateStream();
      } else {
        emit(DailyChallengesPageFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const DailyChallengesPageFailure(failedToReachServer));
    }
  }

  /// Updates `isDailyChallengeOpen` in [DailyChallengesPageSuccess]
  /// Only call this after [getChallengesConfig] is succesful
  Future<void> listenToGameStateStream() async {
    final ResponseStream<GameStateUpdate> gameStateStream = getIt();
    // TODO: only update state if `isDailyChallengeOpen` is changed
    await for (var update in gameStateStream) {
      try {
        final success = state as DailyChallengesPageSuccess;
        emit(DailyChallengesPageSuccess(
          success.marketDay,
          update.gameState.dailyChallengeState.isDailyChallengeOpen,
          success.totalMarketDays,
        ));
      } catch (e) {
        logger.e(e);
      }
    }
  }
}
