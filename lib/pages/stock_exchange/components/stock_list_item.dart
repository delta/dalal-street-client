import 'package:dalal_street_client/blocs/list_selection/selectedIndex/selected_index_cubit.dart';
import 'package:dalal_street_client/blocs/list_selection/list_selection_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/streams/transformations.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StockListItem extends StatefulWidget {
  final Stock company;
  final List<bool> selectedItems;
  final int index;

  const StockListItem({
    Key? key,
    required this.company,
    required this.selectedItems,
    required this.index,
  }) : super(key: key);

  @override
  _StockListItemState createState() => _StockListItemState();
}

class _StockListItemState extends State<StockListItem> {
  final stockMapStream = getIt<GlobalStreams>().stockMapStream;


  @override
  Widget build(BuildContext context) {
    int previousDayClose = widget.company.previousDayClose.toInt();
    return GestureDetector(
      onTap: () {
        context.read<SelectedIndexCubit>().setSelected(widget.index);
        context
            .read<ListSelectedItemCubit>()
            .setSelectedItem(widget.company.id);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: widget.selectedItems[widget.index]
                ? Border.all(color: primaryColor)
                : Border.all(color: Colors.transparent),
            color: widget.selectedItems[widget.index] ? baseColor : background2,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _stockNames(widget.company),
            _stockPrices(
              widget.company.id,
              previousDayClose,
              widget.company.currentPrice.toInt(),
            ),
          ])),
    );
  }

  Widget _stockNames(Stock company) {
    return Expanded(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              company.shortName,
              style: const TextStyle(fontSize: 24, color: white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              company.fullName,
              style: const TextStyle(
                fontSize: 18,
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
                  style: const TextStyle(fontSize: 24, color: white),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  updatedPriceChange >= 0
                      ? '+' + oCcy.format(updatedPriceChange).toString()
                      : oCcy.format(updatedPriceChange).toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: updatedPriceChange > 0 ? secondaryColor : heartRed,
                  ),
                ),
              ],
            );
          },
        ),
      );
}
