import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/datastreams/MarketDepth.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';

part 'market_depth_event.dart';
part 'market_depth_state.dart';

class MarketDepthBloc extends Bloc<MarketDepthEvent, MarketDepthState> {
  MarketDepthBloc() : super(MarketDepthInitial()) {
    /// Subscribe to  Market Depth Updates Data Stream
    on<SubscribeToMarketDepthUpdates>((event, emit) async {
      try {
        final stockpricesStream = streamClient.getMarketDepthUpdates(
            event.subscriptionId,
            options: sessionOptions(getIt()));

        // first update from stream contains
        // askDepth and bidDepth
        // and all the subsequent stream update should update the askDepth and bidDepth
        bool isFirstUpdate = true;
        Map<Int64, Int64> askDepth = {}; // key -> price, value -> volume
        Map<Int64, Int64> bidDepth = {};

        await for (final marketDepthUpdates in stockpricesStream) {
          if (isFirstUpdate) {
            isFirstUpdate = false;
            askDepth = marketDepthUpdates.askDepth;
            bidDepth = marketDepthUpdates.bidDepth;
            emit(MarketDepthUpdateState(
                marketDepthUpdates.askDepth, marketDepthUpdates.bidDepth));
            continue;
          }

          final askDiffDepth = marketDepthUpdates.askDepthDiff;
          final bidDiffDepth = marketDepthUpdates.bidDepthDiff;

          // updating askDepth
          askDiffDepth.forEach((price, volume) {
            if (!askDepth.containsKey(price)) {
              askDepth[price] = 0 as Int64;
            }

            askDepth[price] = (askDepth[price]! + volume);

            if (askDepth[price]! <= 0) {
              askDepth.remove(price);
            }
          });

          // updating bidDepth
          bidDiffDepth.forEach((price, volume) {
            if (!bidDepth.containsKey(price)) {
              bidDepth[price] = 0 as Int64;
            }

            bidDepth[price] = (bidDepth[price]! + volume);

            if (bidDepth[price]! <= 0) {
              bidDepth.remove(price);
            }
          });

          emit(MarketDepthUpdateState(askDepth, bidDepth));
        }
      } catch (e) {
        logger.e(e);
        emit(SubscriptionToMarketDepthFailed(e.toString()));
      }
    });
  }
}
