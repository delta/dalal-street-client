import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/grpc/subscription.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/StockHistory.pb.dart';
import 'package:equatable/equatable.dart';

part 'stock_history_stream_state.dart';

class StockHistoryStreamCubit extends Cubit<StockHistoryStreamState> {
  late SubscriptionId subscribtionId;

  StockHistoryStreamCubit() : super(StockHistoryStreamInitial());

  void getStockHistoryUpdates(int stockId) async {
    try {
      //subscribing to stockHistory updates
      SubscribeRequest subscribeRequest = SubscribeRequest(
          dataStreamId: stockId.toString(),
          dataStreamType: DataStreamType.STOCK_HISTORY);

      subscribtionId = await subscribe(subscribeRequest, getIt<String>());

      final stockHistoryStream = streamClient.getStockHistoryUpdates(
          subscribtionId,
          options: sessionOptions(getIt()));

      await for (final update in stockHistoryStream) {
        logger.d(update.stockHistory);
        emit(StockHistoryStreamUpdate(update.stockHistory));
      }
    } catch (e) {
      logger.e(e);
      emit(StockHistoryStreamError(e.toString()));
    }
  }

  void unsubscribe() async {
    try {
      unSubscribe(subscribtionId, getIt<String>());
    } catch (e) {
      logger.e('error unsubscribing stock history request', e);
    }
  }
}
