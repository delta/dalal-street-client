import 'package:dalal_street_client/models/dynamic_user_info.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:rxdart/rxdart.dart';

// returns a stream of user cash worth
Stream<int> getCashStream(ValueStream<DynamicUserInfo> userInfoStream) =>
    userInfoStream.map((userInfo) => userInfo.cash).distinct();

// returns a stock price stream of a particular stock id
Stream<Int64> getStockPriceStream(
        int stockId, ValueStream<Map<int, Stock>> stockMapStream) =>
    stockMapStream.map((event) => event[stockId]!.currentPrice).distinct();
