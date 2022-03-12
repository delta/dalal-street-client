import 'package:dalal_street_client/blocs/stock_history/history/stock_history_cubit.dart';
import 'package:dalal_street_client/blocs/stock_history/stream/stock_history_stream_cubit.dart';
import 'package:dalal_street_client/components/graph/chart_type.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/models/time_series_data.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockHistory.pbenum.dart';
import 'package:dalal_street_client/proto_build/models/StockHistory.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/resolution_conversion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StockChart extends StatelessWidget {
  final int stockId;
  final double? height;
  const StockChart({Key? key, required this.stockId, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => StockHistoryCubit()),
      BlocProvider(create: (context) => StockHistoryStreamCubit())
    ], child: CandleStickLayout(stockId: stockId, height: height ?? 250));
  }
}

class CandleStickLayout extends StatefulWidget {
  final int stockId;
  final double height;
  const CandleStickLayout(
      {Key? key, required this.stockId, required this.height})
      : super(key: key);

  @override
  _CandleStickLayoutState createState() => _CandleStickLayoutState();
}

class _CandleStickLayoutState extends State<CandleStickLayout> {
  List<StockHistoryResolution> resolution = [
    StockHistoryResolution.OneMinute,
    StockHistoryResolution.FiveMinutes,
    StockHistoryResolution.FifteenMinutes,
    StockHistoryResolution.ThirtyMinutes,
    StockHistoryResolution.SixtyMinutes
  ]; // StockHistoryResolution.OneDay is not implemented, hav to remove that from proto

  StockHistoryResolution currentResolution = StockHistoryResolution.OneMinute;
  ChartType chart = ChartType.line;

  @override
  void initState() {
    super.initState();

    // fetching stockHistory
    context
        .read<StockHistoryCubit>()
        .getStockHistory(widget.stockId, currentResolution)
        .then((value) => context
            .read<StockHistoryStreamCubit>()
            .getStockHistoryUpdates(widget.stockId));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _chart(widget.height), //graph
        const SizedBox(height: 10.0),
        _resolutionTab(context), // resolution tab
      ],
    );
  }

  Widget _chart(double height) =>
      BlocBuilder<StockHistoryCubit, StockHistoryState>(
        builder: (context, state) {
          if (state is StockHistoryInitial) {
            return SizedBox(
                height: height, child: const Center(child: DalalLoadingBar()));
          } else if (state is StockHistorySuccess) {
            var stockHistoryMap = state.stockHistoryMap;

            /// better to fill the db with dummy data or running the server for a hour will do
            if (stockHistoryMap.length <= 3) {
              return SizedBox(
                height: height,
                child: const Center(
                  child: Text('chart data is insufficient, try again later'),
                ),
              );
            }

            return chart == ChartType.candlestick
                ? _candleStickChart(stockHistoryMap)
                : _lineChart(stockHistoryMap);
          }

          // return error
          return SizedBox(
              height: height,
              child: const Center(
                  child: Text(
                'error loading graph',
                style: TextStyle(color: heartRed, backgroundColor: redOpacity),
              )));
        },
      );

  Widget _candleStickChart(Map<String, StockHistory> stockHistoryMap) {
    List<CandleData> data = [];

    stockHistoryMap.forEach((createdAt, stockHistory) {
      data.add(_extractCandleData(stockHistory));
    });

    data.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return BlocBuilder<StockHistoryStreamCubit, StockHistoryStreamState>(
      builder: (context, state) {
        if (state is StockHistoryStreamUpdate) {
          if (state.stockHistory.interval ==
              resolutionToInt(currentResolution)) {
            data.add(_extractCandleData(state.stockHistory));
          }
        }

        return SizedBox(
          height: widget.height,
          child: InteractiveChart(
            candles: data,
            style: const ChartStyle(
                volumeHeightFactor: 0,
                priceGainColor: primaryColor,
                priceLossColor: red,
                overlayBackgroundColor: backgroundColor,
                timeLabelStyle: TextStyle(fontSize: 10),
                overlayTextStyle: TextStyle(fontSize: 12)),
            overlayInfo: (candle) => {
              'open': candle.open.toString(),
              'close': candle.close.toString(),
              'low': candle.low.toString(),
              'high': candle.high.toString(),
              'timestamp': DateTime.fromMillisecondsSinceEpoch(candle.timestamp)
                  .toString() // TODO use IST format
            },
          ),
        );
      },
    );
  }

  Widget _lineChart(Map<String, StockHistory> stockHistoryMap) {
    var data = _getLineChartData(stockHistoryMap);

    return BlocBuilder<StockHistoryStreamCubit, StockHistoryStreamState>(
      builder: (context, state) {
        if (state is StockHistoryStreamUpdate) {
          if (state.stockHistory.interval ==
              resolutionToInt(currentResolution)) {
            // TODO dont sort data for stream updates
            stockHistoryMap[state.stockHistory.createdAt] = state.stockHistory;
            data = _getLineChartData(stockHistoryMap);
          }
        }

        return SizedBox(
          height: widget.height,
          child: charts.TimeSeriesChart(
            data,
            animate: false,
            domainAxis: const charts.EndPointsTimeAxisSpec(),
            dateTimeFactory: const charts.LocalDateTimeFactory(),
            // defaultRenderer: charts.BarRendererConfig<DateTime>(), uncomment this for bar chart :)
            customSeriesRenderers: [
              charts.LineRendererConfig(
                  customRendererId: 'area',
                  areaOpacity: 0.2,
                  strokeWidthPx: 2,
                  includeLine: true,
                  includePoints: false,
                  roundEndCaps: true)
            ],
          ),
        );
      },
    );
  }

  Row _resolutionTab(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...resolution.map((r) {
          Resolution resolution = resolutionToString(r);
          return TextButton(
            onPressed: () {
              // TODO show tool tip
              // showTooltip(context, resolution.tooltip);
              setState(() {
                currentResolution = r;
              });

              context
                  .read<StockHistoryCubit>()
                  .getStockHistory(widget.stockId, r);
            },
            child: Text(resolution.shortHand),
            style: TextButton.styleFrom(
                padding: const EdgeInsets.all(15),
                primary: currentResolution == r ? white : whiteWithOpacity50,
                textStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                minimumSize: const Size(30, 30),
                elevation: 0,
                backgroundColor:
                    currentResolution == r ? baseColor : background2),
          );
        }).toList(),
        IconButton(
            onPressed: () {
              if (chart == ChartType.line) {
                setState(() {
                  chart = ChartType.candlestick;
                });
              } else {
                setState(() {
                  chart = ChartType.line;
                });
              }
            },
            icon: const Icon(Icons.show_chart_outlined))
      ],
    );
  }

  CandleData _extractCandleData(StockHistory stockHistory) {
    return CandleData(
        timestamp:
            DateTime.parse(stockHistory.createdAt).millisecondsSinceEpoch,
        open: stockHistory.open.toDouble(),
        close: stockHistory.close.toDouble(),
        high: stockHistory.high.toDouble(),
        low: stockHistory.low.toDouble(),
        volume: null);
  }

  List<charts.Series<TimeSeriesData, DateTime>> _getLineChartData(
      Map<String, StockHistory> stockHistoryMap) {
    List<TimeSeriesData> data = [];

    stockHistoryMap.forEach((createdAt, stockHistory) {
      data.add(TimeSeriesData(DateTime.parse(createdAt),
          stockHistory.close.toDouble())); // using close price
    });

    data.sort((a, b) => a.time.compareTo(b.time));

    return [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'graph',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(secondaryColor),
        data: data,
        domainFn: (TimeSeriesData x, _) => x.time,
        measureFn: (TimeSeriesData y, _) => y.stockPrice,
      )..setAttribute(charts.rendererIdKey, 'area')
    ];
  }
}
