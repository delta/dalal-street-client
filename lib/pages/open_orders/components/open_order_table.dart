import 'dart:html';

import 'package:dalal_street_client/blocs/my_orders/my_orders_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/models/open_order_type.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpenOrderTable extends StatefulWidget {
  const OpenOrderTable({Key? key}) : super(key: key);

  @override
  State<OpenOrderTable> createState() => _OpenOrderTableState();
}

class _OpenOrderTableState extends State<OpenOrderTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: backgroundColor,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: _openOrderDataTable(),
        ));
  }

  Widget _openOrderDataTable() {
    return BlocConsumer<MyOrdersCubit, MyOrdersState>(
        listener: (context, state) {
      if (state is CancelOrderSuccess) {
        showSnackBar(context, 'Order Cancelled Successfully',
            type: SnackBarType.success);
        context.read<MyOrdersCubit>().getMyOpenOrders();
      } else if (state is CancelOrderFailure) {
        showSnackBar(context, state.error, type: SnackBarType.error);
      }
    }, builder: (context, state) {
      if (state is OpenOrdersSuccess) {
        List<DataRow> rows = [];
        List<DataColumn> columns = [];
        columns.add(_buildDataColumn('Company', false));
        columns.add(_buildDataColumn('Type', false));
        columns.add(_buildDataColumn('Volume', true));
        columns.add(_buildDataColumn('Filled', true));
        columns.add(_buildDataColumn('Price', true));
        columns.add(_buildDataColumn('Action', false));
        final askOrders = state.openAskOrders;
        final bidOrders = state.openBidOrders;
        final stockList = getIt<GlobalStreams>().latestStockMap;
        int index = 1;
        for (var order in askOrders) {
          rows.add(_buildDataRow(stockList[order.stockId]!, order,
              OpenOrderType.ASK, index % 2 == 0 ? background3 : background2));
          index++;
        }
        for (var order in bidOrders) {
          rows.add(_buildDataRow(stockList[order.stockId]!, order,
              OpenOrderType.BID, index % 2 == 0 ? background3 : background2));
          index++;
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: columns,
            rows: rows,
            columnSpacing: 70,
            dataRowHeight: 60,
            headingRowHeight: 60,
            headingRowColor: MaterialStateProperty.all(background3),
            border: TableBorder.all(
                color: blurredGray,
                width: 1,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                style: BorderStyle.solid),
          ),
        );
      } else if (state is NoOpenOrders) {
        return (const Center(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Text('No Open Orders',
                  style: TextStyle(fontSize: 14, color: Colors.white))),
        ));
      } else if (state is OpenOrdersFailure) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to Reach the Server'),
            const SizedBox(height: 20),
            SizedBox(
              width: 100,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  context.read<MyOrdersCubit>().getMyOpenOrders();
                },
                child: const Text('Retry'),
              ),
            ),
          ],
        ));
      } else {
        return const Center(
          child: DalalLoadingBar(),
        );
      }
    });
  }

  DataColumn _buildDataColumn(String heading, bool isNumeric) => DataColumn(
        numeric: isNumeric ? true : false,
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(heading,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: white),
              textAlign: TextAlign.center),
        ),
      );

  DataRow _buildDataRow(
          Stock company, openOrder, OpenOrderType ordertype, Color rowBg) =>
      DataRow(color: MaterialStateProperty.all(rowBg), cells: <DataCell>[
        DataCell(Center(
            child: Text(
          (company.shortName).toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color:
                  (ordertype == OpenOrderType.ASK) ? heartRed : primaryColor),
        ))),
        DataCell(Center(
            child: Text(
          '${ordertype.asString()} / ' + openOrder.orderType.name,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color:
                  (ordertype == OpenOrderType.ASK) ? heartRed : primaryColor),
        ))),
        DataCell(Center(
            child: Text(
          '${openOrder.stockQuantity}',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color:
                  (ordertype == OpenOrderType.ASK) ? heartRed : primaryColor),
        ))),
        DataCell(Center(
            child: Text(
          '${openOrder.stockQuantityFulfilled}',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color:
                  (ordertype == OpenOrderType.ASK) ? heartRed : primaryColor),
        ))),
        DataCell(Center(
            child: Text(
          '₹' + openOrder.price.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color:
                  (ordertype == OpenOrderType.ASK) ? heartRed : primaryColor),
        ))),
        DataCell(Center(
            child: OutlinedButton(
          style:
              OutlinedButton.styleFrom(side: const BorderSide(color: heartRed)),
          child: const Text(
            'Cancel',
            style: TextStyle(color: heartRed),
          ),
          onPressed: () {
            bool isAsk = ordertype == OpenOrderType.ASK ? true : false;
            int orderId = openOrder.id;
            context.read<MyOrdersCubit>().cancelMyOrder(isAsk, orderId);
          },
        ))),
      ]);
}
