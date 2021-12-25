import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockList.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/GameState.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

/// Streams used in many places in the app
class GlobalStreams {
  // TODO: convert this into a stream, make this update in realtime using appropriate streams
  final Map<int, Stock> stockList;
  // TODO: add remaining global streams
  final ResponseStream<GameStateUpdate> gameStateStream;

  // Only used to unsubscribe from global streams. Don't use these to subscribe again
  final List<SubscriptionId> subscriptionIds;

  GlobalStreams(this.stockList, this.gameStateStream, this.subscriptionIds);
}

/// Subscribes to all Global Streams after login and returns the stream objects
/// Throws exception if any of them fails. Exception must be handled
Future<GlobalStreams> subscribeToGlobalStreams(String sessionId) async {
  final stockResponse = await actionClient.getStockList(
    GetStockListRequest(),
    options: sessionOptions(sessionId),
  );
  if (stockResponse.statusCode != GetStockListResponse_StatusCode.OK) {
    throw Exception(stockResponse.statusMessage);
  }
  final gameStateResp = await streamClient.subscribe(
    SubscribeRequest(dataStreamType: DataStreamType.GAME_STATE),
    options: sessionOptions(sessionId),
  );
  if (gameStateResp.statusCode != SubscribeResponse_StatusCode.OK) {
    throw Exception(gameStateResp.statusMessage);
  }
  final gameStateStream = streamClient.getGameStateUpdates(
    gameStateResp.subscriptionId,
    options: sessionOptions(sessionId),
  );
  return GlobalStreams(
    stockResponse.stockList,
    gameStateStream,
    [
      gameStateResp.subscriptionId,
    ],
  );
}

/// Unsubscribes from all Global Streams
Future<void> unsubscribeFromGlobalStreams(
  String sessionId,
  GlobalStreams globalStreams,
) async {
  logger.i('Unsubscribing from all global streams');
  try {
    for (final id in globalStreams.subscriptionIds) {
      streamClient.unsubscribe(
        UnsubscribeRequest(subscriptionId: id),
        options: sessionOptions(sessionId),
      );
    }
  } catch (e) {
    logger.e(e);
  }
}
