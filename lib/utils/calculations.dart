import 'package:dalal_street_client/constants/constants.dart';

int calculateOrderFee(int totalPrice) {
  var orderFee = (ORDER_FEE_RATE * totalPrice);
  return orderFee.toInt();
}
