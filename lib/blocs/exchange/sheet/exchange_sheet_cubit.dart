import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/BuyStocksFromExchange.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';

part 'exchange_sheet_state.dart';

class ExchangeSheetCubit extends Cubit<ExchangeSheetState> {
  ExchangeSheetCubit() : super(ExchangeSheetInitial());

  Future<void> buyStocksFromExchange(int stockId, int stockQuantity) async {
    try {
      final resp = await actionClient.buyStocksFromExchange(
          BuyStocksFromExchangeRequest(
            stockId: stockId,
            stockQuantity: Int64(stockQuantity),
          ),
          options: sessionOptions(getIt<String>()));
      if (resp.statusCode == BuyStocksFromExchangeResponse_StatusCode.OK) {
        emit(const ExchangeSheetSuccess());
      } else {
        logger.e(resp.statusMessage);
        emit(ExchangeSheetFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const ExchangeSheetFailure(failedToReachServer));
    }
  }
}
