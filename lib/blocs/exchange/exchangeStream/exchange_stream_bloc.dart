import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/datastreams/StockExchange.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:equatable/equatable.dart';

part 'exchange_stream_event.dart';
part 'exchange_stream_state.dart';

class ExchangeStreamBloc
    extends Bloc<ExchangeStreamEvent, ExchangeStreamState> {
  ExchangeStreamBloc() : super(ExchangeStreamInitial()) {
    on<SubscribeToStockExchange>((event, emit) async {
      try {
        final stockExchangeStream = streamClient.getStockExchangeUpdates(
            event.subscriptionId,
            options: sessionOptions(getIt<String>()));

        await for (final stockExchange in stockExchangeStream) {
          logger.d(stockExchange);
          emit(SubscriptionToStockExchangeSuccess(stockExchange));
        }
      } catch (e) {
        logger.e(e);
        emit(SubscriptionToStockExchangeFailed(e.toString()));
      }
    });
  }
}
