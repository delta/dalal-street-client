import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/constants.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/pages/mortgage/components/retrieve_bottom_sheet.dart';
import 'package:dalal_street_client/proto_build/models/MortgageDetail.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/streams/transformations.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class RetrieveStockItem extends StatefulWidget {
  final Stock company;
  final MortgageDetail mortgageDetail;
  final Function onKnowMoreClicked;

  const RetrieveStockItem(
      {Key? key,
      required this.company,
      required this.mortgageDetail,
      required this.onKnowMoreClicked})
      : super(key: key);

  @override
  _RetrieveStockItemState createState() => _RetrieveStockItemState();
}

class _RetrieveStockItemState extends State<RetrieveStockItem> {
  final stockMapStream = getIt<GlobalStreams>().stockMapStream;
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
          _stockRetrieveDetails(widget.mortgageDetail),
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
                  onPressed: () => widget.onKnowMoreClicked(context,widget.company.id),
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
                  onPressed: () =>
                      _showModalSheet(widget.company, widget.mortgageDetail),
                  child: const Text(
                    'Retrieve',
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

  Widget _stockRetrieveDetails(MortgageDetail mortgageDetail) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Stocks Mortgaged'),
            Text('${mortgageDetail.stocksInBank}')
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Mortgaged Price(₹)'),
            Text('${mortgageDetail.mortgagePrice}')
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Retrieve rate(%)'),
            Text(((RETRIEVE_DEPOSIT_RATE * 100).toInt()).toString()),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Amount per Stock(₹)'),
            Text((mortgageDetail.mortgagePrice.toInt() * RETRIEVE_DEPOSIT_RATE)
                .toDouble()
                .toStringAsFixed(2))
          ],
        )
      ],
    );
  }

  void _showModalSheet(Stock company, MortgageDetail mortgageDetail) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: background2,
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return RetrieveBottomSheet(
            company: company,
            mortgageDetail: mortgageDetail,
          );
        });
  }
}
