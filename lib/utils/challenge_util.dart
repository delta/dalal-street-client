import 'package:dalal_street_client/models/dynamic_user_info.dart';
import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/proto_build/models/UserState.pb.dart';

extension ChallengeUtil on DailyChallenge {
  String get title {
    switch (challengeType) {
      case 'Cash':
        return 'Cash';
      case 'NetWorth':
        return 'Net Worth';
      case 'StockWorth':
        return 'Stock Worth';
      case 'SpecificStock':
        return 'Specific Stock';
      default:
        return '?!?!?!?!';
    }
  }

  String description(Stock? stock) {
    switch (challengeType) {
      case 'Cash':
        return 'Increase cash worth by ₹$value';
      case 'NetWorth':
        return 'Increase net worth by ₹$value';
      case 'StockWorth':
        return 'Increase stock worth by ₹$value';
      case 'SpecificStock':
        return 'Buy $value stocks from ${stock?.fullName ?? '<ERROR>'}';
      default:
        return '?!?!?!?!';
    }
  }

  int progress(DynamicUserInfo userInfo, UserState userState) {
    final initialValue = userState.initialValue.toInt();
    switch (challengeType) {
      case 'Cash':
        return (userInfo.cash + userInfo.reservedCash) - initialValue;
      case 'NetWorth':
        return userInfo.totalWorth - initialValue;
      case 'StockWorth':
        return (userInfo.stockWorth + userInfo.reservedStocksWorth) -
            initialValue;
      case 'SpecificStock':
        final totalStocks = (userInfo.stocksOwnedMap[stockId] ?? 0) +
            (userInfo.stocksReservedMap[stockId] ?? 0);
        return totalStocks - initialValue;
      default:
        return 69;
    }
  }
}
