import 'package:dalal_street_client/models/dynamic_user_info.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:rxdart/rxdart.dart';

/// Transforms [userInfoStream] into a distinct cash stream
Stream<int> getCashStream(ValueStream<DynamicUserInfo> userInfoStream) =>
    userInfoStream.map((userInfo) => userInfo.cash).distinct();

/// Transforms [userInfoStream] into a distinct stocks owned stream
Stream<int> getStocksOwnedStream(
  int stockId,
  ValueStream<DynamicUserInfo> userInfoStream,
) =>
    userInfoStream
        .map((userInfo) => userInfo.stocksOwnedMap[stockId] ?? 0)
        .distinct();

/// Transforms [stockMapStream] into a distinct stock prices stream
Stream<Int64> getStockPriceStream(
  int stockId,
  ValueStream<Map<int, Stock>> stockMapStream,
) =>
    stockMapStream.map((event) => event[stockId]!.currentPrice).distinct();
