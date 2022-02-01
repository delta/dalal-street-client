import 'package:dalal_street_client/proto_build/actions/GetStockHistory.pbenum.dart';

class Resolution {
  String shortHand;
  String tooltip;

  Resolution(this.shortHand, this.tooltip);
}

Resolution resolutionToString(StockHistoryResolution stockHistory) {
  Resolution resolution = Resolution('', '');

  switch (stockHistory) {
    case StockHistoryResolution.OneMinute:
      resolution.shortHand = '1M';
      resolution.tooltip = '1 Minute';

      break;

    case StockHistoryResolution.FiveMinutes:
      resolution.shortHand = '5M';
      resolution.tooltip = '5 Minutes';
      break;

    case StockHistoryResolution.FifteenMinutes:
      resolution.shortHand = '15M';
      resolution.tooltip = '15 Minutes';
      break;

    case StockHistoryResolution.ThirtyMinutes:
      resolution.shortHand = '30M';
      resolution.tooltip = '30 Minutes';
      break;

    case StockHistoryResolution.SixtyMinutes:
      resolution.shortHand = '1H';
      resolution.tooltip = '1 Hour';
      break;

    case StockHistoryResolution.OneDay:
      resolution.shortHand = '1D';
      resolution.tooltip = '1 Day';
      break;
  }

  return resolution;
}
