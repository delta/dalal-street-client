import 'dart:async';

import 'package:dalal_street_client/proto_build/datastreams/GameState.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/StockExchange.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/StockPrices.pb.dart';
import 'package:dalal_street_client/proto_build/models/GameState.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';

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
    _listenToGameState();
  }

  /// The [StreamController] used to generate a stream of stock map
  final _controller = StreamController<Map<int, Stock>>();

  /// A Read-only stream of Map<int, Stock>
  Stream<Map<int, Stock>> get stream => _controller.stream;

  /// Updates [stocksMap] for every new [StockPriceUpdates]
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

  /// Updates [stocksMap] for every new relevant [GameStateUpdate]
  void _listenToGameState() => gameStateStream.listen((newUpdate) {
        final gameState = newUpdate.gameState;
        switch (gameState.type) {
          case GameStateUpdateType.StockDividendStateUpdate:
            // TODO: show notification
            final dividendState = gameState.stockDividendState;
            stocksMap[dividendState.stockId]!.givesDividends =
                dividendState.givesDividend;
            break;
          case GameStateUpdateType.StockBankruptStateUpdate:
            // TODO: show notification
            final bankruptState = gameState.stockBankruptState;
            stocksMap[bankruptState.stockId]!.isBankrupt =
                bankruptState.isBankrupt;
            break;
          default:
            return;
        }
        _controller.add(stocksMap);
      });
}
