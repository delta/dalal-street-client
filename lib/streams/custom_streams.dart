part of 'global_streams.dart';

/// Generates a Stream of [UserCashInfo] which is updated based on [transactionStream]
Stream<UserCashInfo> _generateUserCashStream(
  User user,
  Stream<TransactionUpdate> transactionStream,
) async* {
  int cash = user.cash.toInt();
  int reservedCash = user.reservedCash.toInt();
  // TODO: Should we add the initial values to the stream?
  yield UserCashInfo(cash, reservedCash);

  await for (var item in transactionStream) {
    // Update cash values from new transaction
    final transaction = item.transaction;
    cash += transaction.total.toInt();
    reservedCash += transaction.reservedCashTotal.toInt();

    // Add to the stream
    yield UserCashInfo(cash, reservedCash);
  }
}
