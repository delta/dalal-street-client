import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetMarketEvents.pb.dart';
import 'package:equatable/equatable.dart';

import '../../config/get_it.dart';
import '../../proto_build/datastreams/Subscribe.pb.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial()) {
    on<GetNews>((event, emit) async {
      try {
        final GetMarketEventsResponse marketEventResponse =
            await actionClient.getMarketEvents(
          GetMarketEventsRequest(),
          options: sessionOptions(getIt()),
        );

        emit(GetNewsSucess(marketEventResponse));
      } catch (e) {
        emit(const GetNewsFailure(failedToReachServer));
      }
    });
    on<GetMoreNews>((event, emit) async {
      try {
        final GetMarketEventsResponse marketEventResponse =
            await actionClient.getMarketEvents(
          GetMarketEventsRequest(lastEventId: event.lasteventid),
          options: sessionOptions(getIt()),
        );

        emit(GetNewsSucess(marketEventResponse));
      } catch (e) {
        emit(const GetNewsFailure(failedToReachServer));
      }
    });

    on<GetNewsById>((event, emit) async {
      try {
        final GetMarketEventsResponse marketEventResponse =
            await actionClient.getMarketEvents(
          GetMarketEventsRequest(stockId: event.stockId),
          options: sessionOptions(getIt()),
        );

        emit(GetNewsSucess(marketEventResponse));
      } catch (e) {
        emit(const GetNewsFailure(failedToReachServer));
      }
    });
  }
}
