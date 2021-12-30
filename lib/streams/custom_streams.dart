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
    )

        /// ValueStream needs to be seeded to access stream.value without exception. So it is seeded in last step
        /// But because both prices and exchange streams are seeded, the resulting stream will emit the same stockMap again, so skip 1 value
        ///
        /// Why should prices and exchange streams be seeded?
        /// Combiner function will not be called until all the provided streams emit atleast one value
        .skip(1)
        .shareValueSeeded(stocksMap);

/// Generates a Stream of [DynamicUserInfo] which is updated using [transactionStream]
///
/// [porfolioResponse] status code must be [OK]
ValueStream<DynamicUserInfo> _generateDynamicUserInfoStream(
  DynamicUserInfo dynamicUserInfo,
  Stream<TransactionUpdate> transactionStream,
) =>
    transactionStream.map((newUpdate) {
      final transaction = newUpdate.transaction;
      final stockId = transaction.stockId;

      int cash = dynamicUserInfo.cash,
          reservedCash = dynamicUserInfo.reservedCash;
      Map<int, int> stocksOwnedMap = dynamicUserInfo.stocksOwnedMap,
          stocksReservedMap = dynamicUserInfo.stocksReservedMap;
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

      return DynamicUserInfo(
        cash,
        reservedCash,
        stocksOwnedMap,
        stocksReservedMap,
      );
    }).shareValueSeeded(dynamicUserInfo);
