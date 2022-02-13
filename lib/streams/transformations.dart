import 'package:dalal_street_client/models/dynamic_user_info.dart';
import 'package:dalal_street_client/proto_build/datastreams/GameState.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:fixnum/fixnum.dart';

/// Useful extensions on user info stream
extension UserInfoStreamTransformations on Stream<DynamicUserInfo> {
  /// Transforms userInfoStream into a distinct cash stream
  Stream<int> cashStream() => map((userInfo) => userInfo.cash).distinct();

  /// Transforms userInfoStream into a distinct stocks owned stream for the given [stockId]
  Stream<int> stocksOwnedStream(int stockId) =>
      map((userInfo) => userInfo.stocksOwnedMap[stockId] ?? 0).distinct();
}

/// Useful extensions on stock map stream
extension StockMapStreamTransformations on Stream<Map<int, Stock>> {
  /// Transforms stockMapStream into a distinct stock price stream for the given [stockId]
  Stream<Int64> priceStream(int stockId) =>
      map((stocks) => stocks[stockId]?.currentPrice ?? Int64(0)).distinct();
}

extension GameStateStreamTransformations on Stream<GameStateUpdate> {
  /// Transforms gameStateStream into a distinct game state stream
  Stream<bool> isBankruptStream(int stockId) => map((gameState) =>
      gameState.gameState.stockBankruptState.stockId == stockId
          ? gameState.gameState.stockBankruptState.isBankrupt
          : false).distinct();

  Stream<bool> givesDividents(int stockId) => map((gameState) =>
      gameState.gameState.stockDividendState.stockId == stockId
          ? gameState.gameState.stockDividendState.givesDividend
          : false).distinct();
}
