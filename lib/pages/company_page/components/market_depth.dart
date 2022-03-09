import 'package:dalal_street_client/blocs/market_depth/market_depth_bloc.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/models/market_orders.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget marketDepthMobile(Stock company) {
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
                  logger.d('market depth update');
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
                            state.askDepth, state.bidDepth, false),
                        dataRowHeight: 20,
                      ),
                    ),
                  );
                } else if (state is SubscriptionToMarketDepthFailed) {
                  return const Center(
                    child: Text(
                      'Failed to load data',
                      style: TextStyle(
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
            return const Center(
              child: Text(
                'Failed to load data',
                style: TextStyle(
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

List<DataRow> buildRowsOfMarketDepth(List<MarketOrders> askDepthArray,
    List<MarketOrders> bidDepthArray, bool isWeb) {
  List<DataRow> rows = [];

  for (int i = 0; i < (isWeb ? 17 : 13); i++) {
    String askPrice =
        i < askDepthArray.length ? askDepthArray[i].price.toString() : '';
    String askVolume =
        i < askDepthArray.length ? askDepthArray[i].volume.toString() : '';
    String bidPrice =
        i < bidDepthArray.length ? bidDepthArray[i].price.toString() : '';
    String bidVolume =
        i < bidDepthArray.length ? bidDepthArray[i].volume.toString() : '';

    rows.add(marketDepthRow(bidPrice, bidVolume, askPrice, askVolume, isWeb));
  }

  return rows;
}

DataRow marketDepthRow(String bidPrice, String bidVolume, String askPrice,
    String askVolume, bool isWeb) {
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
          style: TextStyle(
            fontSize: isWeb ? 15 : 12,
            color: secondaryColor,
          ),
        ),
      ),
      DataCell(
        Text(
          askVolume,
          style: TextStyle(
            fontSize: isWeb ? 15 : 12,
            color: white,
          ),
        ),
      ),
      DataCell(
        Text(
          askPrice == '0' ? 'market' : askPrice,
          style: TextStyle(
            fontSize: isWeb ? 15 : 12,
            color: heartRed,
          ),
        ),
      ),
    ],
  );
}

Widget marketDepthWeb(Stock company) {
  return Column(
    children: [
      const SizedBox(
        height: 20,
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
                  return Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: background2,
                        borderRadius: BorderRadius.circular(10)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 120,
                          dataRowHeight: 30,
                          headingRowHeight: 30,
                          headingTextStyle: const TextStyle(
                              color: white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
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
                              state.askDepth, state.bidDepth, true),
                        ),
                      ),
                    ),
                  );
                } else if (state is SubscriptionToMarketDepthFailed) {
                  return const Center(
                    child: Text(
                      'Failed to load data',
                      style: TextStyle(
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
            return const Center(
              child: Text(
                'Failed to load data',
                style: TextStyle(
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
