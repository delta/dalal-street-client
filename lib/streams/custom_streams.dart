part of 'global_streams.dart';

/// Generates a Stream of Stocks Map which is updated using [stockPricesStream] and [stockExchangeStream]
///
/// Both [stockPricesStream] and [stockExchangeStream] must be seeded with initial values.
ValueStream<Map<int, Stock>> _generateStockMapStream(
  Map<int, Stock> stocksMap,
  ValueStream<StockPricesUpdate> stockPricesStream,
  ValueStream<StockExchangeUpdate> stockExchangeStream,
) =>
    CombineLatestStream.combine2<StockPricesUpdate, StockExchangeUpdate,
        Map<int, Stock>>(
      stockPricesStream,
      stockExchangeStream,
      (priceUpdate, exchangeUpdate) {
        logger.d('Stock map combiner called');

        // Update prices
        priceUpdate.prices.forEach((id, newPrice) {
          var stock = stocksMap[id]!;
          stock.currentPrice = newPrice;

          if (newPrice > stock.allTimeHigh) {
            stock.allTimeHigh = newPrice;
          } else if (newPrice > stock.dayHigh) {
            stock.dayHigh = newPrice;
          } else if (newPrice < stock.dayLow) {
            stock.dayLow = newPrice;
          } else if (newPrice < stock.allTimeLow) {
            stock.allTimeLow = newPrice;
          }

          stock.upOrDown = stock.previousDayClose < newPrice;

          stocksMap[id] = stock;
        });

        // Update exchange data
        exchangeUpdate.stocksInExchange.forEach((id, exchangeData) {
          stocksMap[id]!.stocksInExchange = exchangeData.stocksInExchange;
          stocksMap[id]!.stocksInMarket = exchangeData.stocksInMarket;
        });
        return stocksMap;
      },
    ).shareValue();

/// Generates a Stream of [DynamicUserInfo] which is updated using [transactionStream]
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
