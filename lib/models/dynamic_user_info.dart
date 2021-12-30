import 'package:equatable/equatable.dart';

// User info that keeps changing after each transaction
class DynamicUserInfo extends Equatable {
  // Cash info
  final int cash;
  final int reservedCash;
  // Stock info
  final Map<int, int> stocksOwnedMap;
  final Map<int, int> stocksReservedMap;

  const DynamicUserInfo(
    this.cash,
    this.reservedCash,
    this.stocksOwnedMap,
    this.stocksReservedMap,
  );

  @override
  List<Object?> get props => [
        cash,
        reservedCash,
        stocksOwnedMap,
        stocksReservedMap,
      ];
}
