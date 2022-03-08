import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/grpc/subscription.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/MarketEvent.pb.dart';
import 'package:equatable/equatable.dart';

part 'market_events_stream_state.dart';

class MarketEventsStreamCubit extends Cubit<MarketEventsStreamState> {
  late SubscriptionId subscriptionId;

  MarketEventsStreamCubit() : super(MarketEventsStreamInitial());

  void getMarketEventsUpdates() async {
    try {
      SubscribeRequest subscribeRequest =
          SubscribeRequest(dataStreamType: DataStreamType.MARKET_EVENTS);

      subscriptionId = await subscribe(subscribeRequest, getIt<String>());

      final marketEventsStream = streamClient.getMarketEventUpdates(
          subscriptionId,
          options: sessionOptions(getIt()));

      await for (final updates in marketEventsStream) {
        emit(MarketEventsStreamUpdate(updates.marketEvent));
      }
    } catch (e) {
      emit(MarketEventsStreamError(e.toString()));
    }
  }

  void unsubscribe() async {
    try {
      unSubscribe(subscriptionId, getIt<String>());
    } catch (e) {
      logger.e('error unsubscribing market events stream request', e);
    }
  }
}
