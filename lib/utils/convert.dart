/// Some utility functions and extensions to convert between common data structures

import 'package:dalal_street_client/proto_build/datastreams/StockExchange.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:fixnum/fixnum.dart';

extension StockMapConverter on Map<int, Stock> {
  Map<int, Int64> toPricesMap() =>
      map((key, value) => MapEntry(key, value.currentPrice));

  Map<int, StockExchangeDataPoint> toExchangeMap() =>
      map((key, value) => MapEntry(
            key,
            StockExchangeDataPoint(
              price: value.currentPrice,
              stocksInExchange: value.stocksInExchange,
              stocksInMarket: value.stocksInMarket,
            ),
          ));
}

extension Int64MapConverter on Map<int, Int64> {
  Map<int, int> toIntMap() => map((key, value) => MapEntry(key, value.toInt()));
}

StockExchangeDataPoint stockToExchangeData(Stock stock) =>
    StockExchangeDataPoint(
      price: stock.currentPrice,
      stocksInExchange: stock.stocksInExchange,
      stocksInMarket: stock.stocksInMarket,
    );
