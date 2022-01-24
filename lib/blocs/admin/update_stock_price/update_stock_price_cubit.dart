import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:equatable/equatable.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/UpdateStockPrice.pb.dart';

part 'update_stock_price_state.dart';

class UpdateStockPriceCubit extends Cubit<UpdateStockPriceState> {
  UpdateStockPriceCubit() : super(UpdateStockPriceInitial());

  Future<void> updateStockPrice(
    final stockId,
    final newPrice,
  ) async {
    emit(const UpdateStockPriceLoading());
    try {
      final resp = await actionClient.updateStockPrice(
          UpdateStockPriceRequest(
            stockId: stockId,
            newPrice: newPrice,
          ),
          options: sessionOptions(getIt()));
      if (resp.statusCode == UpdateStockPriceResponse_StatusCode.OK) {
        emit(UpdateStockPriceSuccess(resp.statusMessage));
      } else {
        emit(UpdateStockPriceFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const UpdateStockPriceFailure(failedToReachServer));
    }
  }
}
