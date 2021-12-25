import 'package:dalal_street_client/grpc/client.dart';
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

  GlobalStreams(this.stockList, this.gameStateStream);
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
  );
}
