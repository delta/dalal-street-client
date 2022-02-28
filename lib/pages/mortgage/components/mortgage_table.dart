import 'package:dalal_street_client/blocs/mortgage/mortgage_sheet/cubit/mortgage_sheet_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/constants.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/streams/transformations.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class MortgageTable extends StatefulWidget {
  const MortgageTable({Key? key}) : super(key: key);

  @override
  _MortgageTableState createState() => _MortgageTableState();
}

class _MortgageTableState extends State<MortgageTable> {
  Stock selectedCompany = Stock();
  int selectedQuantity = 1;
  final stockMapStream = getIt<GlobalStreams>().stockMapStream;
  final userInfoStream = getIt<GlobalStreams>().dynamicUserInfoStream;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: backgroundColor,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: _mortgageDataTable(),
        ));
  }

  Widget _mortgageDataTable() {
    List<DataRow> rows = [];
    List<DataColumn> columns = [];
    columns.add(_buildDataColumn('Company', false));
    columns.add(_buildDataColumn('Stocks Owned', true));
    columns.add(_buildDataColumn('Current Price(₹)', true));
    columns.add(_buildDataColumn('Deposit Rate(%)', true));
    columns.add(_buildDataColumn('Amount Per Stock(₹)', true));
    columns.add(_buildDataColumn('Quantity', false));
    columns.add(_buildDataColumn('Action', false));
    final stockList = getIt<GlobalStreams>().latestStockMap;
    int index = 1;
    for (var company in stockList.values) {
      rows.add(_mortgageDetailsRow(
          company, index % 2 == 0 ? background3 : background2));
      index++;
    }
    return BlocListener<MortgageSheetCubit, MortgageSheetState>(
      listener: (context, state) {
        if (state is MortgageSheetSuccess) {
          showSnackBar(context,
              'Successfully mortgaged $selectedQuantity ${selectedCompany.fullName} stocks',
              type: SnackBarType.success);
          Navigator.maybePop(context);
        } else if (state is MortgageSheetFailure) {
          showSnackBar(context, state.msg, type: SnackBarType.error);
          Navigator.maybePop(context);
        }
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: columns,
          rows: rows,
          columnSpacing: 80,
          dataRowHeight: 60,
          headingRowHeight: 60,
          headingRowColor: MaterialStateProperty.all(background3),
          border: TableBorder.all(
              color: blurredGray,
              width: 1,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              style: BorderStyle.solid),
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(String heading, bool isNumeric) => DataColumn(
        numeric: isNumeric ? true : false,
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(heading,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
              textAlign: TextAlign.center),
        ),
      );

  DataRow _mortgageDetailsRow(Stock company, Color bgColorRow) {
    int quantity = 1;
    return DataRow(color: MaterialStateProperty.all(bgColorRow), cells: <
        DataCell>[
      DataCell(Center(
          child: Text(
        (company.shortName).toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, color: white),
      ))),
      DataCell(Center(
          child: StreamBuilder<int>(
              stream: userInfoStream.stocksOwnedStream(company.id),
              initialData: userInfoStream.value.stocksOwnedMap[company.id] ?? 0,
              builder: (_, snapshot) {
                return Text(snapshot.data!.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, color: white));
              }))),
      DataCell(Center(
          child: StreamBuilder<Int64>(
              stream: stockMapStream.priceStream(company.id),
              initialData: (company.currentPrice),
              builder: (_, snapshot) {
                return Text(snapshot.data!.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, color: white));
              }))),
      DataCell(Center(
        child: Text(
          ((MORTGAGE_DEPOSIT_RATE * 100).toInt()).toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, color: white),
        ),
      )),
      DataCell(Center(
          child: StreamBuilder<Int64>(
              stream: stockMapStream.priceStream(company.id),
              initialData: (company.currentPrice),
              builder: (_, snapshot) {
                int stockPrice = snapshot.data!.toInt();
                double amount = (stockPrice * MORTGAGE_DEPOSIT_RATE);
                return Text(
                  amount.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: white),
                );
              }))),
      DataCell(Center(
          child: Container(
        height: 40,
        width: 150,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: primaryColor.withOpacity(0.2),
        ),
        child: SpinBox(
          min: 1,
          max: 20,
          value: 01,
          onChanged: (value) {
            quantity = value as int;
          },
          decoration: const InputDecoration(border: InputBorder.none),
          iconColor: MaterialStateProperty.all(primaryColor),
          spacing: 15,
          cursorColor: primaryColor,
          textStyle: const TextStyle(
            color: primaryColor,
            fontSize: 18,
          ),
        ),
      ))),
      DataCell(Center(
          child: OutlinedButton(
        child: const Text('Mortgage'),
        onPressed: () {
          if (quantity > 0) {
            selectedQuantity = quantity;
            selectedCompany = company;
            context
                .read<MortgageSheetCubit>()
                .mortgageStocks(company.id, quantity);
          }
        },
      ))),
    ]);
  }
}
