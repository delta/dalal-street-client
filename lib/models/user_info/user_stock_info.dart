import 'package:equatable/equatable.dart';

class UserStockInfo extends Equatable {
  final Map<int, int> stocksOwnedMap;
  final Map<int, int> stocksReservedMap;

  const UserStockInfo(this.stocksOwnedMap, this.stocksReservedMap);

  @override
  List<Object?> get props => [
        stocksOwnedMap,
        stocksReservedMap,
      ];
}
