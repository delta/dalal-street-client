import 'package:dalal_street_client/blocs/stock_history/history/stock_history_cubit.dart';
import 'package:dalal_street_client/blocs/stock_history/stream/stock_history_stream_cubit.dart';
import 'package:dalal_street_client/components/graph/chart_enum.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockHistory.pbenum.dart';
import 'package:dalal_street_client/proto_build/models/StockHistory.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/resolution_to_str.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interactive_chart/interactive_chart.dart';

class StockChart extends StatelessWidget {
  final int stockId;
  const StockChart({Key? key, required this.stockId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => StockHistoryCubit()),
      BlocProvider(create: (context) => StockHistoryStreamCubit())
    ], child: CandleStickLayout(stockId: stockId));
  }
}

class CandleStickLayout extends StatefulWidget {
  final int stockId;
  const CandleStickLayout({Key? key, required this.stockId}) : super(key: key);

  @override
  _CandleStickLayoutState createState() => _CandleStickLayoutState();
}

class _CandleStickLayoutState extends State<CandleStickLayout> {
  List<StockHistoryResolution> resolution = StockHistoryResolution.values;

  StockHistoryResolution currentResolution = StockHistoryResolution.OneMinute;
  ChartType chart = ChartType.candlestick;

  @override
  void initState() {
    super.initState();
    // subscribing to stockHistory stream
    context
        .read<StockHistoryStreamCubit>()
        .getStockHistoryUpdates(widget.stockId);

    // fetching stockHistory
    context
        .read<StockHistoryCubit>()
        .getStockHistory(widget.stockId, currentResolution);
  }

  @override
  Widget build(BuildContext context) {
    logger.d(currentResolution);
    return Column(
      children: [
        const SizedBox(height: 20),
        _chart(), //graph
        const SizedBox(height: 10.0),
        _resolutionTab(context) // resolution tab
      ],
    );
  }

  Widget _chart() => BlocBuilder<StockHistoryCubit, StockHistoryState>(
        builder: (context, state) {
          if (state is StockHistoryInitial) {
            return const Text('loading');
          } else if (state is StockHistorySuccess) {
            var stockHistoryMap = state.stockHistoryMap;

            List<CandleData> data = [];

            stockHistoryMap.forEach((createdAt, stockHistory) {
              data.add(_extractCandleData(stockHistory));
            });

            return BlocBuilder<StockHistoryStreamCubit,
                StockHistoryStreamState>(
              builder: (context, state) {
                if (state is StockHistoryStreamUpdate) {
                  // TODO check interval and add
                  data.add(_extractCandleData(state.stockHistory));
                }

                if (data.length <= 3) {
                  return const Text(
                      'chart data is insufficient, try again later');
                }

                return SizedBox(
                  height: 250,
                  child: chart == ChartType.candlestick
                      ? _candleStickChart(data)
                      : _lineChart(),
                );
              },
            );
          }

          // return error
          return const Text('error loading graph');
        },
      );

  InteractiveChart _candleStickChart(List<CandleData> data) {
    return InteractiveChart(
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
            .toString() // TODO better timestamps for different resolution
      },
    );
  }

  Widget _lineChart() {
    return Container();
  }

  Row _resolutionTab(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...resolution.map((r) {
          Resolution resolution = resolutionToString(r);
          return TextButton(
            onPressed: () {
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
                padding: const EdgeInsets.all(8),
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
                chart = ChartType.candlestick;
              } else {
                chart = ChartType.line;
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
}
