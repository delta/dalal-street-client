/// Some utility functions to convert between common data structures

import 'package:dalal_street_client/proto_build/datastreams/StockExchange.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:fixnum/fixnum.dart';

Map<int, Int64> stocksMapToPricesMap(Map<int, Stock> stocks) => stocks.map(
      (key, value) => MapEntry(key, value.currentPrice),
    );

Map<int, StockExchangeDataPoint> stocksMapToExchangeMap(
  Map<int, Stock> stocks,
) =>
    stocks.map(
      (key, value) => MapEntry(
        key,
        StockExchangeDataPoint(
          price: value.currentPrice,
          stocksInExchange: value.stocksInExchange,
          stocksInMarket: value.stocksInMarket,
        ),
      ),
    );

StockExchangeDataPoint stockDataToExchangeData(Stock stock) =>
    StockExchangeDataPoint(
      price: stock.currentPrice,
      stocksInExchange: stock.stocksInExchange,
      stocksInMarket: stock.stocksInMarket,
    );
