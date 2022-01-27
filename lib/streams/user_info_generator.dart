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
    _listenToTransactions();
    _listenToPrices();
    _listenToGameState();
  }

  /// The [StreamController] used to generate a stream of [DynamicUserInfo]
  final _controller = StreamController<DynamicUserInfo>();

  /// A Read-only stream of [DynamicUserInfo]
  Stream<DynamicUserInfo> get stream => _controller.stream;

  /// Updates [dynamicUserInfo] and adds it to [_controller]
  void updateUserInfo(DynamicUserInfo newInfo) {
    dynamicUserInfo = newInfo;
    _controller.add(dynamicUserInfo);
  }

  /// Updates [dynamicUserInfo] for every new [TransactionUpdate]
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

        updateUserInfo(DynamicUserInfo(
          cash,
          reservedCash,
          stocksOwnedMap,
          stocksReservedMap,
          stockWorth,
          reservedStockWorth,
          totalWorth,
          dynamicUserInfo.isBlocked,
        ));
      });

  /// Updates [dynamicUserInfo] for every new [StockPricesUpdate]
  void _listenToPrices() => stockPricesStream.listen((newUpdate) {
        final newTotalWorth = dynamicUserInfo.newTotalWorth(newUpdate.prices);
        updateUserInfo(dynamicUserInfo.clone(newTotalWorth: newTotalWorth));
      });

  /// Updates [dynamicUserInfo] for every new relevant [GameStateUpdate]
  void _listenToGameState() => gameStateStream.listen((newUpdate) {
        final gameState = newUpdate.gameState;
        final type = gameState.type;
        // TODO: use switch case for enum
        if (type == GameStateUpdateType.UserBlockStateUpdate) {
          // TODO: show snackbar message whenever isBlocked changes
          final blockState = gameState.userBlockState;
          final newCash = blockState.cash.toInt();
          // ignore: unused_local_variable
          final penalty = newCash - dynamicUserInfo.cash;
          updateUserInfo(dynamicUserInfo.clone(
            newCash: newCash,
            newTotalWorth: dynamicUserInfo.newTotalWorth(
              stockMapStream.value.toPricesMap(),
              newCash: newCash,
            ),
            newIsBlocked: blockState.isBlocked,
          ));
        } else if (type == GameStateUpdateType.UserReferredCreditUpdate ||
            type == GameStateUpdateType.UserRewardCreditUpdate) {
          final newCash = (gameState.hasUserReferredCredit()
                  ? gameState.userReferredCredit.cash
                  : gameState.userRewardCredit.cash)
              .toInt();
          updateUserInfo(dynamicUserInfo.clone(
            newCash: newCash,
            newTotalWorth: dynamicUserInfo.newTotalWorth(
              stockMapStream.value.toPricesMap(),
              newCash: newCash,
            ),
          ));
        }
      });
}
