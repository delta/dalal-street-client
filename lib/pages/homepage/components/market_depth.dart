import 'package:dalal_street_client/blocs/market_depth/market_depth_bloc.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/datastreams/MarketDepth.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget marketDepth(Stock company) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text(
            'Bid Depth',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: white),
            textAlign: TextAlign.start,
          ),
          Text(
            'Ask Depth',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: white),
            textAlign: TextAlign.start,
          ),
        ],
      ),
      BlocBuilder<SubscribeCubit, SubscribeState>(
        builder: (context, state) {
          if (state is SubscriptionDataLoaded) {
            logger.i(state.subscriptionId);
            // Start the stream of Market Depths
            context
                .read<MarketDepthBloc>()
                .add(SubscribeToMarketDepthUpdates(state.subscriptionId));
            List<MarketDepthUpdate> marketDepthUpdates = [];
            return BlocBuilder<MarketDepthBloc, MarketDepthState>(
              builder: (context, state) {
                if (state is SubscriptionToMarketDepthSuccess) {
                  logger.i(state.marketDepthUpdate.toString());
                  if (state.marketDepthUpdate.stockId == company.id) {
                    marketDepthUpdates.add(state.marketDepthUpdate);
                  }
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
                        rows: buildRowsOfMarketDepth(marketDepthUpdates),
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
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
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
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
        },
      ),
    ],
  );
}

List<DataRow> buildRowsOfMarketDepth(
    List<MarketDepthUpdate> marketDepthUpdates) {
  return marketDepthUpdates.map((marketDepth) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            marketDepth.bidDepth.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: white,
            ),
          ),
        ),
        DataCell(
          Text(
            marketDepth.bidDepthDiff.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: white,
            ),
          ),
        ),
        DataCell(
          Text(
            marketDepth.askDepth.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: white,
            ),
          ),
        ),
        DataCell(
          Text(
            marketDepth.askDepthDiff.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: white,
            ),
          ),
        ),
      ],
    );
  }).toList();
}
