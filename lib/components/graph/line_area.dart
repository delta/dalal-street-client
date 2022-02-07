import 'package:dalal_street_client/blocs/stock_history/history/stock_history_cubit.dart';
import 'package:dalal_street_client/models/time_series_data.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockHistory.pbenum.dart';
import 'package:dalal_street_client/proto_build/models/StockHistory.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LineAreaGraph extends StatelessWidget {
  final int stockId;
  const LineAreaGraph({Key? key, required this.stockId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => StockHistoryCubit(),
        child: LineGraph(stockId: stockId));
  }
}

class LineGraph extends StatefulWidget {
  final int stockId;
  const LineGraph({Key? key, required this.stockId}) : super(key: key);

  @override
  _LineGraphState createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  @override
  void initState() {
    super.initState();
    context.read<StockHistoryCubit>().getStockHistory(
        widget.stockId,
        StockHistoryResolution
            .OneMinute); // using OneMinute resoulution for latest updates
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockHistoryCubit, StockHistoryState>(
      builder: (context, state) {
        if (state is StockHistorySuccess) {
          final Map<String, StockHistory> stockHistoryMap =
              state.stockHistoryMap;

          if (stockHistoryMap.length >= 2) {
            return charts.TimeSeriesChart(
              _getGraphData(stockHistoryMap),
              animate: true,
              domainAxis: const charts.DateTimeAxisSpec(
                renderSpec: charts.NoneRenderSpec(),
                showAxisLine: false,
                // viewport: charts.DateTimeExtents(start: start, end: end)
              ),
              primaryMeasureAxis: const charts.NumericAxisSpec(
                  renderSpec: charts.NoneRenderSpec()),
              customSeriesRenderers: [
                charts.LineRendererConfig(
                    customRendererId: 'area',
                    // includeArea: true,
                    areaOpacity: 0.5,
                    strokeWidthPx: 1.8,
                    includeLine: true)
              ],
            );
          }
        } else if (state is StockHistoryError) {
          // error loading graph

          // TODO : do something better
          return const Text('error loading chart');
        }

        return const Center(
            child: CircularProgressIndicator(
          strokeWidth: 2,
          color: primaryColor,
        ));
      },
    );
  }

  List<charts.Series<TimeSeriesData, DateTime>> _getGraphData(
      Map<String, StockHistory> stockHistoryMap) {
    List<TimeSeriesData> data = [];

    stockHistoryMap.forEach((createdAt, stockHistory) {
      data.add(TimeSeriesData(DateTime.parse(createdAt),
          stockHistory.close.toDouble())); // using close price
    });

    // data from the server is sent in descending order of time
    // TODO change the order in backend ? (same goes for company chart)
    data.sort((a, b) => a.time.compareTo(b.time));

    /// checking lastest 2 values to find if the stock price is increasing or decreasing
    /// [data] List will always be of length >= 2
    bool isIncreasing = true;

    return [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'homepage-graph',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            isIncreasing ? secondaryColor : heartRed),
        data: data,
        domainFn: (TimeSeriesData x, _) => x.time,
        measureFn: (TimeSeriesData y, _) => y.stockPrice,
      )..setAttribute(charts.rendererIdKey, 'area'),
    ];
  }
}
