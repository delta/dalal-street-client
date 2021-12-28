import 'package:dalal_street_client/proto_build/datastreams/StockExchange.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';

StockExchangeDataPoint stockDataToExchangeData(Stock stock) =>
    StockExchangeDataPoint(
      price: stock.currentPrice,
      stocksInExchange: stock.stocksInExchange,
      stocksInMarket: stock.stocksInMarket,
    );
