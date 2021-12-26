import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/global_streams.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/GetDailyChallengeConfig.pb.dart';
import 'package:dalal_street_client/proto_build/models/GameState.pbenum.dart';
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
    final gameStateStream = getIt<GlobalStreams>().gameStateStream;
    await for (var update in gameStateStream) {
      final gameState = update.gameState;
      if (gameState.type == GameStateUpdateType.DailyChallengeStatusUpdate) {
        try {
          final success = state as DailyChallengesPageSuccess;
          emit(DailyChallengesPageSuccess(
            success.marketDay,
            gameState.dailyChallengeState.isDailyChallengeOpen,
            success.totalMarketDays,
          ));
        } catch (e) {
          logger.e(e);
        }
      }
    }
  }
}
