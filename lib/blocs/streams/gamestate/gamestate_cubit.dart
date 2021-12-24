import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/grpc/subscription.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/GameState.pb.dart';
import 'package:equatable/equatable.dart';

import '../../../main.dart';

part 'gamestate_state.dart';

class GamestateStreamCubit extends Cubit<GamestateStreamState> {
  late final Subscription subscription;

  GamestateStreamCubit() : super(GamestateStreamLoading()) {
    subscription = Subscription();
  }

  // subscribe to gamestate stream and listen for updates
  Future<void> start() async {
    try {
      final subscriptionId = await subscription.subscribe(
          SubscribeRequest(dataStreamType: DataStreamType.GAME_STATE));

      final gamestateStream = streamClient.getGameStateUpdates(subscriptionId,
          options: sessionOptions(getIt<String>()));

      // emitting success state after subscription
      emit(GamestateStreamSuccess());

      await for (final gamestate in gamestateStream) {
        // emitting on each gamestate updates
        emit(GamestateStreamUpdate(
            gamestate.gameState, gamestate.gameState.type));
      }
    } catch (e) {
      logger.e(e);
      emit(GamestateStreamError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    // unsubscribing to notification stream
    subscription.unSubscribe();
    return super.close();
  }
}
