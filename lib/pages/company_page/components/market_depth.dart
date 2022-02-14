import 'package:dalal_street_client/blocs/market_depth/market_depth_bloc.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/constants/constants.dart';
import 'package:dalal_street_client/models/market_orders.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget marketDepth(Stock company) {
  return Column(
    children: [
      const SizedBox(
        height: 5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text(
            'Buy',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: white),
            textAlign: TextAlign.start,
          ),
          Text(
            'Sell',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: white),
            textAlign: TextAlign.start,
          ),
        ],
      ),
      BlocBuilder<SubscribeCubit, SubscribeState>(
        builder: (context, state) {
          if (state is SubscriptionDataLoaded) {
            // Start the stream of Market Depths
            context
                .read<MarketDepthBloc>()
                .add(SubscribeToMarketDepthUpdates(state.subscriptionId));

            return BlocBuilder<MarketDepthBloc, MarketDepthState>(
              builder: (context, state) {
                if (state is MarketDepthUpdateState) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text('Volume'),
                          ),
                          DataColumn(
                            label: Text('Price'),
                          ),
                          DataColumn(
                            label: Text('Volume'),
                          ),
                          DataColumn(
                            label: Text('Price'),
                          ),
                        ],
                        rows: buildRowsOfMarketDepth(
                            state.askDepth, state.bidDepth),
                        dataRowHeight: 20,
                      ),
                    ),
                  );
                } else if (state is SubscriptionToMarketDepthFailed) {
                  return Center(
                    child: Text(
                      'Failed to load data \nReason : ${state.error}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: secondaryColor,
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: DalalLoadingBar(),
                  );
                }
              },
            );
          } else if (state is SubscriptonDataFailed) {
            return Center(
              child: Text(
                'Failed to load data \nReason : ${state.message}',
                style: const TextStyle(
                  fontSize: 14,
                  color: secondaryColor,
                ),
              ),
            );
          } else {
            return const Center(
              child: DalalLoadingBar(),
            );
          }
        },
      ),
    ],
  );
}

List<DataRow> buildRowsOfMarketDepth(
    Map<Int64, Int64> askDepth, Map<Int64, Int64> bidDepth) {
  List<DataRow> rows = [];

  final List<MarketOrders> askDepthArray = [];
  final List<MarketOrders> bidDepthArray = [];

  for (var element in askDepth.entries) {
    askDepthArray.add(MarketOrders(element.key, element.value));
  }
  for (var element in bidDepth.entries) {
    bidDepthArray.add(MarketOrders(element.key, element.value));
  }

  askDepthArray.sort((a, b) {
    return (a.price - b.price).toInt();
  });

  bidDepthArray.sort((a, b) {
    if (a.price == 0) return -1;
    if (b.price == 0) return 1;

    return (a.price - b.price).toInt();
  });

  for (int i = 0; i < marketDepthRows; i++) {
    String askPrice =
        i < askDepthArray.length ? askDepthArray[i].price.toString() : '';
    String askVolume =
        i < askDepthArray.length ? askDepthArray[i].volume.toString() : '';
    String bidPrice =
        i < bidDepthArray.length ? bidDepthArray[i].price.toString() : '';
    String bidVolume =
        i < bidDepthArray.length ? bidDepthArray[i].volume.toString() : '';

    rows.add(marketDepthRow(bidPrice, bidVolume, askPrice, askVolume));
  }

  return rows;
}

DataRow marketDepthRow(
    String bidPrice, String bidVolume, String askPrice, String askVolume) {
  return DataRow(
    cells: [
      DataCell(
        Text(
          bidVolume,
          style: const TextStyle(
            fontSize: 12,
            color: white,
          ),
        ),
      ),
      DataCell(
        Text(
          bidPrice == '0' ? 'market' : bidPrice,
          style: const TextStyle(
            fontSize: 12,
            color: secondaryColor,
          ),
        ),
      ),
      DataCell(
        Text(
          askVolume,
          style: const TextStyle(
            fontSize: 12,
            color: white,
          ),
        ),
      ),
      DataCell(
        Text(
          askPrice == '0' ? 'market' : askPrice,
          style: const TextStyle(
            fontSize: 12,
            color: heartRed,
          ),
        ),
      ),
    ],
  );
}
