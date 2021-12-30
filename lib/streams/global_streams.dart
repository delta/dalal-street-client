import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/models/dynamic_user_info.dart';
import 'package:dalal_street_client/proto_build/actions/GetPortfolio.pb.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockList.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/GameState.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Notifications.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/StockExchange.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/StockPrices.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Transactions.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:equatable/equatable.dart';

import '../config/log.dart';
import '../grpc/subscription.dart';

part 'custom_streams.dart';

/// Streams used in many places in the app
class GlobalStreams extends Equatable {
  // TODO: convert this into a stream, make this update in realtime using appropriate streams
  final Map<int, Stock> stockList;

  // Global streams from the server
  // All the global streams must be broadcast streams
  final Stream<GameStateUpdate> gameStateStream;
  final Stream<StockPricesUpdate> stockPricesStream;
  final Stream<StockExchangeUpdate> stockExchangeStream;
  final Stream<TransactionUpdate> transactionStream;
  final Stream<NotificationUpdate> notificationStream;

  // Custom streams generated from server streams
  final Stream<DynamicUserInfo> dynamicUserInfoStream;

  // Only used to unsubscribe from global streams. Don't use these to subscribe again
  final List<SubscriptionId> subscriptionIds;

  const GlobalStreams(
    this.stockList,
    this.gameStateStream,
    this.stockPricesStream,
    this.stockExchangeStream,
    this.transactionStream,
    this.notificationStream,
    this.dynamicUserInfoStream,
    this.subscriptionIds,
  );

  @override
  List<Object?> get props => [
        stockList,
        gameStateStream,
        stockPricesStream,
        stockExchangeStream,
        transactionStream,
        notificationStream,
        dynamicUserInfoStream,
        subscriptionIds,
      ];
}

/// Subscribes to all Global Streams and Initializes Custom Streams after login and returns the stream objects
/// Throws exception if any of them fails. Exception must be handled
Future<GlobalStreams> subscribeToGlobalStreams(
  User user,
  String sessionId,
) async {
  // getStockList request, return map of stockId -> Stock
  final stockResponse = await actionClient.getStockList(
    GetStockListRequest(),
    options: sessionOptions(sessionId),
  );
  if (stockResponse.statusCode != GetStockListResponse_StatusCode.OK) {
    throw Exception(stockResponse.statusMessage);
  }

  // Subscribe to the streams
  final gameStateSubscriptionId = await subscribe(
    SubscribeRequest(dataStreamType: DataStreamType.GAME_STATE),
    sessionId,
  );
  final stockPriceSubscriptionId = await subscribe(
    SubscribeRequest(dataStreamType: DataStreamType.STOCK_PRICES),
    sessionId,
  );
  final stockExchangeSubscriptionId = await subscribe(
    SubscribeRequest(dataStreamType: DataStreamType.STOCK_EXCHANGE),
    sessionId,
  );
  final transactionSubscriptionId = await subscribe(
    SubscribeRequest(dataStreamType: DataStreamType.TRANSACTIONS),
    sessionId,
  );
  final notificationSubscriptionId = await subscribe(
    SubscribeRequest(dataStreamType: DataStreamType.NOTIFICATIONS),
    sessionId,
  );
  final subscriptionIds = [
    gameStateSubscriptionId,
    stockPriceSubscriptionId,
    stockExchangeSubscriptionId,
    transactionSubscriptionId,
    notificationSubscriptionId,
  ];

  // Get the streams from the subscription ids
  final gameStateStream = streamClient
      .getGameStateUpdates(
        gameStateSubscriptionId,
        options: sessionOptions(sessionId),
      )
      .asBroadcastStream();
  final stockPriceStream = streamClient
      .getStockPricesUpdates(
        stockPriceSubscriptionId,
        options: sessionOptions(sessionId),
      )
      .asBroadcastStream();
  final stockExchangeStream = streamClient
      .getStockExchangeUpdates(
        stockExchangeSubscriptionId,
        options: sessionOptions(sessionId),
      )
      .asBroadcastStream();
  final transactionStream = streamClient
      .getTransactionUpdates(
        transactionSubscriptionId,
        options: sessionOptions(sessionId),
      )
      .asBroadcastStream();
  final notificationStream = streamClient
      .getNotificationUpdates(
        notificationSubscriptionId,
        options: sessionOptions(sessionId),
      )
      .asBroadcastStream();

  // Generate custom streams
  final portfolioResponse = await actionClient.getPortfolio(
    GetPortfolioRequest(),
    options: sessionOptions(sessionId),
  );
  if (portfolioResponse.statusCode != GetPortfolioResponse_StatusCode.OK) {
    throw Exception(portfolioResponse.statusMessage);
  }
  final dynamicUserInfoStream = _generateDynamicUserInfoStream(
    user,
    portfolioResponse,
    transactionStream,
  ).asBroadcastStream();

  return GlobalStreams(
    stockResponse.stockList,
    gameStateStream,
    stockPriceStream,
    stockExchangeStream,
    transactionStream,
    notificationStream,
    dynamicUserInfoStream,
    subscriptionIds,
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
      unSubscribe(id, sessionId);
    }
  } catch (e) {
    logger.e(e);
  }
}
