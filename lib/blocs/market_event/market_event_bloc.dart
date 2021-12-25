import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/GetMarketEvents.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/MarketEvents.pb.dart';
import 'package:equatable/equatable.dart';

import '../../proto_build/datastreams/Subscribe.pb.dart';

part 'market_event_event.dart';
part 'market_event_state.dart';

class MarketEventBloc extends Bloc<GetMarketEvent, MarketEventState> {
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

    // on<GetMarketEventFeed>((event, emit) async {
    //     try {
    //       final newsFeed =
    //           streamClient.getMarketEventUpdates(event.subscriptionId);
    //       await for (final news in newsFeed) {
    //         emit(SubscriptionToMarketEventSuccess(news));
    //       }
    //     } catch (e) {
    //       logger.e(e);
    //       emit(SubscriptionToMarketEventFailed(e.toString()));
    //     }
    //   });
  }
}
