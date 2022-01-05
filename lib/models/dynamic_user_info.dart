import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/utils/convert.dart';
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';

/// User info that keeps changing
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
  final int totalWorth;

  const DynamicUserInfo(
    this.cash,
    this.reservedCash,
    this.stocksOwnedMap,
    this.stocksReservedMap,
    this.stockWorth,
    this.reservedStocksWorth,
    this.totalWorth,
  );

  DynamicUserInfo.from(
    this.cash,
    this.reservedCash,
    this.stocksOwnedMap,
    this.stocksReservedMap,
    Map<int, Stock> stocks,
  )   : stockWorth = calculateStockWorth(stocksOwnedMap, stocks),
        reservedStocksWorth = calculateStockWorth(stocksReservedMap, stocks),
        totalWorth = calculateTotalWorth(
          cash,
          reservedCash,
          stocksOwnedMap,
          stocksReservedMap,
          stocks.toPricesMap(),
        );

  int newTotalWorth(Map<int, Int64> stockPrices) => calculateTotalWorth(
        cash,
        reservedCash,
        stocksOwnedMap,
        stocksReservedMap,
        stockPrices,
      );

  @override
  List<Object?> get props => [
        cash,
        reservedCash,
        stocksOwnedMap,
        stocksReservedMap,
        stockWorth,
        reservedStocksWorth,
        totalWorth,
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

int calculateTotalWorth(
  int cash,
  int reservedCash,
  Map<int, int> stocksOwned,
  Map<int, int> stocksReseved,
  Map<int, Int64> stockPrices,
) {
  var total = cash + reservedCash;
  stockPrices.forEach((id, price) {
    if (stocksOwned.containsKey(id)) {
      total += stocksOwned[id]! * price.toInt();
    }
    if (stocksReseved.containsKey(id)) {
      total += stocksReseved[id]! * price.toInt();
    }
  });
  return total;
}
