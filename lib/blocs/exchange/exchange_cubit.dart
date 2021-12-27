import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/BuyStocksFromExchange.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';

part 'exchange_state.dart';

class ExchangeCubit extends Cubit<ExchangeState> {
  ExchangeCubit() : super(ExchangeInitial());

  Future<void> buyStocksFromExchange(int stockId, int stockQuantity) async {
    emit(const ExchangeLoading());
    try {
      final resp = await actionClient.buyStocksFromExchange(
          BuyStocksFromExchangeRequest(
              stockId: stockId, stockQuantity: Int64(stockQuantity)),
          options: sessionOptions(getIt<String>()));
      if (resp.statusCode == BuyStocksFromExchangeResponse_StatusCode.OK) {
        emit(ExchangeSuccess(resp));
      } else {
        logger.e(resp.statusMessage);
        emit(ExchangeFailure(resp.statusMessage));
        emit(ExchangeInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const ExchangeFailure(failedToReachServer));
    }
  }
}
