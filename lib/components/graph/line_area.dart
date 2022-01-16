import 'package:dalal_street_client/blocs/stock_history/history/stock_history_cubit.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockHistory.pbenum.dart';
import 'package:dalal_street_client/proto_build/models/StockHistory.pb.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  void initState() {
    super.initState();
    context
        .read<StockHistoryCubit>()
        .getStockHistory(widget.stockId, StockHistoryResolution.OneMinute);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockHistoryCubit, StockHistoryState>(
      builder: (context, state) {
        // LineChartData data = _graphLoadingData();
        if (state is StockHistorySuccess) {
          final Map<String, StockHistory> stockHistoryMap =
              state.stockHistoryMap;
          logger.d(stockHistoryMap.length);
          // data = _graphLoadingData();
        } else if (state is StockHistoryError) {
          // return error loaded failed graph
          // data = _graphLoadingData();
        }

        // logger.d(data);
        // return LineChart(
        //   data,
        // );

        return LineChart(
          LineChartData(
            minX: 0,
            maxX: 11,
            minY: 0,
            maxY: 6,
            // titlesData: LineTitles.getTitleData(),
            gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: const Color(0xff37434d),
                  strokeWidth: 1,
                );
              },
              drawVerticalLine: true,
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: const Color(0xff37434d),
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff37434d), width: 1),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 3),
                  FlSpot(2.6, 2),
                  FlSpot(4.9, 5),
                  FlSpot(6.8, 2.5),
                  FlSpot(8, 4),
                  FlSpot(9.5, 3),
                  FlSpot(11, 4),
                ],
                isCurved: true,
                colors: gradientColors,
                barWidth: 5,
                // dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // LineChartData _graphData (Map<String, StockHistory> stockHistoryMap) {
  //   return LineChartData(

  //   );
  // }

  // LineChartData _graphLoadingData () {
  //   return LineChartData(
  //     minX: 0,
  //     maxX: 59,
  //     minY: 0,
  //     maxY: 1999,
  //     lineBarsData: [
  //       LineChartBarData(
  //         spots: [
  //           const FlSpot(3, 1500),
  //           const FlSpot(10, 1500),
  //           const FlSpot(15, 1500)
  //         ]
  //       )
  //     ]
  //   );
  // }
}
