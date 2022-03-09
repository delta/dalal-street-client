import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetMarketEvents.pb.dart';
import 'package:dalal_street_client/proto_build/models/MarketEvent.pb.dart';
import 'package:equatable/equatable.dart';

part 'market_event_state.dart';

class MarketEventCubit extends Cubit<MarketEventState> {
  MarketEventCubit() : super(MarketEventInitial());

  var lastMarketEventsId = 0;
  var moreExist = true;

  Future<void> getMarketEvents() async {
    try {
      if (lastMarketEventsId == 0) {
        emit(MarketEventInitial());
      }

      if (!moreExist) {
        return;
      }

      final response = await actionClient.getMarketEvents(
          GetMarketEventsRequest(
              lastEventId:
                  lastMarketEventsId == 0 ? 0 : lastMarketEventsId - 1),
          options: sessionOptions(getIt()));

      if (response.statusCode == GetMarketEventsResponse_StatusCode.OK) {
        if (!response.moreExists) {
          moreExist = false;
        }

        if (response.marketEvents.isNotEmpty) {
          lastMarketEventsId =
              response.marketEvents[response.marketEvents.length - 1].id;
        }

        emit(MarketEventSuccess(response.marketEvents));
      } else {
        lastMarketEventsId = 0;
        moreExist = true;
        emit(MarketEventFailure(response.statusMessage));
      }
    } catch (e) {
      lastMarketEventsId = 0;
      moreExist = true;
      emit(const MarketEventFailure(failedToReachServer));
    }
  }

  Future<void> getStockNews(int stockId) async {
    try {
      final response = await actionClient.getMarketEvents(
          GetMarketEventsRequest(stockId: stockId),
          options: sessionOptions(getIt()));

      if (response.statusCode == GetMarketEventsResponse_StatusCode.OK) {
        emit(MarketEventSuccess(response.marketEvents));
      } else {
        emit(MarketEventFailure(response.statusMessage));
      }
    } catch (e) {
      emit(const MarketEventFailure(failedToReachServer));
    }
  }

// returns top 10 latest market events
  Future<void> getLatestEvents() async {
    try {
      final response = await actionClient.getMarketEvents(
          GetMarketEventsRequest(),
          options: sessionOptions(getIt()));

      if (response.statusCode == GetMarketEventsResponse_StatusCode.OK) {
        emit(MarketEventSuccess(response.marketEvents));
      } else {
        emit(MarketEventFailure(response.statusMessage));
      }
    } catch (e) {
      emit(const MarketEventFailure(failedToReachServer));
    }
  }
}
