import 'dart:html';

import 'package:dalal_street_client/blocs/send_dividends/send_dividends_cubit.dart';
import 'package:dalal_street_client/blocs/send_news/send_news_cubit.dart';
import 'package:dalal_street_client/components/fill_max_height_scroll_view.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/SendNews.pb.dart';

import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  //final User user;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Unsubscribe to the streams when the widget is disposed
  // @override
  // void dispose() {
  //   SubscriptionId? _stockPricesSubscriptionId;
  //   final state = context.read<SubscribeCubit>().state;
  //   if (state is SubscriptionDataLoaded) {
  //     _stockPricesSubscriptionId = state.subscriptionId;
  //     context.read<SubscribeCubit>().unsubscribe(_stockPricesSubscriptionId);
  //   }
  //   super.dispose();
  // }

  @override
  initState() {
    super.initState();
    // Get List of Stocks
    context.read<SendNewsCubit>().add(SendNewsCubit());

    // Subscribe to the stream of Stock Prices
    // context.read<SubscribeCubit>().subscribe(DataStreamType.STOCK_PRICES);
    // TODO : Subscribe to the stream of News and Prices Graph
  }

  // return BlocBuilder<MarketEventBloc, MarketEventState>(

  //   builder: (context, state) {
  //logger.i(getIt<String>());
  //     if(state is GetMarketEventSucess)
  //           {
  //             List<MarketEvent> mapMarketEvents = state.marketEventsList.marketEvents;
  //             logger.i(mapMarketEvents[0].headline);

  //           }

  @override
  Widget build(context) => BlocConsumer<SendNewsCubit, SendNewsState>(
        listener: (context, state) {
          if (state is SendNewsFailure) {}
          if (state is SendNewsSuccess) {
            showSnackBar(context, state.news);
          }
        },
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: (() {
              if (state is SendNewsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return buildBody();
            })(),
          ),
        ),
      );

  /*Widget build1(context) =>
      BlocConsumer<SendDividendsCubit, SendDividendsState>(
        listener: (context, state) {
          if (state is SendDividendsFailure) {}
          if (state is SendDividendsSuccess) {
            showSnackBar(state.stockID, state.dividend_amount);
          }
        },
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: (() {
              if (state is SendDividendsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return buildBody();
            })(),
          ),
        ),
      );
      */

  Widget buildBody() => FillMaxHeightScrollView(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [buildButton(context)],
          ),
        ),
      );

  Widget buildButton(context) {
    return Container(
      //appBar: AppBar(
      // title: const Text('Home'),
      // ),
      height: 200,

      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () => _onSendNews(context),
                child: const Text('news sent')),
            TextButton(
                onPressed: () => _onSendDividends(context),
                child: const Text('dividends sent')),
          ],
        ),
      ),
    );
  }

  void _onSendNews(BuildContext context) =>
      context.read<SendNewsCubit>().sendNews('news');

  void _onSendDividends(BuildContext context) =>
      context.read<SendDividendsCubit>().sendDividends(int, int);

  // ignore: non_constant_identifier_names
  /*
  BlocConsumer<SendNewsCubit, SendNewsState> news_list() {
    return BlocConsumer<SendNewsCubit, SendNewsState>(builder: (context, state) {
      if (state is SendNewsSuccess) {
        showSnackBar(context, state.news);
        return const Text('correct');
      } else if (state is SendNewsFailure) {
        return const Text('error');
      } else {
        return Text(state.toString());
      }
    });
  }
  */

}
