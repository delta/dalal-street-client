import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/models/user_info/user_cash_info.dart';
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

import 'config/log.dart';
import 'grpc/subscription.dart';

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
  final Stream<UserCashInfo> userCashStream;
  // final Stream<UserStockInfo> userStockStream;

  // Only used to unsubscribe from global streams. Don't use these to subscribe again
  final List<SubscriptionId> subscriptionIds;

  const GlobalStreams(
    this.stockList,
    this.gameStateStream,
    this.stockPricesStream,
    this.stockExchangeStream,
    this.transactionStream,
    this.notificationStream,
    this.userCashStream,
    // this.userStockStream,
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
        userCashStream,
        // userStockStream,
        subscriptionIds,
      ];
}

/// Subscribes to all Global Streams after login and returns the stream objects
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

  // subscribing to global streams
  late final SubscriptionId gameStateSubscriptionId;
  late final SubscriptionId stockPriceSubscriptionId;
  late final SubscriptionId stockExchangeSubscriptionId;
  late final SubscriptionId transactionSubscriptionId;
  late final SubscriptionId notificationSubscriptionId;

  late final Stream<GameStateUpdate> gameStateStream;
  late final Stream<StockPricesUpdate> stockPriceStream;
  late final Stream<StockExchangeUpdate> stockExchangeStream;
  late final Stream<TransactionUpdate> transactionStream;
  late final Stream<NotificationUpdate> notificationStream;

  late final Stream<UserCashInfo> userCashStream;

  gameStateSubscriptionId = await subscribe(
    SubscribeRequest(dataStreamType: DataStreamType.GAME_STATE),
    sessionId,
  );
  stockPriceSubscriptionId = await subscribe(
    SubscribeRequest(dataStreamType: DataStreamType.STOCK_PRICES),
    sessionId,
  );
  stockExchangeSubscriptionId = await subscribe(
    SubscribeRequest(dataStreamType: DataStreamType.STOCK_EXCHANGE),
    sessionId,
  );
  transactionSubscriptionId = await subscribe(
    SubscribeRequest(dataStreamType: DataStreamType.TRANSACTIONS),
    sessionId,
  );
  notificationSubscriptionId = await subscribe(
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

  gameStateStream = streamClient
      .getGameStateUpdates(
        gameStateSubscriptionId,
        options: sessionOptions(sessionId),
      )
      .asBroadcastStream();
  stockPriceStream = streamClient
      .getStockPricesUpdates(
        stockPriceSubscriptionId,
        options: sessionOptions(sessionId),
      )
      .asBroadcastStream();
  stockExchangeStream = streamClient
      .getStockExchangeUpdates(
        stockExchangeSubscriptionId,
        options: sessionOptions(sessionId),
      )
      .asBroadcastStream();
  transactionStream = streamClient
      .getTransactionUpdates(
        transactionSubscriptionId,
        options: sessionOptions(sessionId),
      )
      .asBroadcastStream();
  notificationStream = streamClient
      .getNotificationUpdates(
        notificationSubscriptionId,
        options: sessionOptions(sessionId),
      )
      .asBroadcastStream();

  userCashStream = _generateUserCashStream(
    user,
    transactionStream,
  ).asBroadcastStream();

  return GlobalStreams(
    stockResponse.stockList,
    gameStateStream,
    stockPriceStream,
    stockExchangeStream,
    transactionStream,
    notificationStream,
    userCashStream,
    subscriptionIds,
  );
}

Stream<UserCashInfo> _generateUserCashStream(
  User user,
  Stream<TransactionUpdate> transactionStream,
) async* {
  int cash = user.cash.toInt();
  int reservedCash = user.reservedCash.toInt();
  // TODO: Should we add the initial values to the stream?
  yield UserCashInfo(cash, reservedCash);

  await for (var item in transactionStream) {
    // Update cash values from new transaction
    final transaction = item.transaction;
    cash += transaction.total.toInt();
    reservedCash += transaction.reservedCashTotal.toInt();

    // Add to the stream
    yield UserCashInfo(cash, reservedCash);
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
      unSubscribe(id, sessionId);
    }
  } catch (e) {
    logger.e(e);
  }
}
