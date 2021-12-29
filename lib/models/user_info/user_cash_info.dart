import 'package:equatable/equatable.dart';

class UserCashInfo extends Equatable {
  final int cash;
  final int reservedCash;

  const UserCashInfo(this.cash, this.reservedCash);

  @override
  List<Object?> get props => [
        cash,
        reservedCash,
      ];
}
