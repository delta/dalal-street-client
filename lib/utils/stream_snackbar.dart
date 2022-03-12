import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/proto_build/models/GameState.pbenum.dart';
import 'package:dalal_street_client/proto_build/models/Transaction.pbenum.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/widgets.dart';

/// long util function to show appropirate
/// snackbar for streams updates
///
/// streams updates includes
/// - market open/close status
/// - referral and daily challenge reward claim status
/// - orders update
/// - transaction update
/// - notification update
/// - stock bankrupt state
/// - user blocked state
/// - daily challenges state
/// - dividends update
/// - user(current loggedIn user) blocked state
void streamSnackBarUpdates(BuildContext context) {
  _listenGameStateStream(context);
  _listenNotificationStream(context);
  _listenTransactionStream(context);
}

// gamestate stream listener
Future<void> _listenGameStateStream(BuildContext context) async {
  logger.d('snackbar: listening for gamestream');
  var gameStateStream = getIt<GlobalStreams>().gameStateStream;

  await for (var update in gameStateStream) {
    switch (update.gameState.type) {
      case GameStateUpdateType.MarketStateUpdate:
        if (update.gameState.marketState.isMarketOpen) {
          showSnackBar(context, 'Dalal Street Stock Market is open now',
              type: SnackBarType.success);
        } else {
          showSnackBar(context, 'Dalal Street Stock Market is closed right now',
              type: SnackBarType.success);
        }
        break;

      case GameStateUpdateType.StockDividendStateUpdate:
        var stock = getIt<GlobalStreams>()
            .stockMapStream
            .value[update.gameState.stockDividendState.stockId]!;
        showSnackBar(context,
            '${stock.fullName} has earned huge profits and thus has planned to give out dividends to its shareholders soon!');

        break;

      case GameStateUpdateType.StockBankruptStateUpdate:
        var stock = getIt<GlobalStreams>()
            .stockMapStream
            .value[update.gameState.stockDividendState.stockId]!;

        showSnackBar(context,
            'Owing to continuous heavy losses and degrading market conditions,${stock.fullName} has filed for bankruptcy.');
        break;

      case GameStateUpdateType.UserBlockStateUpdate:
        var isBlocked = update.gameState.userBlockState.isBlocked;

        if (isBlocked) {
          showSnackBar(context,
              'Your account has been blocked due to violation of Code of Conduct and a penalty of ₹${update.gameState.userBlockState.cash}  has been deducted from your cash.',
              type: SnackBarType.warning);
        } else {
          showSnackBar(context,
              'Your account has been unblocked! Any further violation of Code of Conduct will result in permanent ban of your account');
        }

        break;

      case GameStateUpdateType.UserReferredCreditUpdate:
        showSnackBar(context,
            'cash of ₹${update.gameState.userReferredCredit.cash} is credited as your referral bonus!');
        break;

      case GameStateUpdateType.DailyChallengeStatusUpdate:
        if (update.gameState.dailyChallengeState.isDailyChallengeOpen) {
          showSnackBar(context,
              'Daily challenges for the day is open, complete the challenges to collect cash rewards');
        } else {
          showSnackBar(context, 'Daily Challenge for today is closed');
        }
        break;

      case GameStateUpdateType.UserRewardCreditUpdate:
        var cash = update.gameState.userRewardCredit.cash;
        showSnackBar(context,
            'cash of ₹$cash is credited as your daily challenges reward',
            type: SnackBarType.success);
        break;
      default:
    }
  }
}

// transaction stream listener
Future<void> _listenTransactionStream(BuildContext context) async {
  logger.d('snackbar: listening for transaction');
  var transactionStream = getIt<GlobalStreams>().transactionStream;

  await for (var update in transactionStream) {
    logger.d(update.toString());
    var stock = getIt<GlobalStreams>()
        .stockMapStream
        .value[update.transaction.stockId]!;
    var stockQty = update.transaction.stockQuantity;
    var price = update.transaction.price;
    var total = update.transaction.total;
    var stockOrStocks = 'stock' + (stockQty.abs() > 1 ? 's' : '');

    switch (update.transaction.type) {
      case TransactionType.FROM_EXCHANGE_TRANSACTION:
        showSnackBar(context,
            'You have bought $stockQty $stockOrStocks of ${stock.fullName} at ₹$price from Exchange',
            type: SnackBarType.success);
        break;

      case TransactionType.MORTGAGE_TRANSACTION:
        showSnackBar(context,
            'You have ${total < 0 ? 'retrived' : 'mortgaged'} ${stockQty.abs()} $stockOrStocks of ${stock.fullName} at ₹${total.toDouble() / stockQty.toDouble()}',
            type: SnackBarType.success);
        break;

      case TransactionType.TAX_TRANSACTION:
        showSnackBar(context,
            'A total of ₹ ${-total} has been deducted from you as tax on the last profit you made');
        break;

      case TransactionType.PLACE_ORDER_TRANSACTION:
        showSnackBar(context,
            'A total of ${stockQty < 0 ? stockQty.abs().toString() + "stocks" : '₹' + total.abs().toString()} has been reserved for the order placed',
            type: SnackBarType.success);
        break;

      case TransactionType.CANCEL_ORDER_TRANSACTION:
        showSnackBar(context,
            'A total of ${stockQty < 0 ? stockQty.abs().toString() + "stocks" : '₹' + total.abs().toString() + ' has been returned for cancelling the order'}',
            type: SnackBarType.success);
        break;

      case TransactionType.ORDER_FILL_TRANSACTION:
        showSnackBar(context,
            '${stockQty > 0 ? "Buy" : "Sell"} order completed successfully',
            type: SnackBarType.success);
        break;

      case TransactionType.DIVIDEND_TRANSACTION:
        showSnackBar(context,
            'You have received ₹$total as dividends from ${stock.fullName}',
            type: SnackBarType.success);
        break;
      default:
    }
  }
}

// notification stream listener
Future<void> _listenNotificationStream(BuildContext context) async {
  logger.d('snackbar: listening for notification');

  var notificationStream = getIt<GlobalStreams>().notificationStream;

  await for (var _ in notificationStream) {
    showSnackBar(context, 'New notification');
  }
}
