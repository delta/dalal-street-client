part of 'global_streams.dart';

/// Generates a Stream of [DynamicUserInfo] which is updated based on [transactionStream]
/// 
/// [porfolioResponse] status code must be [OK]
Stream<DynamicUserInfo> _generateDynamicUserInfoStream(
  User user,
  GetPortfolioResponse portfolioResponse,
  Stream<TransactionUpdate> transactionStream,
) async* {
  // Add initial values to the Stream
  int cash = user.cash.toInt();
  int reservedCash = user.reservedCash.toInt();
  Map<int, int> stocksOwnedMap = portfolioResponse.stocksOwned
      .map((key, value) => MapEntry(key, value.toInt()));
  Map<int, int> stocksReservedMap = portfolioResponse.reservedStocksOwned
      .map((key, value) => MapEntry(key, value.toInt()));
  yield DynamicUserInfo(
    cash,
    reservedCash,
    stocksOwnedMap,
    stocksReservedMap,
  );

  await for (var item in transactionStream) {
    final transaction = item.transaction;
    final stockId = transaction.stockId;
    // Update cash values from new transaction
    cash += transaction.total.toInt();
    reservedCash += transaction.reservedCashTotal.toInt();
    // Update stock values from new transaction
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
      stocksReservedMap[stockId] = transaction.reservedStockQuantity.toInt();
    }

    // Add new values to the stream
    yield DynamicUserInfo(
      cash,
      reservedCash,
      stocksOwnedMap,
      stocksReservedMap,
    );
  }
}
