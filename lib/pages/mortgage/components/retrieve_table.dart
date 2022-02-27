import 'package:dalal_street_client/blocs/mortgage/mortgage_details/mortgage_details_cubit.dart';
import 'package:dalal_street_client/blocs/mortgage/mortgage_sheet/cubit/mortgage_sheet_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/constants.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/proto_build/models/MortgageDetail.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class RetrieveTable extends StatefulWidget {
  const RetrieveTable({Key? key}) : super(key: key);

  @override
  _RetrieveTableState createState() => _RetrieveTableState();
}

class _RetrieveTableState extends State<RetrieveTable> {
  Stock selectedCompany = Stock();
  int selectedQuantity = 1;
  @override
  void initState() {
    super.initState();
    context.read<MortgageDetailsCubit>().getMortgageDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: backgroundColor,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: _retrieveDataTable(),
                ),
              ],
            )));
  }

  Widget _retrieveDataTable() {
    List<DataColumn> columns = [];
    columns.add(_buildDataColumn('Company', false));
    columns.add(_buildDataColumn('Stocks Mortgaged', true));
    columns.add(_buildDataColumn('Mortgaged Price(₹)', true));
    columns.add(_buildDataColumn('Retrieval Rate(%)', true));
    columns.add(_buildDataColumn('Amount Per Stock(₹)', true));
    columns.add(_buildDataColumn('Quanitity', false));
    columns.add(_buildDataColumn('Action', false));
    final stockList = getIt<GlobalStreams>().latestStockMap;
    return BlocListener<MortgageSheetCubit, MortgageSheetState>(
      listener: (context, state) {
        if (state is MortgageSheetSuccess) {
          showSnackBar(context,
              'Successfully retrieved $selectedQuantity ${selectedCompany.fullName} stocks',
              type: SnackBarType.success);
          context.read<MortgageDetailsCubit>().getMortgageDetails();
        } else if (state is MortgageSheetFailure) {
          showSnackBar(context, state.msg, type: SnackBarType.error);
        }
      },
      child: BlocBuilder<MortgageDetailsCubit, MortgageDetailsState>(
        builder: (context, state) {
          if (state is MortgageDetailsLoaded) {
            if (state.mortgageDetails.isEmpty) {
              return const Center(
                child: Text('No mortgaged Stocks'),
              );
            }
            List<DataRow> rows = [];
            for (var mortgageDetail in state.mortgageDetails) {
              Stock company = stockList[mortgageDetail.stockId]!;
              rows.add(_retrieveDetailsRow(mortgageDetail, company));
            }
            return DataTable(
              columns: columns,
              rows: rows,
              columnSpacing: 80,
            );
          } else if (state is MortgageDetailsLoading) {
            return const Center(
              child: DalalLoadingBar(),
            );
          } else {
            return const Center(
              child: Text('Failed to load data'),
            );
          }
        },
      ),
    );
  }

  DataColumn _buildDataColumn(String heading, bool isNumeric) => DataColumn(
        numeric: isNumeric ? true : false,
        label: Center(
          child: Text(heading,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center),
        ),
      );

  DataRow _retrieveDetailsRow(MortgageDetail mortgageDetail, Stock company) {
    int quantity = 1;
    return DataRow(cells: <DataCell>[
      DataCell(Center(
          child: Text(
        (company.shortName).toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, color: white),
      ))),
      DataCell(Center(
          child: Text(
        (mortgageDetail.stocksInBank).toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, color: white),
      ))),
      DataCell(Center(
          child: Text(
        (mortgageDetail.mortgagePrice).toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, color: white),
      ))),
      DataCell(Center(
          child: Text(
        ((RETRIEVE_DEPOSIT_RATE * 100).toInt()).toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, color: white),
      ))),
      DataCell(Center(
          child: Text(
        (mortgageDetail.mortgagePrice.toInt() * RETRIEVE_DEPOSIT_RATE)
            .toDouble()
            .toStringAsFixed(2),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, color: white),
      ))),
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
        child: const Text('Retrieve'),
        onPressed: () {
          if (quantity > 0) {
            selectedQuantity = quantity;
            selectedCompany = company;
            context.read<MortgageSheetCubit>().retrieveStocks(
                company.id, quantity, mortgageDetail.mortgagePrice.toInt());
          }
        },
      ))),
    ]);
  }
}
