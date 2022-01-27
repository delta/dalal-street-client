part of 'global_streams.dart';

/// Generate a stream of Map<int, Stock> using [stockPricesStream], [stockExchangeStream] and gameStateStream
class StockStreamGenerator {
  Map<int, Stock> stocksMap;
  final Stream<StockPricesUpdate> stockPricesStream;
  final Stream<StockExchangeUpdate> stockExchangeStream;
  final Stream<GameStateUpdate> gameStateStream;

  StockStreamGenerator(
    this.stocksMap,
    this.stockPricesStream,
    this.stockExchangeStream,
    this.gameStateStream,
  ) {
    _listenToPrices();
    _listenToExchange();
  }

  /// The [StreamController] used to generate a stream of stock map
  final _controller = StreamController<Map<int, Stock>>();

  /// A Read-only stream of Map<int, Stock>
  Stream<Map<int, Stock>> get stream => _controller.stream;

  /// Updates [stocksMap] for every new [TransactionUpdate]
  void _listenToPrices() => stockPricesStream.listen((newUpdate) {
        newUpdate.prices.forEach((id, newPrice) {
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
        _controller.add(stocksMap);
      });

  /// Updates [stocksMap] for every new [StockExchangeUpdate]
  void _listenToExchange() => stockExchangeStream.listen((newUpdate) {
        newUpdate.stocksInExchange.forEach((id, exchangeData) {
          stocksMap[id]!.stocksInExchange = exchangeData.stocksInExchange;
          stocksMap[id]!.stocksInMarket = exchangeData.stocksInMarket;
        });
        _controller.add(stocksMap);
      });
}
