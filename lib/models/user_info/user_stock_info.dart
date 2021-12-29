import 'package:dalal_street_client/proto_build/actions/GetPortfolio.pb.dart';
import 'package:equatable/equatable.dart';

class UserStockInfo extends Equatable {
  final Map<int, int> stocksOwnedMap;
  final Map<int, int> stocksReservedMap;

  const UserStockInfo(this.stocksOwnedMap, this.stocksReservedMap);

  UserStockInfo.from(GetPortfolioResponse portfolioResponse)
      : stocksOwnedMap = portfolioResponse.stocksOwned
            .map((key, value) => MapEntry(key, value.toInt())),
        stocksReservedMap = portfolioResponse.reservedStocksOwned
            .map((key, value) => MapEntry(key, value.toInt()));

  @override
  List<Object?> get props => [
        stocksOwnedMap,
        stocksReservedMap,
      ];
}
