import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockList.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/GameState.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

/// All the stuff needed to be fetched after login
///
/// Note:
/// This class is useless
/// Only needed becuase dart doesn't support multiple return types yet
/// Remove this class if this issue is merged someday: https://github.com/dart-lang/language/issues/68
class PostLoginData {
  final Map<int, Stock> stockList;
  // TODO: add remaining global streams
  final ResponseStream<GameStateUpdate> gameStateStream;

  PostLoginData(this.stockList, this.gameStateStream);
}

/// Fetches all the post login data
/// Throws exception if any of them fails. Exception must be handled
Future<PostLoginData> getPostLoginData(String sessionId) async {
  // TODO: show proper messages in all exceptions
  final stockResponse = await actionClient.getStockList(
    GetStockListRequest(),
    options: sessionOptions(sessionId),
  );
  if (stockResponse.statusCode != GetStockListResponse_StatusCode.OK) {
    throw Exception();
  }
  final gameStateResp = await streamClient.subscribe(
    SubscribeRequest(dataStreamType: DataStreamType.GAME_STATE),
    options: sessionOptions(sessionId),
  );
  if (gameStateResp.statusCode != SubscribeResponse_StatusCode.OK) {
    throw Exception();
  }
  final gameStateStream = streamClient.getGameStateUpdates(
    gameStateResp.subscriptionId,
    options: sessionOptions(sessionId),
  );
  return PostLoginData(
    stockResponse.stockList,
    gameStateStream,
  );
}
