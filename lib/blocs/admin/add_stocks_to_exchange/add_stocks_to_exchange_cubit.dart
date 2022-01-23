import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/AddStocksToExchange.pb.dart';
import 'package:equatable/equatable.dart';

part 'add_stocks_to_exchange_state.dart';

class AddStocksToExchangeCubit extends Cubit<AddStocksToExchangeState> {
  AddStocksToExchangeCubit() : super(AddStocksToExchangeInitial());

  Future<void> addStocksToExchange(
    final stockId,
    final newStocks,
  ) async {
    emit(const AddStocksToExchangeLoading());
    try {
      final resp = await actionClient.addStocksToExchange(
          AddStocksToExchangeRequest(stockId: stockId, newStocks: newStocks),
          options: sessionOptions(getIt()));
      if (resp.statusCode == AddStocksToExchangeResponse_StatusCode.OK) {
        emit(AddStocksToExchangeSuccess(resp.statusMessage));
      } else {
        emit(AddStocksToExchangeFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const AddStocksToExchangeFailure(failedToReachServer));
    }
  }
}
