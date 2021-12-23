import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/datastreams/MarketDepth.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:equatable/equatable.dart';

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
        logger.i(event.subscriptionId);
        await for (final marketDepthUpdates in stockpricesStream) {
          logger.d(marketDepthUpdates.toString());
          emit(SubscriptionToMarketDepthSuccess(marketDepthUpdates));
        }
      } catch (e) {
        logger.e(e);
        emit(SubscriptionToMarketDepthFailed(e.toString()));
      }
    });
  }
}
