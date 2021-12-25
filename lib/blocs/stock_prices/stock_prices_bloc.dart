import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/datastreams/StockPrices.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:equatable/equatable.dart';

part 'stock_prices_event.dart';
part 'stock_prices_state.dart';

class StockPricesBloc extends Bloc<StockPricesEvent, StockPricesState> {
  StockPricesBloc() : super(StockPricesInitial()) {
    /// Subscribe to Stock Prices Data Stream
    on<SubscribeToStockPrices>((event, emit) async {
      try {
        final stockpricesStream =
            streamClient.getStockPricesUpdates(event.subscriptionId);
        logger.i(event.subscriptionId);
        await for (final stockPrices in stockpricesStream) {
          logger.d(stockPrices);
          emit(SubscriptionToStockPricesSuccess(stockPrices));
        }
      } catch (e) {
        logger.e(e);
        emit(SubscriptionToStockPricesFailed(e.toString()));
      }
    });
  }
}
