import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/grpc/subscription.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/datastreams/StockPrices.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:equatable/equatable.dart';

part 'stockprice_state.dart';

class StockpriceStreamCubit extends Cubit<StockpriceStreamState> {
  late final Subscription subscription;

  StockpriceStreamCubit() : super(StockpriceStreamLoading()) {
    subscription = Subscription();
  }

  // subscribe to stock price stream and listen for updates
  Future<void> start() async {
    try {
      // subscribing to stock prices stream
      final subscriptionId = await subscription.subscribe(
          SubscribeRequest(dataStreamType: DataStreamType.STOCK_PRICES));

      final stockPriceStream =
          streamClient.getStockPricesUpdates(subscriptionId);

      // emitting [StockpriceStreamSuccess] after successful subscription to that stream
      emit(StockpriceStreamSuccess());

      await for (final stockPrices in stockPriceStream) {
        // emitting stock prices on each updates from the server
        emit(StockpriceStreamUpdate(stockPrices));
      }
    } catch (e) {
      emit(StockpriceStreamError(e.toString()));
      logger.e(e);
    }
  }

  @override
  Future<void> close() {
    // unsubscribing to the stream
    subscription.unSubscribe();
    return super.close();
  }
}
