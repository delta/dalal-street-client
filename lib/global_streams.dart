import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockList.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/GameState.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Notifications.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/StockPrices.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Transactions.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

import 'config/log.dart';
import 'grpc/subscription.dart';

/// Streams used in many places in the app
class GlobalStreams extends Equatable {
  // TODO: convert this into a stream, make this update in realtime using appropriate streams
  final Map<int, Stock> stockList;

  final ResponseStream<GameStateUpdate> gameStateStream;
  final ResponseStream<NotificationUpdate> notificationStream;
  final ResponseStream<TransactionUpdate> transactionStream;
  final ResponseStream<StockPricesUpdate> stockPricesStream;

  // Only used to unsubscribe from global streams. Don't use these to subscribe again
  final List<SubscriptionId> subscriptionIds;

  const GlobalStreams(
    this.stockList,
    this.gameStateStream,
    this.notificationStream,
    this.transactionStream,
    this.stockPricesStream,
    this.subscriptionIds,
  );

  @override
  List<Object?> get props => [
        stockList,
        gameStateStream,
        notificationStream,
        transactionStream,
        stockPricesStream,
        subscriptionIds
      ];
}

/// Subscribes to all Global Streams after login and returns the stream objects
/// Throws exception if any of them fails. Exception must be handled
Future<GlobalStreams> subscribeToGlobalStreams(String sessionId) async {
  try {
    // getStockList request, return map of stockId -> Stock
    final stockResponse = await actionClient.getStockList(
      GetStockListRequest(),
      options: sessionOptions(sessionId),
    );

    if (stockResponse.statusCode != GetStockListResponse_StatusCode.OK) {
      throw Exception(stockResponse.statusMessage);
    }

    // subscription api to subscribe to stream
    final subscription = Subscription();

    // subscribing to global streams
    late final SubscriptionId stockPriceSubscriptionId;
    late final SubscriptionId notificationSubscriptionId;
    late final SubscriptionId transactionSubscriptionId;
    late final SubscriptionId gameStateSubscriptionId;

    late final ResponseStream<StockPricesUpdate> stockPriceStream;
    late final ResponseStream<NotificationUpdate> notificationStream;
    late final ResponseStream<TransactionUpdate> transactionStream;
    late final ResponseStream<GameStateUpdate> gameStateStream;

    stockPriceSubscriptionId = await subscription.subscribe(
        SubscribeRequest(dataStreamType: DataStreamType.STOCK_PRICES));

    notificationSubscriptionId = await subscription.subscribe(
        SubscribeRequest(dataStreamType: DataStreamType.NOTIFICATIONS));

    transactionSubscriptionId = await subscription.subscribe(
        SubscribeRequest(dataStreamType: DataStreamType.TRANSACTIONS));

    gameStateSubscriptionId = await subscription
        .subscribe(SubscribeRequest(dataStreamType: DataStreamType.GAME_STATE));

    stockPriceStream =
        streamClient.getStockPricesUpdates(stockPriceSubscriptionId);
    notificationStream =
        streamClient.getNotificationUpdates(notificationSubscriptionId);
    transactionStream =
        streamClient.getTransactionUpdates(transactionSubscriptionId);
    gameStateStream = streamClient.getGameStateUpdates(gameStateSubscriptionId);

    final subscriptionIds = [
      stockPriceSubscriptionId,
      notificationSubscriptionId,
      transactionSubscriptionId,
      gameStateSubscriptionId
    ];

    return GlobalStreams(
        stockResponse.stockList,
        gameStateStream,
        notificationStream,
        transactionStream,
        stockPriceStream,
        subscriptionIds);
  } catch (e) {
    logger.e(e.toString());
    throw Exception(e.toString());
  }
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
