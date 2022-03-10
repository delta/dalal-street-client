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
                            state.askDepth, state.bidDepth),
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

List<DataRow> buildRowsOfMarketDepth(
    List<MarketOrders> askDepthArray, List<MarketOrders> bidDepthArray) {
  List<DataRow> rows = [];

  for (int i = 0; i < 13; i++) {
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
                    height: MediaQuery.of(context).size.height * 0.65,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: background2,
                        borderRadius: BorderRadius.circular(10)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: IntrinsicWidth(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Container(
                                  constraints: const BoxConstraints(minWidth: 330),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 75),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'Buy',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: backgroundColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                DataTable(
                                  columns: <DataColumn>[
                                    _buildDataColumn('Volume'),
                                    _buildDataColumn('Price')
                                  ],
                                  rows:
                                      buildRowsOfMarketDepthWeb(state.bidDepth),
                                  columnSpacing: 80,
                                  dataRowHeight: 50,
                                  headingRowHeight: 50,
                                  headingRowColor:
                                      MaterialStateProperty.all(background3),
                                  border: TableBorder.all(
                                      width: 4,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      style: BorderStyle.solid),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Container(
                                  constraints: const BoxConstraints(minWidth: 330),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 75),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'Sell',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: backgroundColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                DataTable(
                                  columns: <DataColumn>[
                                    _buildDataColumn('Volume'),
                                    _buildDataColumn('Price')
                                  ],
                                  rows:
                                      buildRowsOfMarketDepthWeb(state.askDepth),
                                  columnSpacing: 80,
                                  dataRowHeight: 50,
                                  headingRowHeight: 50,
                                  headingRowColor:
                                      MaterialStateProperty.all(background3),
                                  border: TableBorder.all(
                                      width: 4,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      style: BorderStyle.solid),
                                ),
                              ],
                            ),
                          ],
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

DataColumn _buildDataColumn(String heading) => DataColumn(
      numeric: true,
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(heading,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
            textAlign: TextAlign.center),
      ),
    );

List<DataRow> buildRowsOfMarketDepthWeb(List<MarketOrders> depthArray) {
  List<DataRow> rows = [];
  for (int i = 0; i < 10; i++) {
    String price = i < depthArray.length ? depthArray[i].price.toString() : '';
    String volume =
        i < depthArray.length ? depthArray[i].volume.toString() : '';
    rows.add(marketDepthRowWeb(
        price, volume, i % 2 != 0 ? background3 : background2));
  }
  return rows;
}

DataRow marketDepthRowWeb(String price, String volume, Color bgColor) {
  return DataRow(color: MaterialStateProperty.all(bgColor), cells: <DataCell>[
    DataCell(Center(
        child: Text(
      volume,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20, color: white),
    ))),
    DataCell(Center(
        child: Text(
      price == '0' ? 'Market' : price,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20, color: white),
    )))
  ]);
}
