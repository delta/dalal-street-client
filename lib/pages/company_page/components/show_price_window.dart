import 'package:dalal_street_client/constants/constants.dart';

String showPriceWindow(int currentPrice) {
  var lowerLimit =
      currentPrice.toDouble() * (1 - ORDER_PRICE_WINDOW.toDouble() / 100);
  var higherLimit =
      currentPrice.toDouble() * (1 + ORDER_PRICE_WINDOW.toDouble() / 100);

  return 'Between ₹' +
      lowerLimit.toStringAsFixed(2) +
      ' and ₹' +
      higherLimit.toStringAsFixed(2);
}
