import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetMarketEvents.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/MarketEvents.pb.dart';
import 'package:equatable/equatable.dart';

import '../../config/get_it.dart';
import '../../proto_build/datastreams/Subscribe.pb.dart';

part 'market_event_event.dart';
part 'market_event_state.dart';

class MarketEventBloc extends Bloc<MarketEventEvents, MarketEventState> {
  MarketEventBloc() : super(MarketEventInitial()) {
    on<GetMarketEvent>((event, emit) async {
      try {
        final GetMarketEventsResponse marketEventResponse =
            await actionClient.getMarketEvents(
          GetMarketEventsRequest(),
          options: sessionOptions(getIt()),
        );

        emit(GetMarketEventSucess(marketEventResponse));
      } catch (e) {
        emit(GetMarketEventFailure(e.toString()));
      }
    });

    on<GetMarketEventFeed>((event, emit) async {
      try {
        final marketeventstream = streamClient.getMarketEventUpdates(
            event.subscriptionId,
            options: sessionOptions(getIt()));
        await for (final marketevent in marketeventstream) {
          emit(SubscriptionToMarketEventSuccess(marketevent));
        }
      } catch (e) {
        logger.e(e);
        emit(SubscriptionToMarketEventFailed(e.toString()));
      }
    });

    on<GetMoreMarketEvent>((event, emit) async {
      try {
        final GetMarketEventsResponse marketEventResponse =
            await actionClient.getMarketEvents(
          GetMarketEventsRequest(lastEventId: event.lasteventid),
          options: sessionOptions(getIt()),
        );

        emit(GetMarketEventSucess(marketEventResponse));
      } catch (e) {
        emit(GetMarketEventFailure(e.toString()));
      }
    });
  }
}
