import 'package:dalal_street_client/proto_build/actions/GetPortfolio.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:dalal_street_client/utils/convert.dart';
import 'package:equatable/equatable.dart';

// User info that keeps changing after each transaction
class DynamicUserInfo extends Equatable {
  // Cash info
  final int cash;
  final int reservedCash;
  // Stock info
  final Map<int, int> stocksOwnedMap;
  final Map<int, int> stocksReservedMap;
  // Stock worth info
  final int stockWorth;
  final int reservedStocksWorth;

  const DynamicUserInfo(
    this.cash,
    this.reservedCash,
    this.stocksOwnedMap,
    this.stocksReservedMap,
    this.stockWorth,
    this.reservedStocksWorth,
  );

  DynamicUserInfo.from(
    User user,
    GetPortfolioResponse portfolioResponse,
    Map<int, Stock> stocks,
  )   : cash = user.cash.toInt(),
        reservedCash = user.reservedCash.toInt(),
        stocksOwnedMap = portfolioResponse.stocksOwned.toIntMap(),
        stocksReservedMap = portfolioResponse.reservedStocksOwned.toIntMap(),
        stockWorth = calculateStockWorth(
            portfolioResponse.stocksOwned.toIntMap(), stocks),
        reservedStocksWorth = calculateStockWorth(
            portfolioResponse.reservedStocksOwned.toIntMap(), stocks);

  @override
  List<Object?> get props => [
        cash,
        reservedCash,
        stocksOwnedMap,
        stocksReservedMap,
        stockWorth,
        reservedStocksWorth,
      ];
}

int calculateStockWorth(Map<int, int> stocksOwned, Map<int, Stock> stocks) {
  var worth = 0;
  stocks.forEach(
    (id, stock) {
      if (stocksOwned.containsKey(id)) {
        worth += stocksOwned[id]! + stock.currentPrice.toInt();
      }
    },
  );
  return worth;
}

int calculateReservedStockWorth(
    Map<int, int> stocksReserved, Map<int, Stock> stocks) {
  var worth = 0;
  stocks.forEach(
    (id, stock) {
      if (stocksReserved.containsKey(id)) {
        worth += stocksReserved[id]! + stock.currentPrice.toInt();
      }
    },
  );
  return worth;
}
