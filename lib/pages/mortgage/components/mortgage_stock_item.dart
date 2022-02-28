import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/constants.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/pages/mortgage/components/mortgage_bottom_sheet.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/streams/transformations.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class MortgageStockItem extends StatefulWidget {
  final Stock company;
  final void Function(int stockId) onViewClicked;

  const MortgageStockItem({
    Key? key,
    required this.company,
    required this.onViewClicked,
  }) : super(key: key);

  @override
  _MortgageStockItemState createState() => _MortgageStockItemState();
}

class _MortgageStockItemState extends State<MortgageStockItem> {
  final stockMapStream = getIt<GlobalStreams>().stockMapStream;
  final userInfoStream = getIt<GlobalStreams>().dynamicUserInfoStream;
  @override
  Widget build(BuildContext context) {
    int previousDayClose = widget.company.previousDayClose.toInt();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: background2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _stockNames(widget.company),
            _stockPrices(
              widget.company.id,
              previousDayClose,
              widget.company.currentPrice.toInt(),
            ),
          ]),
          const SizedBox(
            height: 10,
          ),
          _stockMortgageDetails(
              widget.company.id, widget.company.currentPrice.toInt()),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 40,
                width: 100,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      )),
                      overlayColor: MaterialStateProperty.all(secondaryColor),
                      backgroundColor: MaterialStateProperty.all(
                          primaryColor.withOpacity(0.2))),
                  onPressed: () =>
                      widget.onViewClicked(widget.company.id),
                  child: const Text(
                    'View',
                    style: TextStyle(color: primaryColor, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                height: 40,
                width: 100,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      )),
                      overlayColor: MaterialStateProperty.all(secondaryColor)),
                  onPressed: () => _showModalSheet(widget.company),
                  child: const Text(
                    'Mortgage',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _stockNames(Stock company) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          company.shortName,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        Text(
          company.fullName,
          style: const TextStyle(
            fontSize: 14,
            color: whiteWithOpacity50,
          ),
        ),
      ]),
    );
  }

  Widget _stockPrices(
    int stockId,
    int previousDayClose,
    int currentPrice,
  ) =>
      Expanded(
        child: StreamBuilder<Int64>(
          stream: stockMapStream.priceStream(stockId),
          initialData: Int64(currentPrice),
          builder: (_, snapshot) {
            int stockPrice = snapshot.data!.toInt();
            int updatedPriceChange = stockPrice - previousDayClose;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹' + oCcy.format(stockPrice).toString(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  updatedPriceChange >= 0
                      ? '+' + oCcy.format(updatedPriceChange).toString()
                      : oCcy.format(updatedPriceChange).toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: updatedPriceChange > 0 ? secondaryColor : heartRed,
                  ),
                ),
              ],
            );
          },
        ),
      );

  Widget _stockMortgageDetails(int stockId, int currentPrice) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Stocks Owned'),
            StreamBuilder<int>(
                stream: userInfoStream.stocksOwnedStream(stockId),
                initialData: userInfoStream.value.stocksOwnedMap[stockId] ?? 0,
                builder: (_, snapshot) {
                  return Text(
                    snapshot.data!.toString(),
                  );
                })
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Deposit rate(%)'),
            Text(((MORTGAGE_DEPOSIT_RATE * 100).toInt()).toString()),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Amount per Stock(₹)'),
            StreamBuilder<Int64>(
                stream: stockMapStream.priceStream(stockId),
                initialData: Int64(currentPrice),
                builder: (_, snapshot) {
                  int stockPrice = snapshot.data!.toInt();
                  double amount = (stockPrice * MORTGAGE_DEPOSIT_RATE);
                  return Text(amount.toStringAsFixed(2));
                })
          ],
        )
      ],
    );
  }

  void _showModalSheet(Stock company) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: background2,
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return MortgageBottomSheet(company: company);
        });
  }
}
