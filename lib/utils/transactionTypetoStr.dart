import 'package:dalal_street_client/proto_build/models/Transaction.pb.dart';

String transactionTypeToStr(TransactionType trType){
  const FROM_EXCHANGE_TRANSACTION = TransactionType.FROM_EXCHANGE_TRANSACTION;
  const ORDER_FILL_TRANSACTION = TransactionType.ORDER_FILL_TRANSACTION;
  const MORTGAGE_TRANSACTION = TransactionType.MORTGAGE_TRANSACTION;
  const DIVIDEND_TRANSACTION = TransactionType.DIVIDEND_TRANSACTION;
  const ORDER_FEE_TRANSACTION = TransactionType.ORDER_FEE_TRANSACTION;
  const TAX_TRANSACTION = TransactionType.TAX_TRANSACTION;
  const PLACE_ORDER_TRANSACTION = TransactionType.PLACE_ORDER_TRANSACTION;
  const CANCEL_ORDER_TRANSACTION = TransactionType.CANCEL_ORDER_TRANSACTION;
    switch(trType) {
        case FROM_EXCHANGE_TRANSACTION : return 'Exchange';
        case ORDER_FILL_TRANSACTION : return 'OrderFill';
        case MORTGAGE_TRANSACTION : return 'Mortgage';
        case DIVIDEND_TRANSACTION : return 'Dividend';
        case ORDER_FEE_TRANSACTION: return 'Order Fee';
        case TAX_TRANSACTION: return 'Tax';
        case PLACE_ORDER_TRANSACTION: return 'Reserve';
        case CANCEL_ORDER_TRANSACTION: return 'Cancel Order';
    }
    return '';
}