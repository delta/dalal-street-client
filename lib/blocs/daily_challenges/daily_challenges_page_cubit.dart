import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/grpc/client.dart';
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

  /// Only call this after [getChallengesConfig] is succesful
  Future<void> listenToGameStateStream() async {
    final gameStateStream = getIt<GlobalStreams>().gameStateStream;
    await for (var update in gameStateStream) {
      final gameState = update.gameState;
      if (gameState.type == GameStateUpdateType.DailyChallengeStatusUpdate) {
        try {
          // TODO: handle separately from DailyChallengesPageSuccess state
          // final success = state as DailyChallengesPageSuccess;
        } catch (e) {
          logger.e(e);
        }
      }
    }
  }
}
