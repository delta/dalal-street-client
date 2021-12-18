import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:equatable/equatable.dart';

part 'daily_challenges_state.dart';

class DailyChallengesCubit extends Cubit<DailyChallengesState> {
  DailyChallengesCubit() : super(DailyChallengesLoading());

  Future<void> getChalleges() async {
    try {
      final resp = await streamClient.subscribe(
        SubscribeRequest(dataStreamType: DataStreamType.GAME_STATE),
        options: sessionOptions(getIt()),
      );
      logger.d(resp.statusCode);
      final stream = streamClient.getGameStateUpdates(
        resp.subscriptionId,
        options: sessionOptions(getIt()),
      );
      await for (var item in stream) {
        logger.d('New game state: $item');
      }
    } catch (e) {
      logger.e(e);
      emit(const DailyChallengesFailure(failedToReachServer));
    }
  }
}
