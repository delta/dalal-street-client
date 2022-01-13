import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockHistory.pb.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockHistory.pbenum.dart';
import 'package:dalal_street_client/proto_build/models/StockHistory.pb.dart';
import 'package:equatable/equatable.dart';

part 'stock_history_state.dart';

/// stockHistoryCubit handles all state and function calls
/// related to static graph for a single [Stock]
///
/// for more information on graph resolution and intervals
/// checkout related proto files
class StockHistoryCubit extends Cubit<StockHistoryState> {
  StockHistoryCubit() : super(StockHistoryInitial());

  Future<void> getStockHistory(
      int stockId, StockHistoryResolution resolution) async {
    try {
      // fetching stock history data
      final response = await actionClient.getStockHistory(
          GetStockHistoryRequest(stockId: stockId, resolution: resolution),
          options: sessionOptions(getIt()));

      if (response.statusCode != GetStockHistoryResponse_StatusCode.OK) {
        // emit error
        emit(const StockHistoryError('error fetching graph data from server'));
      }

      // emit stock history state
      emit(StockHistorySuccess(response.stockHistoryMap));
    } catch (e) {
      logger.e('error $e fetching stock history');
      emit(const StockHistoryError('error connecting with server'));
    }
  }
}
