import 'dart:async';

import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/models/dynamic_user_info.dart';
import 'package:dalal_street_client/proto_build/actions/GetPortfolio.pb.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockList.pb.dart';
import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/GameState.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Notifications.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/StockExchange.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/StockPrices.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Transactions.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/generators/market_open_generator.dart';
import 'package:dalal_street_client/streams/generators/user_info_generator.dart';
import 'package:dalal_street_client/streams/generators/stock_stream_generator.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/streams.dart';

import '../config/log.dart';
import '../grpc/subscription.dart';

/// Streams used in many places in the app
///
/// All the global streams must be broadcast streams(ValueStreams are broadcast streams by default)
class GlobalStreams extends Equatable {
  // Global streams from the server
  final Stream<GameStateUpdate> gameStateStream;
  final ValueStream<StockPricesUpdate> stockPricesStream;
  final ValueStream<StockExchangeUpdate> stockExchangeStream;
  final Stream<TransactionUpdate> transactionStream;
  final Stream<NotificationUpdate> notificationStream;

  // Custom streams generated from server streams
  final ValueStream<Map<int, Stock>> stockMapStream;
  final ValueStream<DynamicUserInfo> dynamicUserInfoStream;
  final ValueStream<bool> isMaketOpenStream;

  // Only used to unsubscribe from global streams. Don't use these to subscribe again
  final List<SubscriptionId> subscriptionIds;

  const GlobalStreams(
    this.gameStateStream,
    this.stockPricesStream,
    this.stockExchangeStream,
    this.transactionStream,
    this.notificationStream,
    this.isMaketOpenStream,
    this.stockMapStream,
    this.dynamicUserInfoStream,
    this.subscriptionIds,
  );

  /// Returns the last emitted value of [stockMapStream]
  Map<int, Stock> get latestStockMap => stockMapStream.value;

  /// Returns the last emitted value of [dynamicUserInfoStream]
  DynamicUserInfo get latestUserInfo => dynamicUserInfoStream.value;

  @override
  List<Object?> get props => [
        gameStateStream,
        stockPricesStream,
        stockExchangeStream,
        transactionStream,
        notificationStream,
        isMaketOpenStream,
        stockMapStream,
        dynamicUserInfoStream,
        subscriptionIds,
      ];
}

/// Subscribes to all Global Streams and Initializes Custom Streams after login and returns the stream objects
/// Throws exception if any of them fails. Exception must be handled
Future<GlobalStreams> subscribeToGlobalStreams(
    LoginResponse loginResponse) async {
  logger.i('Subscribing to all global streams');
  final user = loginResponse.user;
  final sessionId = loginResponse.sessionId;
  final isMaketOpen = loginResponse.isMarketOpen;

  // getStockList request, return map of stockId -> Stock
  final stockResponse = await actionClient.getStockList(
    GetStockListRequest(),
    options: sessionOptions(sessionId),
  );
  if (stockResponse.statusCode != GetStockListResponse_StatusCode.OK) {
    throw Exception(stockResponse.statusMessage);
  }
  final initialStocks = stockResponse.stockList;

  // Subscribe to all the streams
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

  // Get the streams using the subscription ids
  final gameStateStream = streamClient
      .getGameStateUpdates(
        gameStateSubscriptionId,
        options: sessionOptions(sessionId),
      )
      .asBroadcastStream();
  final stockPricesStream = streamClient
      .getStockPricesUpdates(
        stockPriceSubscriptionId,
        options: sessionOptions(sessionId),
      )
      .shareValueSeeded(StockPricesUpdate(prices: initialStocks.toPricesMap()));
  final stockExchangeStream = streamClient
      .getStockExchangeUpdates(
        stockExchangeSubscriptionId,
        options: sessionOptions(sessionId),
      )
      .shareValueSeeded(
        StockExchangeUpdate(stocksInExchange: initialStocks.toExchangeMap()),
      );
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
  logger.i('Generating custom streams from server streams');

  // is maket open stream
  final isMaketOpenStream = MarketOpenGenerator(isMaketOpen, gameStateStream)
      .stream
      .shareValueSeeded(isMaketOpen);

  // Stock map stream
  final stockMapStream = StockStreamGenerator(
    initialStocks,
    stockPricesStream,
    stockExchangeStream,
    gameStateStream,
  ).stream.shareValueSeeded(initialStocks);

  // DynamicUserInfo stream
  final portfolioResponse = await actionClient.getPortfolio(
    GetPortfolioRequest(),
    options: sessionOptions(sessionId),
  );
  if (portfolioResponse.statusCode != GetPortfolioResponse_StatusCode.OK) {
    throw Exception(portfolioResponse.statusMessage);
  }
  final initialUserInfo = DynamicUserInfo.from(
    user.cash.toInt(),
    user.reservedCash.toInt(),
    portfolioResponse.stocksOwned.toIntMap(),
    portfolioResponse.reservedStocksOwned.toIntMap(),
    user.isBlocked,
    initialStocks,
  );
  final dynamicUserInfoStream = UserInfoGenerator(
    initialUserInfo,
    transactionStream,
    stockMapStream,
    stockPricesStream.skip(1),
    gameStateStream,
  ).stream.shareValueSeeded(initialUserInfo);

  return GlobalStreams(
    gameStateStream,
    stockPricesStream,
    stockExchangeStream,
    transactionStream,
    notificationStream,
    isMaketOpenStream,
    stockMapStream,
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
