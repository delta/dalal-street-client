import 'dart:async';

import 'package:dalal_street_client/models/dynamic_user_info.dart';
import 'package:dalal_street_client/proto_build/datastreams/GameState.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/StockPrices.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Transactions.pb.dart';
import 'package:dalal_street_client/proto_build/models/GameState.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/utils/convert.dart';
import 'package:rxdart/streams.dart';

/// Generate a stream of [DynamicUserInfo] using [transactionStream], [stockPricesStream]
class UserInfoGenerator {
  // TODO: make this private
  // TODO: use setter method to avoid calling _controller.add multiple times
  DynamicUserInfo dynamicUserInfo;

  // Updates all fields in DynamicUserInfo
  final Stream<TransactionUpdate> transactionStream;
  final ValueStream<Map<int, Stock>> stockMapStream;
  // Updates only totalWorth
  final Stream<StockPricesUpdate> stockPricesStream;
  // Updates cash, totalWorth and isBlocked
  final Stream<GameStateUpdate> gameStateStream;

  UserInfoGenerator(
    this.dynamicUserInfo,
    this.transactionStream,
    this.stockMapStream,
    this.stockPricesStream,
    this.gameStateStream,
  ) {
    // TODO: use getters, setters or copy function in DynamicUserInfo to reduce code
    _listenToTransactions();
    _listenToPrices();
    _listenToGameState();
  }

  void _listenToTransactions() => transactionStream.listen((newUpdate) {
        // New transaction
        final transaction = newUpdate.transaction;
        final stockId = transaction.stockId;
        // Latest stockMap
        final stocks = stockMapStream.value;

        // Update cash values
        int cash = dynamicUserInfo.cash,
            reservedCash = dynamicUserInfo.reservedCash;
        cash += transaction.total.toInt();
        reservedCash += transaction.reservedCashTotal.toInt();

        // Update stock values
        var stocksOwnedMap = dynamicUserInfo.stocksOwnedMap,
            stocksReservedMap = dynamicUserInfo.stocksReservedMap;
        if (stocksOwnedMap.containsKey(stockId)) {
          stocksOwnedMap[stockId] =
              stocksOwnedMap[stockId]! + transaction.stockQuantity.toInt();
        } else {
          stocksOwnedMap[stockId] = transaction.stockQuantity.toInt();
        }
        if (stocksReservedMap.containsKey(stockId)) {
          stocksReservedMap[stockId] = stocksReservedMap[stockId]! +
              transaction.reservedStockQuantity.toInt();
        } else {
          stocksReservedMap[stockId] =
              transaction.reservedStockQuantity.toInt();
        }

        // Update stock worth values
        int stockWorth = dynamicUserInfo.stockWorth,
            reservedStockWorth = dynamicUserInfo.reservedStocksWorth,
            totalWorth = dynamicUserInfo.totalWorth;
        stockWorth += transaction.stockQuantity.toInt() *
            (stocks[stockId]?.currentPrice.toInt() ?? 0);
        reservedStockWorth += transaction.reservedStockQuantity.toInt() *
            (stocks[stockId]?.currentPrice.toInt() ?? 0);
        totalWorth = calculateTotalWorth(cash, reservedCash, stocksOwnedMap,
            stocksReservedMap, stocks.toPricesMap());

        dynamicUserInfo = DynamicUserInfo(
          cash,
          reservedCash,
          stocksOwnedMap,
          stocksReservedMap,
          stockWorth,
          reservedStockWorth,
          totalWorth,
        );
        _controller.add(dynamicUserInfo);
      });

  void _listenToPrices() => stockPricesStream.listen((newUpdate) {
        final newTotalWorth = dynamicUserInfo.newTotalWorth(newUpdate.prices);
        dynamicUserInfo = DynamicUserInfo(
          dynamicUserInfo.cash,
          dynamicUserInfo.reservedCash,
          dynamicUserInfo.stocksOwnedMap,
          dynamicUserInfo.stocksReservedMap,
          dynamicUserInfo.stockWorth,
          dynamicUserInfo.reservedStocksWorth,
          newTotalWorth,
        );
        _controller.add(dynamicUserInfo);
      });

  void _listenToGameState() => gameStateStream.listen((newUpdate) {
        final gameState = newUpdate.gameState;
        final type = gameState.type;
        if (type == GameStateUpdateType.UserBlockStateUpdate) {
          // TODO: complete this
        } else if (type == GameStateUpdateType.UserReferredCreditUpdate ||
            type == GameStateUpdateType.UserRewardCreditUpdate) {
          final newCash = (gameState.hasUserReferredCredit()
                  ? gameState.userReferredCredit.cash
                  : gameState.userRewardCredit.cash)
              .toInt();
          dynamicUserInfo = DynamicUserInfo(
            newCash,
            dynamicUserInfo.reservedCash,
            dynamicUserInfo.stocksOwnedMap,
            dynamicUserInfo.stocksReservedMap,
            dynamicUserInfo.stockWorth,
            dynamicUserInfo.reservedStocksWorth,
            dynamicUserInfo.newTotalWorth(
              stockMapStream.value.toPricesMap(),
              newCash: newCash,
            ),
          );
        }
        _controller.add(dynamicUserInfo);
      });

  /// The [StreamController] used to modify the stream of [DynamicUserInfo]
  final _controller = StreamController<DynamicUserInfo>();

  /// Read-only stream of [DynamicUserInfo]
  Stream<DynamicUserInfo> get stream => _controller.stream;
}
