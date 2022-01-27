import 'package:dalal_street_client/blocs/stock_history/stream/stock_history_stream_cubit.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandleStick extends StatelessWidget {
  final int stockId;
  const CandleStick({Key? key, required this.stockId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => SubscribeCubit()),
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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
