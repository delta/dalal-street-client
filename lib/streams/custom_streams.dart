part of 'global_streams.dart';

/// Generates a Stream of [UserCashInfo] which is updated based on [transactionStream]
Stream<UserCashInfo> _generateUserCashStream(
  User user,
  Stream<TransactionUpdate> transactionStream,
) async* {
  int cash = user.cash.toInt();
  int reservedCash = user.reservedCash.toInt();
  // TODO: Should we add the initial values to the stream?
  yield UserCashInfo(cash, reservedCash);

  await for (var item in transactionStream) {
    final transaction = item.transaction;
    // Update cash values from new transaction
    cash += transaction.total.toInt();
    reservedCash += transaction.reservedCashTotal.toInt();

    // Add to the stream
    yield UserCashInfo(cash, reservedCash);
  }
}

Stream<UserStockInfo> _generateUserStockStream(
  UserStockInfo stockInfo,
  Stream<TransactionUpdate> transactionStream,
) async* {
  final stocksOwnedMap = stockInfo.stocksOwnedMap;
  final stocksReservedMap = stockInfo.stocksReservedMap;
  // TODO: Should we add the initial values to the stream?
  yield stockInfo;

  await for (var item in transactionStream) {
    final transaction = item.transaction;
    final stockId = transaction.stockId;
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

    // Add to the stream
    yield UserStockInfo(stocksOwnedMap, stocksReservedMap);
  }
}
